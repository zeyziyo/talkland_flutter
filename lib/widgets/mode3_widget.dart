import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

/// Mode 3: 학습 자료 - JSON 파일 불러와서 학습
class Mode3Widget extends StatefulWidget {
  const Mode3Widget({super.key});

  @override
  State<Mode3Widget> createState() => _Mode3WidgetState();
}

class _Mode3WidgetState extends State<Mode3Widget> {

  
  @override
  void initState() {
    super.initState();
    // Load study materials when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.loadStudyMaterials();
    });
  }
  

  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final studyMaterials = appState.studyMaterials;
        final selectedMaterialId = appState.selectedMaterialId;
        final materialRecords = appState.materialRecords;
        final studiedIds = appState.studiedTranslationIds;
        
        return Column(
          children: [

            
            // Material selector
            if (studyMaterials.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.selectStudyMaterial,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: selectedMaterialId,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: studyMaterials.map((material) {
                        final id = material['id'] as int;
                        final subject = material['subject'] as String;
                        final sourceLang = material['source_language'] as String;
                        final targetLang = material['target_language'] as String;
                        
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text('$subject ($sourceLang → $targetLang)'),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        if (value != null) {
                          appState.selectMaterial(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Metadata (Collapsible)
                    if (selectedMaterialId != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          elevation: 0,
                          color: Colors.grey[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey[200]!),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text(
                                l10n.materialInfo ?? 'Material Info', // Fallback or add key
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF667eea),
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: _buildMaterialInfo(appState, selectedMaterialId),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Progress indicator
            if (materialRecords.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.bar_chart, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.progress(studiedIds.length, materialRecords.length),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${((studiedIds.length / materialRecords.length) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Records list
            Expanded(
              child: materialRecords.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.library_books_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                            Text(
                            studyMaterials.isEmpty
                                ? l10n.importJsonFilePrompt
                                : l10n.selectMaterialPrompt,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: materialRecords.length,
                      itemBuilder: (context, index) {
                        final record = materialRecords[index];
                        return _buildRecordCard(appState, record, studiedIds);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
  
  /// Build material metadata info card
  Widget _buildMaterialInfo(AppState appState, int materialId) {
    // Note: l10n is not available here directly, but we can pass it or look it up if context is available.
    // However, this is a method inside State class, so we can use context.
    final l10n = AppLocalizations.of(context)!;
    
    final material = appState.studyMaterials.firstWhere(
      (m) => m['id'] == materialId,
    );
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.topic, size: 16, color: Color(0xFF667eea)),
              const SizedBox(width: 4),
              Text(
                l10n.subject,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              Text(
                material['subject'] as String,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.source, size: 16, color: Color(0xFF667eea)),
              const SizedBox(width: 4),
              Text(
                l10n.source,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              Text(
                material['source'] as String,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          if (material['file_name'] != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.insert_drive_file, size: 16, color: Color(0xFF667eea)),
                const SizedBox(width: 4),
                Text(
                  l10n.file,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
                Expanded(
                  child: Text(
                    material['file_name'] as String,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  /// Build individual record card
  Widget _buildRecordCard(
    AppState appState,
    Map<String, dynamic> record,
    Set<int> studiedIds,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final translationId = record['id'] as int;
    final sourceText = record['source_text'] as String;
    final targetText = record['target_text'] as String;
    final sourceLang = record['source_lang'] as String;
    final targetLang = record['target_lang'] as String;
    final isStudied = studiedIds.contains(translationId);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source text
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    sourceLang.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sourceText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {
                    appState.playMaterialTts(
                      text: sourceText,
                      lang: sourceLang,
                      recordId: record['source_id'] as int?,
                    );
                  },
                  tooltip: l10n.listen,
                ),
              ],
            ),
            
            const Divider(height: 16),
            
            // Target text
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    targetLang.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    targetText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {
                    appState.playMaterialTts(
                      text: targetText,
                      lang: targetLang,
                      recordId: record['target_id'] as int?,
                    );
                  },
                  tooltip: l10n.listen,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Study button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: isStudied
                    ? null
                    : () {
                        appState.markTranslationAsStudied(translationId);
                      },
                icon: Icon(isStudied ? Icons.check_circle : Icons.circle_outlined),
                label: Text(isStudied ? l10n.studyComplete : l10n.markAsStudied),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isStudied ? Colors.grey : const Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
