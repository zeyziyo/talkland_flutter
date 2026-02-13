import 'package:workmanager/workmanager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:talkie/services/database_service.dart';
import 'package:talkie/services/supabase_service.dart';

// Key for the background task
const String simpleTaskKey = "talkie.sync.data";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("[BackgroundSync] Executing task: $task");
    
    try {
      if (task == simpleTaskKey) {
        // 1. Initialize dependencies (Workmanager runs in a separate isolate)
        await dotenv.load(fileName: ".env");
        await SupabaseService.initialize();
        
        // 2. Perform Sync
        final result = await BackgroundSyncService.syncData();
        return result;
      }
    } catch (e) {
      print("[BackgroundSync] Error: $e");
      return Future.value(false);
    }
    
    return Future.value(true);
  });
}

class BackgroundSyncService {
  
  /// Initialize Workmanager
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      // isInDebugMode removed (deprecated)
    );
    
    print("[BackgroundSync] Initialized");
  }
  
  /// Register the periodic sync task
  static Future<void> registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      "talkie_sync_task_unique",
      simpleTaskKey,
      frequency: const Duration(minutes: 15), // Minimum interval on Android/iOS
      constraints: Constraints(
        networkType: NetworkType.connected, // Only run when internet is available
      ),
      // existingWorkPolicy removed (build error)
    );
    print("[BackgroundSync] Periodic task registered");
  }

  /// The actual sync logic (Phase 98: Type-aware table sync + tag separation)
  static Future<bool> syncData() async {
    try {
      final currentUser = SupabaseService.client.auth.currentUser;
      if (currentUser == null) {
        print("[BackgroundSync] No authenticated user. Skipping.");
        return true;
      }

      // 1. Get unsynced group IDs
      final unsyncedGroupIds = await DatabaseService.getUnsyncedGroupIds(limit: 10);
      if (unsyncedGroupIds.isEmpty) {
        print("[BackgroundSync] Everything up to date. No sync needed.");
        return true;
      }

      print("[BackgroundSync] Starting sync for ${unsyncedGroupIds.length} groups...");

      for (final groupId in unsyncedGroupIds) {
        // 2. Fetch all data for this group
        final syncData = await DatabaseService.fetchGroupSyncData(groupId);
        if (syncData == null || (syncData['words'] as List).isEmpty && (syncData['sentences'] as List).isEmpty) continue;

        final words = syncData['words'] as List<Map<String, dynamic>>;
        final sentences = syncData['sentences'] as List<Map<String, dynamic>>;
        final tags = syncData['tags'] as List<String>;

        // Phase 107: Resolve Canonical ID before uploading
        // Extract sample for resolution
        final samples = [...words, ...sentences];
        final source = samples.first; // Use first one as source sample
        final target = samples.length > 1 ? samples[1] : samples[0];
        final english = samples.firstWhere((s) => s['lang_code'] == 'en', orElse: () => {});

        int activeGroupId = groupId;
        try {
          final canonicalId = await SupabaseService.resolveCanonicalGroupId(
            sourceText: source['text'],
            sourceLang: source['lang_code'],
            targetText: target['text'],
            targetLang: target['lang_code'],
            englishText: english['text'],
            type: words.contains(source) ? 'word' : 'sentence',
            pos: source['pos'],
            formType: source['form_type'],
            root: source['root'],
            style: source['style'],
            note: source['note'],
          );

          if (canonicalId != groupId) {
             print("[BackgroundSync] Relinking offline group $groupId to canonical $canonicalId");
             await DatabaseService.relinkGroupId(groupId, canonicalId);
             activeGroupId = canonicalId;
          }
        } catch (e) {
          print("[BackgroundSync] Canonical ID resolution failed (offline/error), continuing with local ID: $e");
        }

        // 3. Phase 98: Upload words to 'words' table, sentences to 'sentences' table
        // Use activeGroupId instead of groupId
        final studyMaterials = await DatabaseService.getStudyMaterials();
        final materialSubjects = studyMaterials.map((m) => m['subject'] as String).toSet();
        final titleTags = tags.where((t) => materialSubjects.contains(t)).toList();
        final generalTags = tags.where((t) => !materialSubjects.contains(t)).toList();

        final List<Map<String, dynamic>> cleanWords = [];
        for (var word in words) {
          cleanWords.add({
            'group_id': activeGroupId,
            'text': word['text'],
            'lang_code': word['lang_code'],
            'note': word['note'],
            'pos': word['pos'],
            'form_type': word['form_type'],
            'root': word['root'],
            'tags': generalTags.isNotEmpty ? generalTags : null,
            'author_id': currentUser.id,
            'status': 'approved',
          });
        }

        final List<Map<String, dynamic>> cleanSentences = [];
        for (var sentence in sentences) {
          cleanSentences.add({
            'group_id': activeGroupId,
            'text': sentence['text'],
            'lang_code': sentence['lang_code'],
            'note': sentence['note'],
            'pos': sentence['pos'],
            'style': sentence['style'],
            'tags': generalTags.isNotEmpty ? generalTags : null,
            'author_id': currentUser.id,
            'status': 'approved',
          });
        }

        // Parallel upload to global pool
        if (cleanWords.isNotEmpty) {
          await SupabaseService.client.from('words').upsert(cleanWords, onConflict: 'text, lang_code, author_id');
        }
        if (cleanSentences.isNotEmpty) {
          await SupabaseService.client.from('sentences').upsert(cleanSentences, onConflict: 'text, lang_code, author_id');
        }

        // 4. Update User Library with personal metadata
        await SupabaseService.client.from('user_library').upsert({
          'user_id': currentUser.id,
          'group_id': activeGroupId,
          'content': {
            'words': cleanWords,
            'sentences': cleanSentences,
            'synced_at': DateTime.now().toIso8601String(),
          },
          'material_tags': titleTags.isNotEmpty ? titleTags : null,
          'last_updated': DateTime.now().toIso8601String(),
        }, onConflict: 'user_id, group_id'); // Added missing onConflict for user_library

        // 4. Mark as synced locally
        await DatabaseService.markGroupAsSynced(activeGroupId);
        print("[BackgroundSync] Group $activeGroupId synced successfully.");
      }

      return true;
    } catch (e) {
      print("[BackgroundSync] Error syncing data: $e");
      return false; // Result failure to allow retries by Workmanager
    }
  }
}
