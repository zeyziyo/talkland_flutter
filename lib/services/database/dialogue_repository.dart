import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class DialogueRepository {
  static Future<Database> get _db async => await DatabaseHelper.database;

  static Future<void> insertGroup({
    required String id,
    String? userId,
    String? title,
    String? persona,
    String? location,
    String? note,
    required String createdAt,
    Transaction? txn,
  }) async {
    final executor = txn ?? await _db;
    await executor.insert('dialogue_groups', {
      'id': id,
      'user_id': userId,
      'title': title,
      'persona': persona,
      'location': location,
      'note': note,
      'created_at': createdAt,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteGroup(String id) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete('chat_messages', where: 'dialogue_id = ?', whereArgs: [id]);
      await txn.delete('dialogue_participants', where: 'dialogue_id = ?', whereArgs: [id]);
      await txn.delete('dialogue_groups', where: 'id = ?', whereArgs: [id]);
    });
  }

  static Future<List<Map<String, dynamic>>> getGroups({String? userId}) async {
    final db = await _db;
    if (userId != null) {
      return await db.query('dialogue_groups', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    }
    return await db.query('dialogue_groups', orderBy: 'created_at DESC');
  }

  static Future<void> insertMessage(Map<String, dynamic> data, {Transaction? txn}) async {
    final executor = txn ?? await _db;
    await executor.insert('chat_messages', data);
  }

  static Future<int> getDialogueCount() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM dialogue_groups');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<List<Map<String, dynamic>>> getParticipants(String dialogueId) async {
    final db = await _db;
    return await db.query('dialogue_participants', where: 'dialogue_id = ?', whereArgs: [dialogueId]);
  }

  static Future<void> insertParticipant(Map<String, dynamic> data) async {
    final db = await _db;
    await db.insert('dialogue_participants', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateParticipant(String id, Map<String, dynamic> data) async {
    final db = await _db;
    await db.update('dialogue_participants', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getRecordsByDialogueId(String dialogueId, {String? sourceLang, String? targetLang}) async {
    final db = await _db;
    // Note: Re-implementing the join logic from original DatabaseService
    final result = await db.rawQuery('''
      SELECT m.group_id, m.speaker, m.sequence_order, w.text as word_text, s.text as sentence_text,
             COALESCE(w.lang_code, s.lang_code) as lang_code,
             COALESCE(w.pos, s.pos) as pos,
             w.form_type, w.root, s.style
      FROM chat_messages m
      LEFT JOIN words w ON m.group_id = w.group_id
      LEFT JOIN sentences s ON m.group_id = s.group_id
      WHERE m.dialogue_id = ?
      ORDER BY m.sequence_order ASC
    ''', [dialogueId]);
    return result;
  }
}
