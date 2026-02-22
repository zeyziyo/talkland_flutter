import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:talkie/services/database/database_helper.dart';
import 'package:talkie/services/database/dialogue_repository.dart';
import 'package:talkie/models/chat_participant.dart';

void main() {
  // Setup sqflite ffi for testing on Windows
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DialogueRepository Fix Verification (Phase 10)', () {
    setUp(() async {
      // Every test starts with a fresh database
      await DatabaseHelper.reset();
    });

    test('Fix Check: Global Participant (Empty dialogue_id) should NOT trigger FK error', () async {
      final p = ChatParticipant(
        id: 'global_user_me',
        name: '나',
        role: 'user',
        dialogueId: '', // No dialogue context
      );
      
      // This call used to fail with SQLITE_CONSTRAINT_FOREIGNKEY before the fix
      // because it tried to insert into dialogue_participants with an empty dialogue_id.
      try {
        await DialogueRepository.insertParticipant(p.toJson());
        print('✅ Successfully inserted global participant without FK error.');
      } catch (e) {
        fail('Failed to insert global participant: $e');
      }
      
      final savedParticipants = await DialogueRepository.getAllUniqueParticipants();
      expect(savedParticipants.length, 1);
      expect(savedParticipants.first.name, '나');
      expect(savedParticipants.first.id, 'global_user_me');
    });

    test('Integration Check: Participant with Dialogue linking', () async {
       const dId = 'dialogue_123';
       
       // 1. Pre-requisite: Create a dialogue group (since dialogue_participants references it)
       await DialogueRepository.insertGroup(
         id: dId,
         title: 'Test Chat',
         createdAt: DateTime.now().toIso8601String(),
       );
       
       // 2. Insert participant with a valid dialogue_id
       final p = ChatParticipant(
         id: 'ai_bot',
         name: 'AI',
         role: 'ai',
         dialogueId: dId,
       );
       
       await DialogueRepository.insertParticipant(p.toJson());
       
       // 3. Verify it is linked to the dialogue
       final participantsInChat = await DialogueRepository.getParticipants(dId);
       expect(participantsInChat.length, 1);
       expect(participantsInChat.first['name'], 'AI');
       expect(participantsInChat.first['role'], 'ai');
    });
  });
}
