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
}
