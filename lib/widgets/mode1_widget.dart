import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' hide AppState; // Add import
import '../services/usage_service.dart';

/// Mode 1: 검색 모드 - STT → 번역 → TTS
class Mode1Widget extends StatefulWidget {
  final Key? micButtonKey;
  final Key? translateButtonKey;
  final Key? saveButtonKey;

  final Key? contextFieldKey; // Add key for tutorial
  final Key? toggleButtonKey; // Add key for tutorial

  const Mode1Widget({
    super.key,
    this.micButtonKey,
    this.translateButtonKey,
    this.saveButtonKey,
    this.contextFieldKey,
    this.toggleButtonKey, // Add Toggle Key
  });

  @override
  State<Mode1Widget> createState() => _Mode1WidgetState();
}

class _Mode1WidgetState extends State<Mode1Widget> {
  // Persistent controllers to preserve Korean IME composition state
  late TextEditingController _sourceTextController;
  late TextEditingController _translatedTextController;
  late TextEditingController _noteController;

  // Rewarded Ad
  RewardedAd? _rewardedAd;
  
  @override
  void initState() {
    super.initState();
    _loadRewardedAd(); // Load Ad on init

    // Initialize controllers with empty text
    _sourceTextController = TextEditingController();
    _translatedTextController = TextEditingController();
    _noteController = TextEditingController();
  }

  // ... (dispose)
  @override
  void dispose() {
    // Clean up controllers and ads
    _sourceTextController.dispose();
    _translatedTextController.dispose();
    _noteController.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  // ... (build)
  
        if (_noteController.text != appState.note) {
          _noteController.text = appState.note;
          _noteController.selection = TextSelection.collapsed(
            offset: appState.note.length
          );
        }
        
        // ...
        
                                // ...
                                  const SizedBox(height: 12),
                                  TextField(
                                    key: widget.contextFieldKey, // Keep key prop name
                                    controller: _noteController,
                                    onChanged: (value) {
                                      appState.setNote(value);
                                    },
                                    decoration: InputDecoration(
                                      labelText: l10n.contextTagLabel,
                                      hintText: l10n.contextTagHint,
                                      border: const OutlineInputBorder(),
                                      isDense: true,
                                      prefixIcon: const Icon(Icons.note, size: 20), // Changed icon to note
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Translate Button
                        ElevatedButton.icon(
                          key: widget.translateButtonKey,
                          onPressed: appState.isTranslating
                              ? null
                              : () async {
                              try {
                                await appState.translate();
                              } catch (e) {
                                if (e is LimitReachedException && context.mounted) {
                                  _showLimitDialog(context, appState);
                                }
                              }
                            },
                          icon: appState.isTranslating
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.translate),
                          label: Text(
                            appState.isTranslating ? l10n.translating : l10n.translate,
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667eea),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Translated Text Output
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        appState.languageNames[appState.targetLang] ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade800,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        appState.isSpeaking
                                            ? Icons.stop_circle
                                            : Icons.volume_up,
                                        color: appState.isSpeaking ? Colors.red : null,
                                      ),
                                      onPressed: appState.translatedText.isEmpty
                                          ? null
                                          : (appState.isSpeaking
                                              ? () => appState.stopSpeaking()
                                              : () => appState.speak()),
                                      tooltip: l10n.listen,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: appState.translatedText.isEmpty
                                          ? null
                                          : () => appState.clearTexts(),
                                      tooltip: l10n.cancel, // or 'Reset'
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _translatedTextController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                  readOnly: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                  
                  // Duplicate Detection Dialog
                  if (appState.showDuplicateDialog)
                    _buildDuplicateDialog(context, appState),
                ],
              ),
            ),
            
            // Bottom Save Button
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    key: widget.saveButtonKey,
                    onPressed: (appState.sourceText.isEmpty || 
                                appState.translatedText.isEmpty ||
                                appState.isSaved)
                        ? null
                        : () => appState.saveTranslation(),
                    icon: const Icon(Icons.save),
                    label: Text(
                      appState.isSaved ? l10n.saved : l10n.saveData,
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDuplicateDialog(BuildContext context, AppState appState) {
    // ... existing code ...
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.similarTextFound,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => appState.closeDuplicateDialog(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.useExistingText,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                
                ...appState.similarSources.map((record) {
                  final text = record['text'] as String;
                  final id = record['id'] as int;
                  
                  return Card(
                    color: Colors.blue[50],
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        text,
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text('ID: $id'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        appState.selectExistingSource(id, text);
                      },
                    ),
                  );
                }).toList(),
                
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => appState.createNewSource(),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.createNew),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLimitDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translationLimitExceeded),
        content: Text(
          AppLocalizations.of(context)!.translationLimitMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: Text(AppLocalizations.of(context)!.watchAdAndRefill),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              
              if (_rewardedAd != null) {
                // Show Real Ad
                _rewardedAd!.show(
                  onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) async {
                    // Reward the user
                    await appState.refill(5);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.translationRefilled)),
                      );
                    }
                    // Load next ad
                    _loadRewardedAd();
                  },
                );
              } else {
                // Ad not ready
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.adLoading)),
                );
                _loadRewardedAd(); // Retry load
              }
            },
          ),
        ],
      ),
    );
  }
}
