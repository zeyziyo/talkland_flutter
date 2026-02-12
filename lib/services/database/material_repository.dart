import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class MaterialRepository {
  static Future<Database> get _db async => await DatabaseHelper.database;

  static Future<int> create({
    required String subject,
    required String source,
    required String sourceLanguage,
    required String targetLanguage,
    String? fileName,
    required String createdAt,
    Transaction? txn,
  }) async {
    final executor = txn ?? await _db;
    return await executor.insert('study_materials', {
      'subject': subject,
      'source': source,
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'file_name': fileName,
      'created_at': createdAt,
      'imported_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<Map<String, dynamic>?> getById(int id) async {
    final db = await _db;
    final result = await db.query('study_materials', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await _db;
    return await db.query('study_materials', orderBy: 'imported_at DESC');
  }
}
