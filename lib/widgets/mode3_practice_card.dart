import 'package:flutter/material.dart';
import 'package:talkie/providers/app_state.dart';
import 'package:talkie/l10n/app_localizations.dart';

class Mode3PracticeCard extends StatelessWidget {
  final AppState appState;
  final Map<String, dynamic> currentQuestion;
  final AppLocalizations l10n;

  const Mode3PracticeCard({
    Key? key,
    required this.appState,
    required this.currentQuestion,
    required this.l10n,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Basic data extraction (similar to Mode2Card)

    final targetId = currentQuestion['target_id'] as int? ?? currentQuestion['id'] as int; // Handle potential ID structure
    final recordSourceLang = currentQuestion['source_lang'] as String? ?? appState.sourceLang;
    final recordTargetLang = currentQuestion['target_lang'] as String? ?? appState.targetLang;
    
    // In Mode 3, Top is ALWAYS Source (Mother Tongue), Bottom is Target (Learning Language)
    // User wants to see Mother Tongue data
    final topLang = recordSourceLang;
    final topText = currentQuestion['source_text'] as String;
    
    final bottomLang = recordTargetLang;
    final bottomText = currentQuestion['target_text'] as String;

    final contextTag = currentQuestion['note'] as String?;
    final isMemorized = currentQuestion['is_memorized'] == true;

    // Premium Gradient Colors (Same as Mode 2)
    final gradientColors = [const Color(0xFF667eea), const Color(0xFF764ba2)];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
           colors: gradientColors,
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF764ba2).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            // --- TOP SECTION (Source) ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Lang Badge + Info + Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       // Lang Badge
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Text(
                          topLang.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                       ),
                       const SizedBox(width: 8),
                       
                       // Metadata Badges (Reuse logic from Mode2Card if possible, simplified here)
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                               // Chat Origin
                               if (currentQuestion['dialogue_id'] != null)
                                 Padding(
                                   padding: const EdgeInsets.only(bottom: 4),
                                   child: Row(
                                     children: [
                                       const Icon(Icons.chat_bubble_outline, size: 10, color: Colors.white70),
                                       const SizedBox(width: 4),
                                       Text(
                                         l10n.chatFromConversation(currentQuestion['speaker'] ?? "AI"),
                                         style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold),
                                       ),
                                     ],
                                   ),
                                 ),
                           ],
                         ),
                       ),

                       // Checkbox (Completed Toggle)
                       GestureDetector(
                          onTap: () => appState.toggleMemorizedStatus(targetId, isMemorized),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                              color: isMemorized ? Colors.white : Colors.transparent,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: isMemorized ? const Color(0xFF764ba2) : Colors.transparent,
                            ),
                          ),
                       ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Main Source Text
                  Text(
                    topText,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  
                  // Note / Context Tag
                  if (contextTag != null && contextTag.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.label_outline, size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            contextTag,
                            style: const TextStyle(fontSize: 13, color: Colors.white70, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    
                   // Hint (First Letter) - Mode 3 Specific
                   Padding(
                     padding: const EdgeInsets.only(top: 8),
                     child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          _getFirstLetterHint(bottomText), 
                          style: const TextStyle(fontSize: 12, color: Colors.white70, fontFamily: 'monospace')
                        ),
                     ),
                   ),
                ],
              ),
            ),
            
            // --- Divider (White) ---
            Divider(height: 1, color: Colors.white.withOpacity(0.1)),
            
            // --- BOTTOM SECTION (Practice Area) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                children: [
                   // Check State
                   if (appState.showRetryButton) ...[
                      // Result View
                      _buildResultView(gradientColors),
                   ] else ...[
                      // Listening / Idle View
                      _buildListeningView(),
                   ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(List<Color> gradientColors) {
    final score = appState.mode3Score ?? 0.0;
    
    return Column(
      children: [
         // Score & Text
         Text('${l10n.accuracy}: ${score.toStringAsFixed(1)}%', 
             style: TextStyle(color: _getScoreColor(score), fontWeight: FontWeight.bold, fontSize: 18)
         ),
         const SizedBox(height: 8),
         Text(currentQuestion['target_text'] as String, 
             textAlign: TextAlign.center,
             style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)
         ),
         const SizedBox(height: 4),
         Text('"${appState.mode3UserAnswer}"', 
             style: const TextStyle(fontSize: 14, color: Colors.white70, fontStyle: FontStyle.italic)
         ),
         const SizedBox(height: 20),
         
         // Controls (Retry, Next)
         Row(
           children: [
             Expanded(
               child: _buildActionButton(
                 icon: Icons.refresh,
                 label: l10n.retry, // "다시 시도?"
                 color: Colors.white24,
                 onPressed: () => appState.retryMode3Question(),
               ),
             ),
             const SizedBox(width: 12),
             Expanded(
               child: _buildActionButton(
                 icon: Icons.arrow_forward,
                 label: l10n.next, // "다음"
                 color: Colors.white,
                 textColor: gradientColors.last,
                 onPressed: () => appState.skipMode3Question(),
               ),
             ),
           ],
         ),
      ],
    );
  }

  Widget _buildListeningView() {
    if (appState.isListening) {
      return Column(
        children: [
           const Text("Listening...", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
           const SizedBox(height: 16),
           _buildCircleButton(
             icon: Icons.stop,
             color: Colors.redAccent,
             size: 60,
             onPressed: () => appState.stopMode3ListeningManual(),
           ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            // Skip Button (Small)
           _buildCircleButton(
             icon: Icons.skip_next,
             color: Colors.white24,
             size: 40,
             iconSize: 20,
             onPressed: () => appState.skipMode3Question(),
           ),
           const SizedBox(width: 20),
           
           // Mic Button (Large)
           _buildCircleButton(
             icon: Icons.mic,
             color: Colors.white,
             iconColor: const Color(0xFF764ba2),
             size: 70,
             iconSize: 32,
             onPressed: () => appState.retryMode3Question(), // Starts listening
           ),
           
           const SizedBox(width: 20),
           
           // Placeholder for symmetry or another action? Maybe play audio hint?
           _buildCircleButton(
             icon: Icons.volume_up,
             color: Colors.white24,
             size: 40,
             iconSize: 20,
             onPressed: () => appState.playMaterialTts(
                text: currentQuestion['target_text'] as String,
                lang: currentQuestion['target_lang'] as String,
             ),
           ),
        ],
      );
    }
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, Color? textColor, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor ?? Colors.white),
      label: Text(label, style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required Color color, Color? iconColor, required double size, double? iconSize, required VoidCallback onPressed}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          if (color == Colors.white)
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: iconSize ?? 24, color: iconColor ?? Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 100) return Colors.greenAccent;
    if (score >= 80) return Colors.amberAccent;
    return Colors.redAccent;
  }

  String _getFirstLetterHint(String targetText) {
    if (targetText.isEmpty) return "";
    final words = targetText.split(' ');
    if (words.isEmpty) return "";
    final firstWord = words[0];
    if (firstWord.isEmpty) return "";
    return "${firstWord[0]}${'-' * (firstWord.length - 1)}";
  }
}
