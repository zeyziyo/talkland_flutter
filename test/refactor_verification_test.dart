import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:talkie/services/database_service.dart';
import 'package:path/path.dart';

void main() {
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  tearDown(() async {
    // Clean up database after tests
    final dbPath = join(await getDatabasesPath(), 'talkie.db');
    await deleteDatabase(dbPath);
  });

  test('Verify Default Material (ID=0) Creation and Association', () async {
    // 1. Ensure Default Material Exists
    final defaultId = await DatabaseService.getOrCreateDefaultMaterial();
    expect(defaultId, 0, reason: 'Default material ID should be 0');

    final db = await DatabaseService.database;
    final materials = await db.query('study_materials', where: 'id = ?', whereArgs: [0]);
    expect(materials.isNotEmpty, true, reason: 'Material with ID 0 must exist in DB');
    expect(materials.first['subject'], 'No');
    expect(materials.first['source'], 'Google');

    // 2. Simulate Saving a Translation (Mode 1 logic)
    // Create dummy language records first
    final sourceId = await DatabaseService.insertLanguageRecord('en', 'Test Source');
    final targetId = await DatabaseService.insertLanguageRecord('ko', '테스트 타겟');

    // Save link with material ID 0
    await DatabaseService.saveTranslationLink(
      sourceLang: 'en',
      sourceId: sourceId,
      targetLang: 'ko',
      targetId: targetId,
      materialId: 0,
    );

    // 3. Verify Translation Link
    final links = await db.query('translations', 
      where: 'source_id = ? AND target_id = ? AND material_id = ?',
      whereArgs: [sourceId, targetId, 0]
    );

    expect(links.isNotEmpty, true, reason: 'Translation link must be saved with material_id 0');
    
    // 4. Verify "Review All" Query Logic (Mode 3 logic)
    // This query mimics AppState.loadAllRecordsIntoMaterialView
    final allRecords = await db.rawQuery('''
        SELECT t.id 
        FROM translations t
        WHERE t.material_id = 0
    ''');
    expect(allRecords.length, 1, reason: 'Should find the saved record in Review All query');
  });
}
