part of 'app_state.dart';

extension AppStateMode2 on AppState {
  /// Load all study records from Supabase
  Future<void> loadStudyRecords() async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) {
        _studyRecords = [];
        notify();
        return;
      }

      // 1. Fetch User's Library (Groups)
      final libraryResponse = await SupabaseService.client
          .from('user_library')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final libraryEntries = (libraryResponse as List).map((e) => UserLibrary.fromJson(e)).toList();
      
      if (libraryEntries.isEmpty) {
        _studyRecords = [];
        notify();
        return;
      }

      // 2. Fetch Sentences for these groups
      final groupIds = libraryEntries.map((e) => e.groupId).toList();
      
      final sentencesResponse = await SupabaseService.client
          .from('sentences')
          .select()
          .filter('group_id', 'in', groupIds);
          
      final allSentences = (sentencesResponse as List).map((e) => Sentence.fromJson(e)).toList();

      // 3. Assemble Data (Map UserLibrary + Source Sentence + Target Sentence)
      List<Map<String, dynamic>> combinedRecords = [];
      
      for (var entry in libraryEntries) {
        final groupSentences = allSentences.where((s) => s.groupId == entry.groupId).toList();
        
        final sourceSentence = groupSentences.firstWhere(
          (s) => s.langCode == _sourceLang,
          orElse: () => Sentence(id: -1, groupId: -1, langCode: 'unknown', text: 'Unknown', createdAt: DateTime.now()),
        );
        
        final targetSentence = groupSentences.firstWhere(
          (s) => s.langCode == _selectedReviewLanguage,
          orElse: () => Sentence(id: -1, groupId: -1, langCode: 'unknown', text: '', createdAt: DateTime.now()),
        );
        
        if (targetSentence.id == -1) continue;
        if (sourceSentence.id == -1) continue;

        combinedRecords.add({
          'id': entry.groupId,
          'library_uuid': entry.id,
          'group_id': entry.groupId,
          'source_lang': sourceSentence.langCode,
          'target_lang': targetSentence.langCode,
          'source_text': sourceSentence.text,
          'target_text': targetSentence.text,
          'personal_note': entry.personalNote,
          'created_at': entry.createdAt.toIso8601String(),
          'dialogue_id': entry.dialogueId,
          'speaker': entry.speaker,
          'sequence_order': entry.sequenceOrder,
          'review_count': entry.reviewStats['count'] ?? 0,
          'last_reviewed': entry.reviewStats['last_reviewed'],
        });
      }

      _studyRecords = combinedRecords;
      notify();
    } catch (e) {
      debugPrint('[AppState] Error loading study records (Supabase): $e');
      _studyRecords = []; 
      notify();
    }
  }

  /// Set review language filter
  void setReviewLanguage(String lang) {
    _selectedReviewLanguage = lang;
    loadStudyRecords(); // Reload with new filter
  }

  /// Play TTS for a study record
  Future<void> playRecordTts(String text, String lang) async {
    try {
      await _speechService.speak(text, lang: getServiceLocale(lang));
    } catch (e) {
      debugPrint('[AppState] Error playing TTS: $e');
    }
  }

  /// Increment review count (Supabase)
  Future<void> reviewRecord(int groupId) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) return;
      
      final response = await SupabaseService.client
          .from('user_library')
          .select('review_stats')
          .eq('user_id', userId)
          .eq('group_id', groupId)
          .single();
          
      Map<String, dynamic> stats = Map<String, dynamic>.from(response['review_stats'] ?? {});
      int count = (stats['count'] as int? ?? 0) + 1;
      stats['count'] = count;
      stats['last_reviewed'] = DateTime.now().toIso8601String();
      
      await SupabaseService.client
          .from('user_library')
          .update({'review_stats': stats})
          .eq('user_id', userId)
          .eq('group_id', groupId);

      await loadStudyRecords(); // Reload to update UI
    } catch (e) {
      print('Supabase Review Function Error: $e');
    }
  }

  /// Delete a record (Local + Supabase)
  Future<void> deleteRecord(int groupId) async {
    try {
       debugPrint('[AppState] Deleting unified record: groupId=$groupId');

       final db = await DatabaseService.database;
       
       await db.transaction((txn) async {
         await txn.delete('words', where: 'group_id = ?', whereArgs: [groupId]);
         await txn.delete('sentences', where: 'group_id = ?', whereArgs: [groupId]);
       });

       final userId = SupabaseService.client.auth.currentUser?.id;
       if (userId != null) {
          try {
             await SupabaseService.client
                .from('user_library')
                .delete()
                .eq('user_id', userId)
                .eq('group_id', groupId);
          } catch (e) {
             debugPrint('[AppState] Supabase delete failed: $e');
          }
       }
      
      await loadStudyRecords(); 
      await loadRecordsByTags();
      await loadTags();
    } catch (e) {
      debugPrint('[AppState] Error deleting record: $e');
      rethrow;
    }
  }

  /// 태그 목록 로드
  Future<void> loadTags() async {
    try {
      _availableTags = await DatabaseService.getAllTagsForLanguage(_sourceLang);
      notify();
    } catch (e) {
      debugPrint('[AppState] Error loading tags: $e');
    }
  }

  /// 태그 선택 토글
  void toggleTag(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    loadRecordsByTags();
    notify();
  }

  /// 태그 목록 일괄 업데이트
  void updateSelectedTags(List<String> tags) {
    _selectedTags.clear();
    _selectedTags.addAll(tags);
    loadRecordsByTags();
    notify();
  }

  /// 모든 검색 조건 초기화
  void clearSearchConditions() {
    _selectedTags.clear();
    _filterLimit = null;
    _filterStartsWith = null;
    loadRecordsByTags();
    notify();
  }

  void setFilterLimit(int? limit) {
    _filterLimit = limit;
    loadRecordsByTags();
    notify();
  }

  void setFilterStartsWith(String? text) {
    _filterStartsWith = text;
    loadRecordsByTags();
    notify();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadRecordsByTags();
    notify();
  }

  /// 태그 및 검색어 기반 레코드 로드
  Future<void> loadRecordsByTags() async {
    try {
      final db = await DatabaseService.database;
      List<dynamic> whereArgs = [];
      final String table = _recordTypeFilter == 'word' ? 'words' : 'sentences';
      final String itemType = _recordTypeFilter == 'word' ? 'word' : 'sentence';

      String query = 'SELECT t.* FROM $table t ';
      List<String> conditions = [];
      
      conditions.add('t.lang_code = ?');
      whereArgs.add(_sourceLang);
      
      if (_selectedTags.isNotEmpty) {
        for (var tag in _selectedTags) {
          conditions.add('''
            t.group_id IN (
              SELECT DISTINCT w2.group_id FROM words w2 
              JOIN item_tags it2 ON w2.id = it2.item_id AND it2.item_type = 'word'
              WHERE it2.tag = ?
              UNION
              SELECT DISTINCT s2.group_id FROM sentences s2 
              JOIN item_tags it2 ON s2.id = it2.item_id AND it2.item_type = 'sentence'
              WHERE it2.tag = ?
            )
          ''');
          whereArgs.add(tag);
          whereArgs.add(tag);
        }
      }
      
      if (_searchQuery.isNotEmpty) {
        conditions.add('t.text LIKE ?');
        whereArgs.add('%$_searchQuery%');
      }
      
      if (_filterStartsWith != null && _filterStartsWith!.isNotEmpty) {
        conditions.add('t.text LIKE ?');
        whereArgs.add('$_filterStartsWith%');
      }

      if (!_showMemorized) {
        conditions.add('(t.is_memorized IS NULL OR t.is_memorized = 0)');
      }
      
      if (conditions.isNotEmpty) {
         query += 'WHERE ${conditions.join(' AND ')} ';
      }
      
      query += 'GROUP BY t.group_id ';
      query += 'ORDER BY t.created_at DESC ';

      if (_filterLimit != null) {
        query += 'LIMIT ? ';
        whereArgs.add(_filterLimit);
      }

      final List<Map<String, dynamic>> results = await db.rawQuery(query, whereArgs);
      
      if (results.isEmpty) {
        _materialRecords = [];
        notify();
        return;
      }

      final groupIds = results.map((r) => r['group_id'] as int).toList();
      final sourceIds = results.map((r) => r['id'] as int).toList();
      
      final targetRows = await db.query(table, 
          where: 'group_id IN (${groupIds.map((_) => '?').join(',')}) AND (lang_code = ? OR lang_code = ?)', 
          whereArgs: [...groupIds, _targetLang, 'en']);
      
      // Group by groupId for easier lookup
      final Map<int, List<Map<String, dynamic>>> groupMap = {};
      for (var r in targetRows) {
        final gId = r['group_id'] as int;
        groupMap.putIfAbsent(gId, () => []).add(r);
      }

      final tagRows = await db.query('item_tags', 
          where: 'item_id IN (${sourceIds.map((_) => '?').join(',')}) AND item_type = ?', 
          whereArgs: [...sourceIds, itemType]);
      final Map<int, List<String>> tagMap = {};
      for (var tr in tagRows) {
        final id = tr['item_id'] as int;
        tagMap.putIfAbsent(id, () => []).add(tr['tag'] as String);
      }

      List<Map<String, dynamic>> pairedResults = [];
      
      for (var row in results) {
        final groupId = row['group_id'] as int;
        final sourceRow = row;
        
        // Phase 89: Pivot Strategy Fallback
        final groupRows = groupMap[groupId] ?? [];
        Map<String, dynamic>? targetRow = groupRows.firstWhere((r) => r['lang_code'] == _targetLang, orElse: () => {});
        bool isPivot = false;
        
        if (targetRow.isEmpty && _targetLang != 'en') {
          targetRow = groupRows.firstWhere((r) => r['lang_code'] == 'en', orElse: () => {});
          if (targetRow.isNotEmpty) isPivot = true;
        }
        
        if (targetRow.isEmpty) targetRow = null;
        
        pairedResults.add({
          'id': sourceRow['id'], 
          'target_id': targetRow?['id'], 
          'group_id': groupId,
          'type': itemType, 
          'source_lang': _sourceLang,
          'target_lang': _targetLang,
          'source_text': sourceRow['text'],
          'target_text': targetRow != null ? targetRow['text'] : '', 
          'is_pivot': isPivot, // Phase 89: Indicate if this is a pivot fallback
          'note': sourceRow['note'] ?? targetRow?['note'],
          'pos': sourceRow['pos'],
          'form_type': sourceRow['form_type'],
          'root': sourceRow['root'],
          'tags': tagMap[sourceRow['id']] ?? [],
          'created_at': sourceRow['created_at'],
          'review_count': sourceRow['review_count'] ?? 0,
          'is_memorized': (targetRow != null ? targetRow['is_memorized'] : sourceRow['is_memorized']) == 1, 
        });
      }

      _materialRecords = pairedResults;
      notify();
    } catch (e) {
      debugPrint('[AppState] Error loading records by tags: $e');
    }
  }


  /// Toggle is_memorized status (Target Only)
  Future<void> toggleMemorizedStatus(int id, bool currentStatus) async {
    final type = _recordTypeFilter == 'word' ? 'word' : 'sentence';
    await DatabaseService.toggleMemorizedStatus(id, type, !currentStatus);
    
    if (_currentMode3Question != null) {
      final currentTargetId = _currentMode3Question!['target_id'] as int? ?? _currentMode3Question!['id'] as int;
      if (currentTargetId == id) {
         final newMap = Map<String, dynamic>.from(_currentMode3Question!);
         newMap['is_memorized'] = !currentStatus;
         _currentMode3Question = newMap;
         notify(); 
      }
    }

    await loadRecordsByTags();
  }

  /// 기존 호환성 유지용 (Legacy)
  Future<void> loadStudyMaterials() async {
    await loadTags(); 
    _studyMaterials = await DatabaseService.getStudyMaterials(); 
    notify();
  }

  /// 학습 자료 선택 (Legacy & Tag Sync)
  Future<void> selectMaterial(int? id) async {
    _selectedMaterialId = id;
    if (id != null && id != 0) {
      await loadMaterialRecords(id);
    } else {
      await loadRecordsByTags();
    }
    notify();
  }

  Future<void> loadMaterialRecords(int materialId) async {
    if (materialId == 0) {
      await loadRecordsByTags();
    } else {
      final material = _studyMaterials.firstWhere((m) => m['id'] == materialId, orElse: () => {});
      if (material.isNotEmpty) {
        _selectedTags = [material['subject'] as String];
        await loadRecordsByTags();
      }
    }
  }
  
  void setRecordTypeFilter(String filter) {
    _recordTypeFilter = filter;
    if (filter == 'word') {
      _isWordMode = true;
    } else if (filter == 'sentence') {
      _isWordMode = false;
    }
    notify();
  }

  void setShowMemorized(bool value) {
    if (_showMemorized == value) return;
    _showMemorized = value;
    notify();
    loadRecordsByTags();
    if (_mode3SessionActive) {
       _validateCurrentMode3Question();
    }
  }

  /// Play TTS for material record (source or target)
  Future<void> playMaterialTts({
    required String text,
    required String lang,
    int? recordId,
  }) async {
    try {
      await _speechService.speak(text, lang: getServiceLocale(lang));
    } catch (e) {
      debugPrint('[AppState] Error playing material TTS: $e');
    }
  }
}
// End of AppStateMode2
