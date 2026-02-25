import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../models/chat_participant.dart';
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
    
    // Phase 130 Fix: Avoid ConflictAlgorithm.replace because it triggers ON DELETE CASCADE
    // causing all messages in 'dialogues' table to be deleted when updating a group.
    final existing = await executor.query(
      'dialogue_groups', 
      columns: ['id'], 
      where: 'id = ?', 
      whereArgs: [id],
      limit: 1
    );

    if (existing.isNotEmpty) {
      await executor.update('dialogue_groups', {
        'user_id': userId,
        'title': title,
        'persona': persona,
        'location': location,
        'note': note,
        // created_at should typically NOT be updated, but if needed:
        // 'created_at': createdAt, 
      }, where: 'id = ?', whereArgs: [id]);
    } else {
      await executor.insert('dialogue_groups', {
        'id': id,
        'user_id': userId,
        'title': title,
        'persona': persona,
        'location': location,
        'note': note,
        'created_at': createdAt,
      });
    }
  }

  /// Phase 33: Merge Anonymous sessions to a permanent User ID
  static Future<void> mergeUserSessions(String oldId, String newId) async {
    final db = await _db;
    await db.update(
      'dialogue_groups', 
      {'user_id': newId}, 
      where: 'user_id = ? OR user_id IS NULL OR user_id = ?', 
      whereArgs: [oldId, 'anonymous']
    );
  }

  static Future<void> deleteGroup(String id) async {
    final db = await _db;
    await db.transaction((txn) async {
      final group = await txn.query('dialogue_groups', columns: ['title'], where: 'id = ?', whereArgs: [id], limit: 1);
      if (group.isNotEmpty) {
        // Phase 129: item_tags removed. No action needed.
      }
      // Phase 129: Delete from new dialogues table
      await txn.delete('dialogues', where: 'session_id = ?', whereArgs: [id]);
      await txn.delete('dialogue_participants', where: 'dialogue_id = ?', whereArgs: [id]);
      await txn.delete('dialogue_groups', where: 'id = ?', whereArgs: [id]);
    });
  }

  static Future<List<Map<String, dynamic>>> getGroupsWithCounts({String? userId}) async {
    final db = await _db;
    String whereClause = '';
    List<dynamic> whereArgs = [];
    
    if (userId != null && userId.isNotEmpty) {
      whereClause = 'WHERE user_id = ? OR user_id IS NULL OR user_id = ?';
      whereArgs = [userId, 'anonymous'];
    }

    // Phase 129: Count from dialogues table
    // Phase 160 Fix: Match user ID 'me' for sentence count
    return await db.rawQuery('''
      SELECT d.*,
        (SELECT COUNT(*) FROM dialogues m WHERE m.session_id = d.id AND (LOWER(m.speaker) = 'user' OR m.speaker = 'me')) as sentence_count,
        (SELECT COUNT(*) FROM dialogues m WHERE m.session_id = d.id AND (LOWER(m.speaker) != 'user' AND m.speaker != 'me')) as ai_count
      FROM dialogue_groups d
      $whereClause
      ORDER BY d.created_at DESC
    ''', whereArgs);
  }

  static Future<List<Map<String, dynamic>>> getGroups({String? userId}) async {
    final db = await _db;
    if (userId != null && userId.isNotEmpty) {
      return await db.query(
        'dialogue_groups', 
        where: 'user_id = ? OR user_id IS NULL OR user_id = ?',
        whereArgs: [userId, 'anonymous'],
        orderBy: 'created_at DESC'
      );
    }
    return await db.query('dialogue_groups', orderBy: 'created_at DESC');
  }

  static Future<void> insertMessage(Map<String, dynamic> data, {Transaction? txn}) async {
    final executor = txn ?? await _db;
    // Phase 129/21/28: ID 기반 저장 강화
    // integrated_data_structure.md 규격에 따라 speaker 컬럼에 참여자 ID를 저장합니다.
    // 필드명을 source_text, target_text로 통일하여 UI와 직접 매핑되도록 합니다.
    
    final row = {
      'session_id': data['dialogue_id'] ?? data['session_id'],
      'speaker': data['speaker_id'], // 반드시 ID를 저장 (v14.6)
      'content': data['source_text'] ?? '', 
      'translation': data['target_text'] ?? '',
      'sequence_order': data['sequence_order'], // 순서값 저장
      'created_at': data['created_at'] ?? DateTime.now().toIso8601String(),
    };
    
    // Safety check: speaker_id가 누락된 경우 legacy speaker name이라도 저장 (하지만 경고 로그)
    if (row['speaker'] == null) {
      row['speaker'] = data['speaker'] ?? 'unknown';
      print('[DialogueRepository] WARNING: speaker_id is null for message. Falling back to name: ${row['speaker']}');
    }
    
    await executor.insert('dialogues', row);
  }

  static Future<int> getDialogueCount() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM dialogue_groups');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<List<Map<String, dynamic>>> getParticipants(String dialogueId) async {
    final db = await _db;
    // Phase 1 Step 1: Join Helper
    return await db.rawQuery('''
      SELECT p.* 
      FROM participants p
      INNER JOIN dialogue_participants dp ON p.id = dp.participant_id
      WHERE dp.dialogue_id = ?
    ''', [dialogueId]);
  }

  static Future<void> insertParticipant(Map<String, dynamic> data) async {
    final db = await _db;
    await db.transaction((txn) async {
      // 1. Prepare Master Participant Data
      // data might come in as old flat format {id, dialogue_id, name...}
      // We need to extract Master data.
      
      final String id = data['id'] ?? '${data['role']}_${data['name'].hashCode}'; // Fallback generation
      final String name = data['name'];
      final String role = data['role'];
      
      // Upsert into participants (Master)
      // SQLite REPLACE works as Upsert here
      await txn.insert('participants', {
        'id': id,
        'name': name,
        'role': role,
        'gender': data['gender'],
        'lang_code': data['lang_code'],
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      // 2. Insert Link if dialogue_id is present and valid
      final String? dialogueId = data['dialogue_id'];
      if (dialogueId != null && dialogueId.isNotEmpty) {
        await txn.insert('dialogue_participants', {
          'dialogue_id': dialogueId,
          'participant_id': id,
          'joined_at': DateTime.now().toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    });
  }

  static Future<void> updateParticipant(String id, Map<String, dynamic> data) async {
    final db = await _db;
    // Logic change: updating a participant (e.g. name change) updates the Master record.
    // This affects ALL dialogues they are in, which is the intended behavior of Normalization.
    
    // Filter out link-table specific fields if any
    final masterData = Map<String, dynamic>.from(data);
    masterData.remove('dialogue_id');
    masterData.remove('joined_at');
    
    await db.update('participants', masterData, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getRecordsByDialogueId(
    String dialogueId, {
    String? sourceLang,
    String? targetLang,
  }) async {
    final db = await _db;
    
    // Phase 137/28 Fix: UI 표준 필드명(source_text, target_text)으로 매핑하여 반환
    final List<Map<String, dynamic>> results = await db.query( 
      'dialogues', 
      where: 'session_id = ?', 
      whereArgs: [dialogueId],
      orderBy: 'created_at ASC, rowid ASC'
    );

    return results.map((row) => {
      ...row,
      'source_text': row['content'],
      'target_text': row['translation'],
    }).toList();
  }
  /// Phase 4: Get all unique participants for management UI
  static Future<List<ChatParticipant>> getAllUniqueParticipants() async {
    final db = await _db;
    
    // Safety Check: Table existence
    try {
      final tableCheck = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='participants'");
      debugPrint('[DialogueRepository] Table check "participants": $tableCheck');
      
      final countCheck = await db.rawQuery("SELECT COUNT(*) as count FROM participants");
      debugPrint('[DialogueRepository] Raw count in "participants": $countCheck');
    } catch (e) {
      debugPrint('[DialogueRepository] Safety check failed (might mean table missing): $e');
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT DISTINCT id, name, role, gender, lang_code 
      FROM participants 
      WHERE name != '' AND name != 'Group' AND name != 'group'
    ''');
    debugPrint('[DialogueRepository] getAllUniqueParticipants fetched: ${maps.length} rows');
    
    return List.generate(maps.length, (i) {
      return ChatParticipant(
        id: maps[i]['id'],
        dialogueId: '', // Global list doesn't need dialogue context here
        name: maps[i]['name'],
        role: maps[i]['role'],
        gender: maps[i]['gender'] ?? 'female',
        langCode: maps[i]['lang_code'] ?? 'en_US',
      );
    });
  }

  static Future<void> updateMessageSpeaker(String dialogueId, String oldSpeakerId, String newSpeakerId) async {
    final db = await _db;
    await db.update(
      'dialogues',
      {'speaker': newSpeakerId}, // We store participant_id in 'speaker' column since v19
      where: 'session_id = ? AND speaker = ?',
      whereArgs: [dialogueId, oldSpeakerId],
    );
  }

  static Future<void> removeParticipantFromDialogue(String dialogueId, String participantId) async {
    final db = await _db;
    await db.delete(
      'dialogue_participants',
      where: 'dialogue_id = ? AND participant_id = ?',
      whereArgs: [dialogueId, participantId],
    );
  }

  static Future<void> deleteParticipant(String id) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete('dialogue_participants', where: 'participant_id = ?', whereArgs: [id]);
      await txn.delete('participants', where: 'id = ?', whereArgs: [id]);
    });
  }
}
