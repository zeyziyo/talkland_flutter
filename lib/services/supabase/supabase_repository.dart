import 'supabase_helper.dart';
import 'supabase_auth_service.dart';

class SupabaseRepository {
  static String _getTable(String type) => type == 'word' ? 'public_words' : 'public_sentences';

  static Future<void> saveEntry({
    required int groupId,
    required String text,
    required String langCode,
    required String type,
    String? note,
    String? pos,
    String? formType,
    String? root,
    String? style,
    List<String>? tags,
  }) async {
    final data = <String, dynamic>{
      'group_id': groupId,
      'text': text,
      'lang_code': langCode,
      'note': note,
      'pos': pos,
      'tags': tags,
      'status': 'approved',
      'author_id': SupabaseAuthService.currentUser?.id,
    };

    if (type == 'word') {
      data['form_type'] = formType;
      data['root'] = root;
    } else {
      data['style'] = style;
    }

    await SupabaseHelper.client.from(_getTable(type)).insert(data);
  }

  static Future<int?> findGroupId(String text, String langCode) async {
    final wordRes = await SupabaseHelper.client
        .from('public_words')
        .select('group_id')
        .eq('text', text)
        .eq('lang_code', langCode)
        .maybeSingle();
    if (wordRes != null) return wordRes['group_id'] as int;

    final sentRes = await SupabaseHelper.client
        .from('public_sentences')
        .select('group_id')
        .eq('text', text)
        .eq('lang_code', langCode)
        .maybeSingle();
    if (sentRes != null) return sentRes['group_id'] as int;

    return null;
  }

  /// Phase 106: Intelligent group ID search using source, target and pivot
  static Future<int?> findGroupIdWithPivot({
    required String sourceText,
    required String sourceLang,
    required String targetText,
    required String targetLang,
    String? englishText,
  }) async {
    // 1. Check Source
    int? groupId = await findGroupId(sourceText, sourceLang);
    if (groupId != null) return groupId;
    
    // 2. Check Target
    groupId = await findGroupId(targetText, targetLang);
    if (groupId != null) return groupId;
    
    // 3. Check English Pivot (Shared Dictionary Point)
    if (englishText != null && sourceLang != 'en' && targetLang != 'en') {
      groupId = await findGroupId(englishText, 'en');
      if (groupId != null) return groupId;
    }
    
    return null;
  }

  static Future<int> getNextGroupId() async {
    try {
      final response = await SupabaseHelper.client.rpc('next_group_id');
      if (response != null) return response as int;
    } catch (_) {}
    return DateTime.now().millisecondsSinceEpoch;
  }

  static Future<void> addToLibrary({
    required int groupId,
    required String type,
    String? note,
    String? sourceLang,
    String? targetLang,
    List<String>? tags,
    int? reviewCount,
    bool? isMemorized,
    String? lastReviewed,
    String? notebookTitle,
  }) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) return;
    
    final table = type == 'word' ? 'words_meta' : 'sentences_meta';
    
    await SupabaseHelper.client.from(table).upsert({
      'user_id': userId,
      'group_id': groupId,
      'notebook_title': notebookTitle ?? 'My Collection',
      'source_lang': sourceLang,
      'target_lang': targetLang,
      'tags': tags,
      'is_memorized': (isMemorized == true) ? 1 : 0,
      'review_count': reviewCount ?? 0,
      'last_reviewed': lastReviewed,
      'caption': note, // Note maps to caption in meta tables
    }, onConflict: 'user_id, group_id, notebook_title');
  }

  // Dialogue Operations
  static Future<String> createDialogueGroup({
    String? id, 
    String? title, 
    String? persona,
    String? location,
    String? note,
  }) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = {
      'user_id': userId,
      'title': title,
      'persona': persona,
      'location': location,
      'note': note,
    };
    
    if (id != null) {
      data['id'] = id;
    }

    final response = await SupabaseHelper.client
        .from('dialogue_groups')
        .upsert(data, onConflict: 'id')
        .select('id')
        .single();

    return response['id'] as String;
  }

  static Future<void> updateDialogueTitle(String id, String title) async {
    await SupabaseHelper.client.from('dialogue_groups').update({'title': title}).eq('id', id);
  }

  static Future<void> deleteDialogueGroup(String id) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) return;

    await SupabaseHelper.client.from('dialogue_groups').delete().eq('id', id).eq('user_id', userId);
  }

  /// Phase 33: Merge anonymous data to permanent user ID on Supabase server
  static Future<void> mergeUserSessions(String oldId, String newId) async {
    if (oldId == newId) return;
    
    // 1. Update primary ownership in dialogue_groups
    await SupabaseHelper.client
        .from('dialogue_groups')
        .update({'user_id': newId})
        .eq('user_id', oldId);
        
    // 2. Update messages ownership
    await SupabaseHelper.client
        .from('dialogue_messages')
        .update({'user_id': newId})
        .eq('user_id', oldId);
        
    // 3. Update Meta ownership
    await SupabaseHelper.client
        .from('words_meta')
        .update({'user_id': newId})
        .eq('user_id', oldId);
    await SupabaseHelper.client
        .from('sentences_meta')
        .update({'user_id': newId})
        .eq('user_id', oldId);
    
    // 4. Update Participants ownership
    await SupabaseHelper.client
        .from('participants')
        .update({'user_id': newId})
        .eq('user_id', oldId);

    // 5. Update Link Table ownership
    await SupabaseHelper.client
        .from('dialogue_participants')
        .update({'user_id': newId})
        .eq('user_id', oldId);
        
    print('[SupabaseRepo] Cloud data ownership transferred: $oldId -> $newId');
  }

  // Phase 131: Chat Isolation - Use dedicated 'dialogue_messages' table
  static Future<void> saveChatMessage({
    required String dialogueId,
    required String sourceText,
    required String targetText,
    required String sourceLang,
    required String targetLang,
    required String speaker,
    required int sequenceOrder,
  }) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) return;

    await SupabaseHelper.client.from('dialogue_messages').insert({
      'user_id': userId,
      'session_id': dialogueId, // dialogue_id -> session_id (설계 5.2.C.4)
      'speaker': speaker,
      'content': sourceText,    // source_text -> content (설계 5.2.C.4)
      'translation': targetText, // target_text -> translation (설계 5.2.C.4)
      'sequence_order': sequenceOrder,
    });
  }

  static Future<List<Map<String, dynamic>>> getChatMessages(String dialogueId) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) return [];

    final response = await SupabaseHelper.client
        .from('dialogue_messages')
        .select() // Select all fields
        .eq('user_id', userId)
        .eq('session_id', dialogueId)
        .order('sequence_order', ascending: true);

    return (response as List).map((msg) {
      return {
        'id': msg['id'],
        'session_id': msg['session_id'],
        'source_text': msg['content'],    // UI 호환성을 위해 필드 매핑 유지
        'target_text': msg['translation'],
        'speaker': msg['speaker'],
        'sequence_order': msg['sequence_order'],
        'created_at': msg['created_at'],
      };
    }).toList();
  }

  // Phase 33: Get Dialogue Participants for Restore/Sync
  static Future<List<Map<String, dynamic>>> getDialogueParticipants(String dialogueId) async {
    try {
      final response = await SupabaseHelper.client
          .from('dialogue_participants')
          .select('joined_at, participants(id, name, role, gender, lang_code, avatar_color, created_at)')
          .eq('dialogue_id', dialogueId);
      
      return (response as List).map((row) {
        final p = row['participants'] as Map<String, dynamic>;
        return {
          'id': p['id'],
          'name': p['name'],
          'role': p['role'],
          'gender': p['gender'],
          'lang_code': p['lang_code'],
          'avatar_color': p['avatar_color'],
          'created_at': p['created_at'],
          'joined_at': row['joined_at'],
        };
      }).toList();
    } catch (e) {
      print('[SupabaseRepo] Error getting participants: $e');
      return [];
    }
  }

  // Phase 33: Get Message Count for Restore/Sync
  static Future<int> getChatMessageCount(String dialogueId) async {
    try {
      final response = await SupabaseHelper.client
          .from('dialogue_messages')
          .select('id')
          .eq('session_id', dialogueId);
      
      return (response as List).length;
    } catch (e) {
      print('[SupabaseRepo] Error getting message count: $e');
      return 0;
    }
  }

  // Phase 140: Sync Participants to Supabase (Blueprint Alignment)
  static Future<void> syncParticipant({
    required String dialogueId,
    required String id,
    required String name,
    required String role,
    String? gender,
    String? langCode,
    int? avatarColor,
  }) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) return;

    // 1. Upsert to participants (Master Profile)
    await SupabaseHelper.client.from('participants').upsert({
      'user_id': userId,
      'id': id,
      'name': name,
      'role': role,
      'gender': gender,
      'lang_code': langCode,
      'avatar_color': avatarColor,
    }, onConflict: 'user_id, id');

    // 2. Link to Dialogue
    await SupabaseHelper.client.from('dialogue_participants').upsert({
      'user_id': userId,
      'dialogue_id': dialogueId,
      'participant_id': id,
      'joined_at': DateTime.now().toIso8601String(),
    }, onConflict: 'dialogue_id, participant_id');
  }
}
