import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class WordRepository {
  static Future<Database> get _db async => await DatabaseHelper.database;

  static Future<int> insert(Map<String, dynamic> data, {Transaction? txn}) async {
    final executor = txn ?? await _db;
    return await executor.insert('words', data, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> getWordsByGroupId(int groupId) async {
    final db = await _db;
    return await db.query('words', where: 'group_id = ?', whereArgs: [groupId]);
  }

  static Future<List<Map<String, dynamic>>> search(String query, {int limit = 10}) async {
    final db = await _db;
    return await db.query(
      'words',
      where: 'text LIKE ?',
      whereArgs: ['%$query%'],
      limit: limit,
      orderBy: 'created_at DESC',
    );
  }

  static Future<List<Map<String, dynamic>>> searchAutocompleteText(String langCode, String text) async {
    final db = await _db;
    return await db.query(
      'words',
      columns: ['id', 'text'],
      where: 'lang_code = ? AND text LIKE ?',
      whereArgs: [langCode, '$text%'],
      limit: 10,
    );
  }

  static Future<Map<String, dynamic>?> getTranslationIfExists(int groupId, String targetLang, {String? note}) async {
    final db = await _db;
    final result = await db.query(
      'words',
      where: 'group_id = ? AND lang_code = ?' + (note != null ? ' AND note = ?' : ''),
      whereArgs: [groupId, targetLang, if (note != null) note],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> updateMemorizedStatus(int id, bool status) async {
    final db = await _db;
    await db.update('words', {'is_memorized': status ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }
}
