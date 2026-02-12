import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase/supabase_helper.dart';
import 'supabase/supabase_repository.dart';
import 'supabase/supabase_edge_service.dart';
import 'supabase/supabase_auth_service.dart';

/// SupabaseService - 클라우드 서비스 관리 (Facade)
class SupabaseService {
  static SupabaseClient get client => SupabaseHelper.client;

  static Future<void> initialize() async {
    await SupabaseHelper.initialize();
    await SupabaseAuthService.signInAnonymously();
  }

  // Edge Functions Delegation
  static Future<Map<String, dynamic>> translateAndValidate({
    required String text,
    required String sourceLang,
    required String targetLang,
    String? note,
  }) => SupabaseEdgeService.translateAndValidate(
    text: text,
    sourceLang: sourceLang,
    targetLang: targetLang,
    note: note,
  );

  static Future<Map<String, dynamic>> processChat({
    required String text,
    required String context,
    required String targetLang,
    List<Map<String, dynamic>>? history,
  }) => SupabaseEdgeService.processChat(
    text: text,
    context: context,
    targetLang: targetLang,
    history: history,
  );

  static Future<List<String>> suggestTitles({
    required List<Map<String, dynamic>> history,
  }) => SupabaseEdgeService.suggestTitles(history: history);

  static Future<Map<String, dynamic>> getRecommendations({
    required List<Map<String, dynamic>> history,
    required String sourceLang,
    required String targetLang,
  }) => SupabaseEdgeService.getRecommendations(
    history: history,
    sourceLang: sourceLang,
    targetLang: targetLang,
  );

  // Repository Delegation
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
  }) => SupabaseRepository.saveEntry(
    groupId: groupId,
    text: text,
    langCode: langCode,
    type: type,
    note: note,
    pos: pos,
    formType: formType,
    root: root,
    style: style,
    tags: tags,
  );

  static Future<int?> findGroupId(String text, String langCode) => SupabaseRepository.findGroupId(text, langCode);

  static Future<int?> findGroupIdWithPivot({
    required String sourceText,
    required String sourceLang,
    required String targetText,
    required String targetLang,
    String? englishText,
  }) async {
    int? groupId = await findGroupId(sourceText, sourceLang);
    if (groupId != null) return groupId;
    groupId = await findGroupId(targetText, targetLang);
    if (groupId != null) return groupId;
    if (englishText != null && sourceLang != 'en' && targetLang != 'en') {
      groupId = await findGroupId(englishText, 'en');
      if (groupId != null) return groupId;
    }
    return null;
  }

  // Complex Operations (Keep in facade or move to logic layer if needed)
  static Future<Map<String, dynamic>> importJsonEntry({
    required String sourceText,
    required String sourceLang,
    required String targetText,
    required String targetLang,
    String? note,
    String? pos,
    String? formType,
    String? root,
    String? style,
    String? type,
    List<String>? tags,
    String? syncSubject,
  }) async {
    try {
      final validation = await translateAndValidate(
        text: sourceText,
        sourceLang: sourceLang,
        targetLang: targetLang,
        note: note,
      );
      
      if (validation['isValid'] != true) {
        return {'success': false, 'reason': 'Content Policy: ${validation['reason'] ?? 'Unknown'}'};
      }
      
      final englishText = validation['englishText'] as String?;
      int? groupId = await findGroupIdWithPivot(
        sourceText: sourceText,
        sourceLang: sourceLang,
        targetText: targetText,
        targetLang: targetLang,
        englishText: englishText,
      );
      
      if (groupId == null) {
        groupId = await SupabaseRepository.getNextGroupId();
        await saveEntry(
          groupId: groupId,
          text: sourceText,
          langCode: sourceLang,
          type: type ?? 'sentence',
          note: note,
          pos: pos ?? validation['pos'] as String?,
          formType: formType ?? validation['formType'] as String?,
          root: root ?? validation['root'] as String?,
          style: style ?? validation['style'] as String?,
          tags: tags,
        );

        if (englishText != null && sourceLang != 'en' && targetLang != 'en') {
          await saveEntry(groupId: groupId, text: englishText, langCode: 'en', type: type ?? 'sentence');
        }
      }

      await saveEntry(groupId: groupId, text: targetText, langCode: targetLang, type: type ?? 'sentence');
      
      final materialTags = syncSubject != null ? [syncSubject] : <String>[];
      await SupabaseRepository.addToLibrary(groupId, note, materialTags: materialTags);
      
      return {'success': true, 'id': groupId};
    } catch (e) {
      return {'success': false, 'reason': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> importDialogueMessage({
    required String dialogueId,
    required String sourceText,
    required String sourceLang,
    required String targetText,
    required String targetLang,
    required String speaker,
    required int sequenceOrder,
    String? pos,
    String? formType,
    String? root,
    String? style,
  }) async {
    try {
      int? groupId = await findGroupId(sourceText, sourceLang);
      if (groupId == null) {
        groupId = DateTime.now().millisecondsSinceEpoch;
        final itemType = (sourceText.split(' ').length > 3) ? 'sentence' : 'word';
        await saveEntry(
          groupId: groupId,
          text: sourceText,
          langCode: sourceLang,
          type: itemType,
          pos: pos,
          formType: formType,
          root: root,
          style: style,
        );
      }
      await saveEntry(groupId: groupId, text: targetText, langCode: targetLang, type: 'sentence');
      await SupabaseRepository.addToLibrary(groupId, null, dialogueId: dialogueId, speaker: speaker, sequenceOrder: sequenceOrder);
      return {'success': true};
    } catch (e) {
      return {'success': false, 'reason': e.toString()};
    }
  }

  static Future<List<Map<String, dynamic>>> getPrivateChatMessages(String dialogueId) => SupabaseRepository.getPrivateChatMessages(dialogueId);

  static Future<void> savePrivateChatMessage({
    required String dialogueId,
    required String sourceText,
    required String targetText,
    required String sourceLang,
    required String targetLang,
    required String speaker,
    required int sequenceOrder,
    String? note,
    String? style,
  }) async {
    final groupId = DateTime.now().millisecondsSinceEpoch;
    await saveEntry(groupId: groupId, text: sourceText, langCode: sourceLang, type: 'sentence', style: style);
    await saveEntry(groupId: groupId, text: targetText, langCode: targetLang, type: 'sentence');
    await SupabaseRepository.addToLibrary(groupId, note, dialogueId: dialogueId, speaker: speaker, sequenceOrder: sequenceOrder);
  }

  // Dialogue Group Delegation
  static Future<String> createDialogueGroup({String? title, String? persona}) => SupabaseRepository.createDialogueGroup(title: title, persona: persona);
  static Future<void> updateDialogueTitle(String id, String title) => SupabaseRepository.updateDialogueTitle(id, title);
  static Future<void> deleteDialogueGroup(String id) => SupabaseRepository.deleteDialogueGroup(id);

  // Legacy wrappers
  static Future<void> saveSentence({required int groupId, required String text, required String langCode, String? note}) => 
    saveEntry(groupId: groupId, text: text, langCode: langCode, type: 'sentence', note: note);
}
