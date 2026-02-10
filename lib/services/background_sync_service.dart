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

  /// The actual sync logic (Phase 81.1)
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
        // 2. Fetch all data for this group ( 정합성 확보를 위해 그룹 단위 수집 )
        final syncData = await DatabaseService.fetchGroupSyncData(groupId);
        if (syncData == null) continue;

        final words = syncData['words'] as List<Map<String, dynamic>>;
        final sentences = syncData['sentences'] as List<Map<String, dynamic>>;
        final tags = syncData['tags'] as List<String>;

        // 3. Supabase 'user_library'에 업로드 (Edge Function 또는 RPC 대신 바로 Upsert)
        // Note: Supabase DB 구조에 따라 달라질 수 있으나, 기존 패턴인 'user_library' 테이블 활용
        await SupabaseService.client.from('user_library').upsert({
          'user_id': currentUser.id,
          'group_id': groupId,
          'content': {
            'words': words,
            'sentences': sentences,
            'tags': tags,
            'synced_at': DateTime.now().toIso8601String(),
          },
          'last_updated': DateTime.now().toIso8601String(),
        });

        // 4. Mark as synced locally
        await DatabaseService.markGroupAsSynced(groupId);
        print("[BackgroundSync] Group $groupId synced successfully.");
      }

      return true;
    } catch (e) {
      print("[BackgroundSync] Error syncing data: $e");
      return false; // Result failure to allow retries by Workmanager
    }
  }
}
