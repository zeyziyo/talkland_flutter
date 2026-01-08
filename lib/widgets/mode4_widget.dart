import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

class Mode4Widget extends StatelessWidget {
  const Mode4Widget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final currentQuestion = appState.currentMode4Question;
        
        return Column(
          children: [
            // ==========================================
            // 1. Top Settings Panel
            // ==========================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50], // Distinct color for Speaking Mode
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Material Selector
                  DropdownButtonFormField<int>(
                    value: appState.selectedMaterialId,
                    decoration: InputDecoration(
                      labelText: l10n.selectStudyMaterial,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: appState.studyMaterials.map((material) {
                      return DropdownMenuItem<int>(
                        value: material['id'] as int,
                        child: Text(
                          material['subject'] as String,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: appState.mode4SessionActive 
                      ? null // Disable while active
                      : (val) {
                          if (val != null) appState.selectMaterial(val);
                        },
                  ),
                  const SizedBox(height: 16),
                  
                  // Interval Slider
                  Row(
                    children: [
                      Text(
                        l10n.intervalSeconds(appState.mode4Interval),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Slider(
                          value: appState.mode4Interval.toDouble(),
                          min: 3,
                          max: 20,
                          divisions: 17,
                          label: '${appState.mode4Interval}s',
                          onChanged: appState.mode4SessionActive
                              ? null
                              : (val) => appState.setMode4Interval(val.round()),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Start/Stop Button
                  ElevatedButton.icon(
                    onPressed: appState.studyMaterials.isEmpty
                        ? null
                        : () => appState.toggleMode4Session(),
                    icon: Icon(
                      appState.mode4SessionActive ? Icons.stop : Icons.play_arrow,
                    ),
                    label: Text(
                      appState.mode4SessionActive ? l10n.stopPractice : l10n.startPractice,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appState.mode4SessionActive ? Colors.red : Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            
            // ==========================================
            // 2. Practice Area
            // ==========================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: currentQuestion == null
                    ? Center(
                        child: Text(
                          appState.studyMaterials.isEmpty
                              ? l10n.importJsonFilePrompt
                              : l10n.startPractice, 
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[400], fontSize: 18),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Source Text (Native)
                          const Text(
                            "🇰🇷", // Fixed to Source flag or dynamic
                            style: TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentQuestion['source_text'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          
                          const SizedBox(height: 48),
                          
                          // Feedback Area
                          if (appState.mode4UserAnswer.isNotEmpty) ...[
                            Text(
                              l10n.yourPronunciation,
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              appState.mode4UserAnswer,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.purple,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 24),
                          
                          // Result / Score
                          if (appState.mode4Score != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: _getScoreColor(appState.mode4Score!),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                appState.mode4Feedback,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.score(appState.mode4Score!.toStringAsFixed(1)),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                             Text(
                              l10n.correctAnswer,
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                            Text(
                              currentQuestion['target_text'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ] else if (appState.mode4SessionActive) ...[
                            // Listening Indicator
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(l10n.listening),
                          ],
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }
}
