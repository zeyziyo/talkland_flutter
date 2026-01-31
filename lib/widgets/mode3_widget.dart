import 'package:flutter/material.dart';
import 'package:talkie/widgets/mode3_card.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

/// Mode 3: 말하기 모드
/// - 선택한 학습 자료 또는 전체 문장을 바탕으로 발음 연습
/// - 대기 시간 설정 기능 (버튼 방식)
class Mode3Widget extends StatelessWidget {
  final Key? materialDropdownKey;
  final Key? resetButtonKey;

  const Mode3Widget({
    super.key,
    this.materialDropdownKey,
    this.resetButtonKey,
    this.onSelectMaterial,
  });

  final VoidCallback? onSelectMaterial;

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<AppState>(context); // Unused
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final currentQuestion = appState.currentMode3Question;
        
        return SafeArea(
          child: Column(
            children: [
              // ==========================================
              // 1. Top Settings Panel
              // ==========================================
              const SizedBox(height: 16),

              // 스마트 검색바 & 태그 필터 (Pool 필터링용)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Smart Autocomplete Search (Global)
                    LayoutBuilder(
                    builder: (context, constraints) {
                      return Autocomplete<Map<String, String>>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                             return const Iterable<Map<String, String>>.empty();
                          }
                          // Tab-Specific Search
                          return appState.searchByType(textEditingValue.text);
                        },
                        displayStringForOption: (Map<String, String> option) => option['text']!,
                        onSelected: (Map<String, String> selection) {
                           // Just jump to result within current tab
                           appState.jumpToSearchResult(selection['text']!, selection['type']!);
                           if (appState.mode3SessionActive) appState.startMode3SessionDirectly();
                        },
                        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                          // Sync
                          if (appState.searchQuery != textEditingController.text && appState.searchQuery.isNotEmpty) {
                             if (textEditingController.text.isEmpty) { 
                                textEditingController.text = appState.searchQuery;
                             }
                          }
                          return SearchBar(
                            controller: textEditingController,
                            focusNode: focusNode,
                            hintText: appState.recordTypeFilter == 'word' 
                                ? '연습할 단어 검색 (현재 탭)...' 
                                : '연습할 문장 검색 (현재 탭)...',
                            onChanged: (value) {
                              if (value.isEmpty) {
                                appState.setSearchQuery('');
                                if (appState.mode3SessionActive) appState.startMode3SessionDirectly();
                              }
                            },
                            onSubmitted: (value) {
                              appState.setSearchQuery(value);
                              if (appState.mode3SessionActive) appState.startMode3SessionDirectly();
                            },
                            leading: const Icon(Icons.search),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
                            elevation: WidgetStateProperty.all(1),
                             trailing: [
                              if (textEditingController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    textEditingController.clear();
                                    appState.setSearchQuery('');
                                  },
                                ),
                            ],
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final option = options.elementAt(index);
                                    final String note = option['note'] ?? ''; // DatabaseService에서 추가된 note
                                    return ListTile(
                                      leading: const Icon(Icons.search, size: 20, color: Colors.grey),
                                      title: Text(option['text']!),
                                      subtitle: note.isNotEmpty ? Text(_getLocalizedTag(note, l10n), style: const TextStyle(fontSize: 12, color: Colors.blue)) : null,
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                    const SizedBox(height: 8),
                    
                    // Word/Sentence Toggle + Tag Selection Button
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SegmentedButton<String>(
                            segments: [
                              ButtonSegment<String>(
                                value: 'word',
                                label: Text(l10n.tabWord),
                              ),
                              ButtonSegment<String>(
                                value: 'sentence',
                                label: Text(l10n.tabSentence),
                              ),
                            ],
                            selected: {appState.recordTypeFilter},
                            onSelectionChanged: (Set<String> newSelection) {
                              appState.setRecordTypeFilter(newSelection.first);
                              if (appState.mode3SessionActive) appState.startMode3SessionDirectly();
                            },
                            style: SegmentedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 2. Tag Selection Button
                        InkWell(
                          onTap: () => _showTagSelectionDialog(context, appState),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: appState.selectedTags.isEmpty ? Colors.grey[100] : Colors.blue[50], // Active Color
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: appState.selectedTags.isEmpty ? Colors.grey.shade300 : Colors.blue.shade200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer_outlined, 
                                  size: 16, 
                                  color: appState.selectedTags.isEmpty ? Colors.grey.shade600 : Colors.blue.shade700
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  appState.selectedTags.isEmpty 
                                    ? l10n.tagSelection 
                                    : '${l10n.tagSelection} (${appState.selectedTags.length})',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: appState.selectedTags.isEmpty ? Colors.grey.shade700 : Colors.blue.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 3. Show Memorized Switch (Icon Toggle) - Added in Phase 34
                        InkWell(
                          onTap: () => appState.setShowMemorized(!appState.showMemorized),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                            decoration: BoxDecoration(
                              color: appState.showMemorized ? Colors.green[50] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: appState.showMemorized ? Colors.green.shade200 : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  appState.showMemorized ? Icons.visibility : Icons.visibility_off, 
                                  size: 16, 
                                  color: appState.showMemorized ? Colors.green.shade700 : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.labelShowMemorized,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: appState.showMemorized ? Colors.green.shade800 : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              
              // ==========================================
              // 2. Practice Area
              // ==========================================
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (appState.mode3SessionActive && currentQuestion != null) ...[
                            // 1. 연습 영역
                            _buildActivePracticeArea(context, appState, currentQuestion, l10n),
                            const Divider(height: 32),
                          ],
                          
                          // 2. 카드 목록
                          Expanded(
                            child: appState.filteredMaterialRecords.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.library_books_outlined, size: 64, color: Colors.grey[100]),
                                        const SizedBox(height: 16),
                                        Text(l10n.noRecords, style: TextStyle(color: Colors.grey[400])),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 100),
                                    itemCount: appState.filteredMaterialRecords.length,
                                    itemBuilder: (context, index) {
                                      final record = appState.filteredMaterialRecords[index];
                                      return _buildRecordCard(context, appState, record, l10n, index);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),

              // Spacer to ensure separation
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 0.5, color: Colors.grey),
              const SizedBox(height: 16),
            ],
          ),
        );

      },
    );
  }
  
  Widget _buildActivePracticeArea(BuildContext context, AppState appState, Map<String, dynamic> currentQuestion, AppLocalizations l10n) {
     return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🇰🇷", style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  currentQuestion['source_text'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              IconButton(
                icon: Icon(
                  (currentQuestion['is_memorized'] == true) ? Icons.check_circle : Icons.check_circle_outline,
                  color: (currentQuestion['is_memorized'] == true) ? Colors.green : Colors.grey[300],
                ),
                onPressed: () {
                   appState.toggleMemorizedStatus(currentQuestion['id'] as int, currentQuestion['is_memorized'] == true);
                },
              ),
            ],
          ),
          
          if (currentQuestion['note'] != null && (currentQuestion['note'] as String).isNotEmpty) ...[
             const SizedBox(height: 12),
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
               decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[300]!)),
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(Icons.lightbulb_outline, size: 14, color: Colors.amber[700]),
                   const SizedBox(width: 6),
                   Text(currentQuestion['note'] as String, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.grey[700])),
                   const SizedBox(width: 8),
                   Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(4)),
                      child: Text(_getFirstLetterHint(currentQuestion['target_text'] as String), style: TextStyle(fontSize: 12, color: Colors.red[400], fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                   ),
                 ],
               ),
             ),
          ],
          
          const SizedBox(height: 20),
          
          if (appState.showRetryButton) ...[
             if (appState.mode3Score != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
                  child: Column(
                    children: [
                      Text('${l10n.accuracy}: ${appState.mode3Score!.toStringAsFixed(1)}%', style: TextStyle(color: _getScoreColor(appState.mode3Score!), fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 6),
                      Text(currentQuestion['target_text'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey), textAlign: TextAlign.center),
                      const Divider(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${l10n.recognizedText}: ", style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Expanded(child: Text(appState.mode3UserAnswer.isEmpty ? "( ... )" : appState.mode3UserAnswer, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: appState.mode3UserAnswer.isEmpty ? Colors.grey : Colors.black87))),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: () => appState.retryMode3Question(), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Icon(Icons.refresh, size: 24))),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton(onPressed: () => appState.skipMode3Question(), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Icon(Icons.arrow_forward, size: 24))),
                ],
              ),
          ] else ...[
             if (appState.isListening)
               Column(
                 children: [
                    const Text("Listening...", style: TextStyle(color: Colors.red, fontSize: 14)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(onPressed: () => appState.stopMode3ListeningManual(), icon: const Icon(Icons.stop, size: 20), label: Text(l10n.mode3Stop), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
                 ],
               )
             else
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   ElevatedButton.icon(onPressed: () => appState.retryMode3Question(), icon: const Icon(Icons.mic, size: 20), label: Text(l10n.mode3Start), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
                   const SizedBox(width: 12),
                   OutlinedButton.icon(onPressed: () => appState.skipMode3Question(), icon: const Icon(Icons.skip_next, size: 18), label: Text(l10n.mode3Next), style: OutlinedButton.styleFrom(foregroundColor: Colors.grey[700], side: BorderSide(color: Colors.grey[400]!), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
                 ],
               ),
          ],
        ],
     );
  }

  Widget _buildRecordCard(BuildContext context, AppState appState, Map<String, dynamic> record, AppLocalizations l10n, int index) {
    final translationId = record['id'] as int;
    final isSelected = appState.mode3SessionActive && appState.currentMode3Question?['id'] == translationId;
    
    return Mode3Card(
      appState: appState,
      record: record,
      isSelected: isSelected,
      l10n: l10n,
      onSelect: (id) => appState.selectMode3QuestionById(id),
    );
  }

  String _getLocalizedTag(String tag, AppLocalizations l10n) {
    switch (tag.toLowerCase()) {
      case 'noun': return l10n.posNoun;
      case 'verb': return l10n.posVerb;
      case 'adjective': return l10n.posAdjective;
      case 'adverb': return l10n.posAdverb;
      case 'pronoun': return l10n.posPronoun;
      case 'preposition': return l10n.posPreposition;
      case 'conjunction': return l10n.posConjunction;
      case 'interjection': return l10n.posInterjection;
      case 'statement': return l10n.typeStatement;
      case 'question': return l10n.typeQuestion;
      case 'exclamation': return l10n.typeExclamation;
      case 'imperative': return l10n.typeImperative;
      case 'infinitive': return l10n.formInfinitive;
      case 'past': return l10n.formPast;
      case 'past participle': return l10n.formPastParticiple;
      case 'present participle': return l10n.formPresentParticiple;
      case 'present': return l10n.formPresent;
      case '3rd person singular': return l10n.formThirdPersonSingular;
      case 'plural': return l10n.formPlural;
      case 'positive': return l10n.formPositive;
      case 'comparative': return l10n.formComparative;
      case 'superlative': return l10n.formSuperlative;
      case 'subject': return l10n.caseSubject;
      case 'object': return l10n.caseObject;
      case 'possessive': return l10n.casePossessive;
      case 'possessivepronoun': return l10n.casePossessivePronoun;
      case 'reflexive': return l10n.caseReflexive;
      default: return tag;
    }
  }

  String _getFirstLetterHint(String targetText) {
    if (targetText.isEmpty) return "";
    final words = targetText.split(' ');
    if (words.isEmpty) return "";
    final firstWord = words[0];
    if (firstWord.isEmpty) return "";
    return "${firstWord[0]}${'-' * (firstWord.length - 1)}";
  }

  Color _getScoreColor(double score) {
    if (score >= 100) return Colors.green;
    if (score >= 80) return Colors.orange;
    return Colors.red;
  }

  void _showTagSelectionDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.local_offer_outlined, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(l10n.tagSelection),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: appState.availableTags.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(l10n.noRecords, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: appState.availableTags.length,
                            itemBuilder: (context, index) {
                              final tag = appState.availableTags[index];
                              final isSelected = appState.selectedTags.contains(tag);
                              return CheckboxListTile(
                                title: Text(tag),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  appState.toggleTag(tag);
                                  // In Mode 3, if session is active, we might want to refresh it
                                  if (appState.mode3SessionActive) {
                                    appState.startMode3SessionDirectly();
                                  }
                                  setDialogState(() {});
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                dense: true,
                                activeColor: Colors.blue,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              ),
              actions: [
                if (appState.selectedTags.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      appState.clearSelectedTags();
                      if (appState.mode3SessionActive) {
                        appState.startMode3SessionDirectly();
                      }
                      setDialogState(() {});
                    },
                    child: Text(l10n.clearAll, style: const TextStyle(color: Colors.red)),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.confirm),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
