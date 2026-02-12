import 'package:sqflite/sqflite.dart';
import 'database/database_helper.dart';
import 'database/word_repository.dart';
import 'database/sentence_repository.dart';
import 'database/tag_repository.dart';
import 'database/dialogue_repository.dart';
import 'database/material_repository.dart';
import 'database/data_transfer_service.dart';

/// DatabaseService - 로컬 데이터베이스 관리 (Facade)
class DatabaseService {
  static Future<Database> get database => DatabaseHelper.database;

  // --- Database Helper Delegation ---
  static Future<void> reset() => DatabaseHelper.reset();
  static Future<void> close() => DatabaseHelper.close();

  // --- Word Repository Delegation ---
  static Future<int> insertWord(Map<String, dynamic> data) => WordRepository.insert(data);
  static Future<List<Map<String, dynamic>>> searchWords(String query, {int limit = 10}) => WordRepository.search(query, limit: limit);
  static Future<void> toggleWordMemorized(int id, bool status) => WordRepository.updateMemorizedStatus(id, status);

  // --- Sentence Repository Delegation ---
  static Future<int> insertSentence(Map<String, dynamic> data) => SentenceRepository.insert(data);
  static Future<List<Map<String, dynamic>>> searchSentences(String query, {int limit = 10}) => SentenceRepository.search(query, limit: limit);
  static Future<void> toggleSentenceMemorized(int id, bool status) => SentenceRepository.updateMemorizedStatus(id, status);

  // --- Tag Repository Delegation ---
  static Future<List<String>> getAllTags() => TagRepository.getAllTags();
  static Future<List<String>> getAllTagsForLanguage(String langCode) => TagRepository.getAllTagsForLanguage(langCode);
  static Future<void> addTag(int itemId, String itemType, String tag) => TagRepository.addTag(itemId, itemType, tag);

  // --- Dialogue Repository Delegation ---
  static Future<List<Map<String, dynamic>>> getDialogueGroups({String? userId}) => DialogueRepository.getGroups(userId: userId);
  static Future<void> insertDialogueGroup({
    required String id,
    String? userId,
    String? title,
    String? persona,
    String? location,
    String? note,
    required String createdAt,
    Transaction? txn,
  }) => DialogueRepository.insertGroup(
    id: id,
    userId: userId,
    title: title,
    persona: persona,
    location: location,
    note: note,
    createdAt: createdAt,
    txn: txn,
  );
  static Future<void> deleteDialogueGroup(String id) => DialogueRepository.deleteGroup(id);
  static Future<int> getDialogueCount() => DialogueRepository.getDialogueCount();

  // --- Dialogue Participants Delegation ---
  static Future<List<Map<String, dynamic>>> getParticipants(String dialogueId) => DialogueRepository.getParticipants(dialogueId);
  static Future<void> insertParticipant(Map<String, dynamic> data) => DialogueRepository.insertParticipant(data);
  static Future<void> updateParticipant(String id, Map<String, dynamic> data) => DialogueRepository.updateParticipant(id, data);
  static Future<List<Map<String, dynamic>>> getRecordsByDialogueId(String dialogueId, {String? sourceLang, String? targetLang}) => DialogueRepository.getRecordsByDialogueId(dialogueId, sourceLang: sourceLang, targetLang: targetLang);

  // --- Search & Autocomplete Delegation ---
  static Future<List<Map<String, dynamic>>> searchAutocompleteText(String langCode, String text) async {
    final wRes = await WordRepository.searchAutocompleteText(langCode, text);
    final sRes = await SentenceRepository.searchAutocompleteText(langCode, text);
    
    // Deduplicate by text using a map
    final Map<String, Map<String, dynamic>> unique = {};
    for (var item in wRes) unique[item['text']] = item;
    for (var item in sRes) unique[item['text']] = item;
    
    return unique.values.toList();
  }

  static Future<Map<String, dynamic>?> getTranslationIfExists(String lang, int groupId, String targetLang, {String? note}) async {
    final wRes = await WordRepository.getTranslationIfExists(groupId, targetLang, note: note);
    if (wRes != null) return wRes;
    return await SentenceRepository.getTranslationIfExists(groupId, targetLang, note: note);
  }

  static Future<void> toggleMemorizedStatus(int id, String type, bool status) async {
    if (type == 'word') {
      await WordRepository.updateMemorizedStatus(id, status);
    } else {
      await SentenceRepository.updateMemorizedStatus(id, status);
    }
  }

  static Future<List<Map<String, dynamic>>> searchByType(String query, String type, {String? langCode, int limit = 10}) async {
    if (type == 'word') {
      return await WordRepository.search(query, limit: limit);
    } else {
      return await SentenceRepository.search(query, limit: limit);
    }
  }

  // --- Material Repository Delegation ---
  static Future<List<Map<String, dynamic>>> getStudyMaterials() => MaterialRepository.getAll();
  static Future<Map<String, dynamic>?> getStudyMaterialById(int id) => MaterialRepository.getById(id);

  // --- Data Transfer Delegation ---
  static Future<Map<String, dynamic>> importFromJsonWithMetadata(
    String jsonContent, {
    String? overrideSubject,
    String? syncKey,
    String? defaultType,
    String? defaultSourceLang,
    String? defaultTargetLang,
    String? fileName,
    String? userId,
  }) => DataTransferService.importFromJsonWithMetadata(
    jsonContent,
    overrideSubject: overrideSubject,
    syncKey: syncKey,
    defaultType: defaultType,
    defaultSourceLang: defaultSourceLang,
    defaultTargetLang: defaultTargetLang,
    fileName: fileName,
    userId: userId,
  );

  static Future<Map<String, dynamic>> importFromJson(String content, {String? fileName}) {
    return DataTransferService.importFromJsonWithMetadata(content, fileName: fileName);
  }

  static Future<String> exportMaterialToJson(int materialId) => DataTransferService.exportMaterialToJson(
    materialId,
    getRows: (subject) async => [],
    getTags: (id, type) => TagRepository.getTagsForItem(id, type),
  );

  // --- Sync & Utility ---
  static Future<List<int>> getUnsyncedGroupIds({int limit = 50}) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT DISTINCT group_id FROM words WHERE is_synced = 0
      UNION
      SELECT DISTINCT group_id FROM sentences WHERE is_synced = 0
      LIMIT ?
    ''', [limit]);
    return result.map((row) => row['group_id'] as int).toList();
  }

  static Future<Map<String, dynamic>?> fetchGroupSyncData(int groupId) async {
    final db = await database;
    final words = await db.query('words', where: 'group_id = ?', whereArgs: [groupId]);
    final sentences = await db.query('sentences', where: 'group_id = ?', whereArgs: [groupId]);
    return {
      'words': words,
      'sentences': sentences,
    };
  }

  static Future<void> markGroupAsSynced(int groupId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update('words', {'is_synced': 1}, where: 'group_id = ?', whereArgs: [groupId]);
      await txn.update('sentences', {'is_synced': 1}, where: 'group_id = ?', whereArgs: [groupId]);
    });
  }

  static String getLanguageFullName(String code) {
    switch (code) {
      case 'ko': return 'Korean';
      case 'en': return 'English';
      case 'ja': return 'Japanese';
      default: return code;
    }
  }

  static String mapLanguageToCode(String name) {
    final n = name.toLowerCase();
    if (n.contains('kor')) return 'ko';
    if (n.contains('eng')) return 'en';
    if (n.contains('jap')) return 'ja';
    return 'en';
  }

  // --- Cache Delegation ---
  static Future<void> cacheTranslation(String key, String trans) async {
    final db = await database;
    await db.insert('translation_cache', {'cache_key': key, 'translation': trans, 'timestamp': DateTime.now().millisecondsSinceEpoch}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<String?> getCachedTranslation(String key) async {
    final db = await database;
    final res = await db.query('translation_cache', where: 'cache_key = ?', whereArgs: [key]);
    return res.isNotEmpty ? res.first['translation'] as String : null;
  }

  // --- Unified Record ---
  static Future<int> saveUnifiedRecord({
    required String text,
    required String lang,
    required String translation,
    required String targetLang,
    required String type,
    String? pos,
    String? formType,
    String? style,
    String? root,
    String? note,
    List<String>? tags,
    Transaction? txn,
    String? syncSubject,
    int? sequenceOrder,
    int? groupId,
  }) async {
    final timestamp = groupId ?? DateTime.now().millisecondsSinceEpoch;
    final row = {
      'group_id': timestamp,
      'text': text,
      'lang_code': lang,
      'pos': pos,
      'note': note,
      'created_at': DateTime.now().toIso8601String(),
    };

    int id;
    if (type == 'word') {
      row['form_type'] = formType;
      row['root'] = root;
      id = await WordRepository.insert(row, txn: txn);
    } else {
      row['style'] = style;
      id = await SentenceRepository.insert(row, txn: txn);
    }

    if (tags != null) {
      for (var t in tags) {
        await TagRepository.addTag(id, type, t, txn: txn);
      }
    }
    return timestamp;
  }
}
