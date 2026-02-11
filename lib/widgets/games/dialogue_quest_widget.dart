import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../l10n/app_localizations.dart';

class DialogueQuestWidget extends StatefulWidget {
  final VoidCallback onQuit;

  const DialogueQuestWidget({super.key, required this.onQuit});

  @override
  State<DialogueQuestWidget> createState() => _DialogueQuestWidgetState();
}

class DialogueOption {
  final String text;
  final String nextNode;

  DialogueOption(this.text, this.nextNode);
}

class DialogueNode {
  final String id;
  final String npcText; // What NPC says
  final String npcLang;
  final List<DialogueOption> options; // Actions user can take

  DialogueNode({
    required this.id,
    required this.npcText,
    required this.npcLang,
    required this.options,
  });
}

class _DialogueQuestWidgetState extends State<DialogueQuestWidget> {
  // Scenario Data (Hardcoded for V1)
  final Map<String, DialogueNode> _scenarioMap = {
    'start': DialogueNode(
      id: 'start',
      npcText: "Hello! Welcome to Talkie Cafe. What can I get for you?",
      npcLang: 'en-US', // Assuming English scenario for demo
      options: [
        DialogueOption("I would like a coffee.", 'order_coffee'),
        DialogueOption("Do you have tea?", 'ask_tea'),
      ],
    ),
    'order_coffee': DialogueNode(
      id: 'order_coffee',
      npcText: "Sure thing! Hot or Iced?",
      npcLang: 'en-US',
      options: [
        DialogueOption("Hot, please.", 'size'),
        DialogueOption("Iced, please.", 'size'),
      ],
    ),
    'ask_tea': DialogueNode(
      id: 'ask_tea',
      npcText: "Yes, we have Green Tea and Earl Grey.",
      npcLang: 'en-US',
      options: [
        DialogueOption("Green Tea, please.", 'size'),
        DialogueOption("Earl Grey, thanks.", 'size'),
      ],
    ),
    'size': DialogueNode(
      id: 'size',
      npcText: "What size would you like?",
      npcLang: 'en-US',
      options: [
        DialogueOption("Tall.", 'payment'),
        DialogueOption("Grande.", 'payment'),
        DialogueOption("Venti.", 'payment'),
      ],
    ),
    'payment': DialogueNode(
      id: 'payment',
      npcText: "Great. That will be \$5. Cash or Card?",
      npcLang: 'en-US',
      options: [
        DialogueOption("Here is cash.", 'end'),
        DialogueOption("Card, please.", 'end'),
      ],
    ),
    'end': DialogueNode(
      id: 'end',
      npcText: "Thank you! Have a wonderful day!",
      npcLang: 'en-US',
      options: [], // End of path
    ),
  };

  late DialogueNode _currentNode;
  bool _isSpeaking = false; // NPC Speaking
  bool _isListening = false; // User Listening
  String _userTranscript = "";
  
  @override
  void initState() {
    super.initState();
    _currentNode = _scenarioMap['start']!;
    // Delay start to allow UI to build
    Future.delayed(const Duration(seconds: 1), _playNpcLine);
  }

  @override
  void dispose() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.stopMode4Listening();
    appState.stopSpeaking();
    super.dispose();
  }

  Future<void> _playNpcLine() async {
    setState(() {
      _isSpeaking = true;
      _isListening = false;
      _userTranscript = "";
    });

    final appState = Provider.of<AppState>(context, listen: false);
    // Play TTS
    await appState.playMaterialTts(
      text: _currentNode.npcText,
      lang: _currentNode.npcLang,
    );

    if (mounted) {
      setState(() {
        _isSpeaking = false;
        // Auto-start listening if options exist
        if (_currentNode.options.isNotEmpty) {
           _startListening(appState);
        }
      });
    }
  }

  void _startListening(AppState appState) {
    setState(() => _isListening = true);
    
    appState.startMode4Listening(
      lang: _currentNode.npcLang, // Listen in same lang for this scenario
      onResult: (text, isFinal) {
        setState(() => _userTranscript = text);
        
        if (isFinal) {
          _checkMatch(text);
        }
      },
    );
  }

  void _checkMatch(String spoken) {
    // Find matching option
    DialogueOption? match;
    final normalizedSpoken = spoken.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    
    for (var option in _currentNode.options) {
       final normalizedOption = option.text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
       if (normalizedSpoken.contains(normalizedOption) || 
           normalizedOption.contains(normalizedSpoken)) { // Loose match
         match = option;
         break;
       }
    }

    if (match != null) {
      // Success
      setState(() {
        _currentNode = _scenarioMap[match!.nextNode]!;
      });
      // Proceed
      _playNpcLine();
    } else {
      // Failure - brief feedback?
      // Just keep listening or wait for retry?
      // For Mode 4, let's keep it continuous for now
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // App Bar / Header
        SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Scenario: Cafe", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(onPressed: widget.onQuit, child: Text(l10n.cancel, style: const TextStyle(color: Colors.red))),
              ],
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // NPC Avatar
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                
                // NPC Bubble
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                      bottomLeft: Radius.circular(0),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         _currentNode.npcText,
                         style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                       ),
                       if (_isSpeaking) 
                         const Padding(
                           padding: EdgeInsets.only(top: 8.0),
                           child: Row(children: [Icon(Icons.volume_up, size: 16, color: Colors.blue), SizedBox(width: 4), Text("Speaking...", style: TextStyle(color: Colors.blue))]),
                         )
                     ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // User Input Area
                if (_currentNode.options.isEmpty)
                   // End of Scenario
                   ElevatedButton(
                     onPressed: widget.onQuit,
                     child: Text(l10n.confirm),
                   )
                else
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: [
                       const Text("Respond:", style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                       const SizedBox(height: 10),
                       
                       // Options
                       ..._currentNode.options.map((option) => Container(
                         margin: const EdgeInsets.only(bottom: 12),
                         padding: const EdgeInsets.all(16),
                         decoration: BoxDecoration(
                           color: Colors.indigo[50], 
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(color: Colors.indigo[100]!),
                         ),
                         child: Text(
                           option.text,
                           style: const TextStyle(fontSize: 18, color: Colors.indigo),
                           textAlign: TextAlign.center,
                         ),
                       )),
                       
                       const SizedBox(height: 20),
                       
                       // Transcript
                       Container(
                         padding: const EdgeInsets.all(12),
                         decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                         child: Row(
                           children: [
                             Icon(Icons.mic, color: _isListening ? Colors.red : Colors.grey),
                             const SizedBox(width: 8),
                             Expanded(child: Text(_userTranscript.isEmpty ? "Listening..." : _userTranscript, style: TextStyle(color: Colors.grey[800]))),
                           ],
                         ),
                       ),
                     ],
                   ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
