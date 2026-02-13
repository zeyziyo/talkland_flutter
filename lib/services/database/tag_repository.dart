import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class TagRepository {
  static Future<Database> get _db async => await DatabaseHelper.database;

  static Future<void> addTag(int itemId, String itemType, String tag, {Transaction? txn}) async {
    final executor = txn ?? await _db;
    await executor.insert('item_tags', {
      'item_id': itemId,
      'item_type': itemType,
      'tag': tag,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<String>> getTagsForItem(int itemId, String itemType) async {
    final db = await _db;
    final result = await db.query('item_tags', 
      where: 'item_id = ? AND item_type = ?', 
      whereArgs: [itemId, itemType]);
    return result.map((e) => e['tag'] as String).toList();
  }

  static Future<List<String>> getAllTags() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT DISTINCT tag FROM item_tags ORDER BY tag ASC');
    return result.map((e) => e['tag'] as String).toList();
  }

  static Future<List<String>> getAllTagsForLanguage(String langCode) async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT DISTINCT it.tag FROM item_tags it
      JOIN words w ON it.item_id = w.id AND it.item_type = 'word'
      WHERE w.lang_code = ?
      UNION
      SELECT DISTINCT it.tag FROM item_tags it
      JOIN sentences s ON it.item_id = s.id AND it.item_type = 'sentence'
      WHERE s.lang_code = ?
    ''', [langCode, langCode]);
    return result.map((e) => e['tag'] as String).toList();
  }

  static Future<List<Map<String, dynamic>>> getItemsByTag(String tag, {String? targetLang}) async {
    final db = await _db;
    final String tLang = targetLang ?? 'en'; // Fallback to EN if unspecified
    
    return await db.rawQuery('''
      SELECT w.*, 'words' as origin_table, 
             COALESCE(
               (SELECT text FROM words WHERE group_id = w.group_id AND lang_code = ? LIMIT 1),
               (SELECT text FROM words WHERE group_id = w.group_id AND lang_code != w.lang_code LIMIT 1)
             ) as translation
      FROM words w
      JOIN item_tags it ON w.id = it.item_id AND it.item_type = 'word'
      WHERE it.tag = ?
      UNION ALL
      SELECT s.*, 'sentences' as origin_table,
             COALESCE(
               (SELECT text FROM sentences WHERE group_id = s.group_id AND lang_code = ? LIMIT 1),
               (SELECT text FROM sentences WHERE group_id = s.group_id AND lang_code != s.lang_code LIMIT 1)
             ) as translation
      FROM sentences s
      JOIN item_tags it ON s.id = it.item_id AND it.item_type = 'sentence'
      WHERE it.tag = ?
      ORDER BY created_at ASC
    ''', [tLang, tag, tLang, tag]);
  }

  static Future<void> renameTags(String oldTag, String newTag, {Transaction? txn}) async {
    final executor = txn ?? await _db;
    await executor.update(
      'item_tags',
      {'tag': newTag},
      where: 'tag = ?',
      whereArgs: [oldTag],
    );
  }
}
