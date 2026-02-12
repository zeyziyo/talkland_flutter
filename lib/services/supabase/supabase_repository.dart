import 'supabase_helper.dart';
import 'supabase_auth_service.dart';

class SupabaseRepository {
  static String _getTable(String type) => type == 'word' ? 'words' : 'sentences';

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
        .from('words')
        .select('group_id')
        .eq('text', text)
        .eq('lang_code', langCode)
        .maybeSingle();
    if (wordRes != null) return wordRes['group_id'] as int;

    final sentRes = await SupabaseHelper.client
        .from('sentences')
        .select('group_id')
        .eq('text', text)
        .eq('lang_code', langCode)
        .maybeSingle();
    if (sentRes != null) return sentRes['group_id'] as int;

    return null;
  }

  static Future<int> getNextGroupId() async {
    try {
      final response = await SupabaseHelper.client.rpc('next_group_id');
      if (response != null) return response as int;
    } catch (_) {}
    return DateTime.now().millisecondsSinceEpoch;
  }

  static Future<void> addToLibrary(int groupId, String? note, {String? dialogueId, String? speaker, int? sequenceOrder, List<String>? materialTags}) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) return;
    
    await SupabaseHelper.client.from('user_library').upsert({
      'user_id': userId,
      'group_id': groupId,
      'dialogue_id': dialogueId,
      'speaker': speaker,
      'sequence_order': sequenceOrder,
      'personal_note': note,
      'material_tags': materialTags,
    }, onConflict: 'user_id, group_id, dialogue_id');
  }

  // Dialogue Operations
  static Future<String> createDialogueGroup({String? title, String? persona}) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await SupabaseHelper.client.from('dialogue_groups').insert({
      'user_id': userId,
      'title': title,
      'persona': persona,
    }).select('id').single();

    return response['id'] as String;
  }

  static Future<void> updateDialogueTitle(String id, String title) async {
    await SupabaseHelper.client.from('dialogue_groups').update({'title': title}).eq('id', id);
  }

  static Future<void> deleteDialogueGroup(String id) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) return;

    await SupabaseHelper.client.from('dialogue_groups').delete().eq('id', id).eq('user_id', userId);
    await SupabaseHelper.client.from('user_library').delete().eq('dialogue_id', id).eq('user_id', userId);
  }

  static Future<List<Map<String, dynamic>>> getPrivateChatMessages(String dialogueId) async {
    final userId = SupabaseAuthService.currentUser?.id;
    if (userId == null) return [];

    final response = await SupabaseHelper.client
        .from('user_library')
        .select('group_id, speaker, sequence_order, created_at, personal_note, sentences(text, lang_code)')
        .eq('user_id', userId)
        .eq('dialogue_id', dialogueId)
        .order('sequence_order', ascending: true);

    return (response as List).map((link) {
      final sentences = link['sentences'] as List;
      final source = sentences.firstWhere((s) => s['lang_code'] != 'en', orElse: () => sentences.first);
      final target = sentences.firstWhere((s) => s['lang_code'] == 'en', orElse: () => sentences.last);

      return {
        'group_id': link['group_id'],
        'source_text': source['text'],
        'target_text': target['text'],
        'speaker': link['speaker'],
        'sequence_order': link['sequence_order'],
        'created_at': link['created_at'],
        'note': link['personal_note'],
      };
    }).toList();
  }
}
