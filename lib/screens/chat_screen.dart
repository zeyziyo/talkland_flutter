import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // State Management
import 'package:talkie/providers/app_state.dart';
import '../models/dialogue_group.dart';
import '../l10n/app_localizations.dart';
import '../services/speech_service.dart';
import '../models/chat_participant.dart'; // Phase 70

import '../services/supabase_service.dart';
import '../services/database_service.dart';
import '../services/translation_service.dart';
import '../services/database/dialogue_repository.dart'; // Phase 135
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ChatScreen extends StatefulWidget {
  final DialogueGroup? initialDialogue;
  /// true = AI 모드(_isPartnerMode=false), false = 파트너 모드(_isPartnerMode=true)
  final bool hasAiParticipant;
  const ChatScreen({super.key, this.initialDialogue, this.hasAiParticipant = true});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  final SpeechService _speechService = SpeechService();
  
  bool _isPartnerMode = false; // Toggle for Real Person Chat
  bool _isPartnerTurn = false; // For Mic Logic (True = Listen in Target Lang)

  // Phase 118: Individual translation visibility toggle state
  // Key: sequence_order (int), Value: if translation is visible
  final Map<int, bool> _showTranslationMap = {};

  // Phase 33: Chat Content Search
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();

    // 참가자 구성에 따라 모드 초기화
    // hasAiParticipant=true  → AI 모드 (_isPartnerMode = false)
    // hasAiParticipant=false → 파트너 모드 (_isPartnerMode = true)
    _isPartnerMode = !widget.hasAiParticipant;

    // Phase 119: Pre-warm Speech Services to avoid initial STT/TTS delay
    _speechService.initialize().catchError((e) {
      debugPrint('[ChatScreen] Pre-warm failed: $e');
      return false;
    });

    // Load History if we have an active dialogue (New Chat or Existing)
    final appState = Provider.of<AppState>(context, listen: false);
    debugPrint('[ChatScreen] Initialized with hasAiParticipant: ${widget.hasAiParticipant}');
    
    if (widget.initialDialogue != null || appState.activeDialogueId != null) {
      _loadHistory();
    }

    // Load list for Dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      appState.loadParticipants(); // Phase 70
    });
  }

  Future<void> _loadHistory() async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    // Phase 134 Fix: Safety check for New Chat (initialDialogue is null)
    // Use activeDialogueId from AppState if widget.initialDialogue is null
    final dialogueId = widget.initialDialogue?.id ?? appState.activeDialogueId;
    
    if (dialogueId == null) return;

    try {
      var history = await DatabaseService.getRecordsByDialogueId(
        dialogueId,
        sourceLang: appState.sourceLang,
        targetLang: appState.targetLang,
      );
      
      // Phase 135 Fix: Self-Healing Logic (If local empty, check server)
      // This handles cases where local DB is cleared or sync failed previously.
      if (history.isEmpty) {
        debugPrint('[ChatScreen] Local history empty. Checking server for dialogue: $dialogueId');
        try {
          final cloudMessages = await SupabaseService.getPrivateChatMessages(dialogueId);
          if (cloudMessages.isNotEmpty) {
             // Sort by sequence or created_at
             cloudMessages.sort((a, b) => (a['sequence_order'] as int).compareTo(b['sequence_order'] as int));
             
             // Sync to Local DB
             for (var msg in cloudMessages) {
               await DialogueRepository.insertMessage({
                 'dialogue_id': dialogueId,
                 'speaker': msg['speaker'],
                 'source_text': msg['source_text'],
                 'target_text': msg['target_text'],
                 'created_at': msg['created_at'],
               });
             }
             
             // Reload from Local to get standardized format
             history = await DatabaseService.getRecordsByDialogueId(
                dialogueId,
                sourceLang: appState.sourceLang,
                targetLang: appState.targetLang,
             );
          }
        } catch (e) {
          debugPrint('[ChatScreen] Server sync attempt failed: $e');
          // Non-blocking error. If server fails, we just show empty.
        }
      }

      // Phase 133 Fix: Render messages immediately (Optimistic UI)
      if (mounted) {
        setState(() {
          _messages = history;
        });
        _scrollToBottom();
      }
      
      // Phase 70/28: Clean up legacy sync - ID logic handles this now
    } catch (e) {
      debugPrint('[ChatScreen] Load History Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load chat history: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Helper to get GPS Context
  Future<String> _getLocationString(AppLocalizations l10n) async {
    try {
      print('[GPS] Checking permissions...');
      LocationPermission permission = await Geolocator.checkPermission().timeout(const Duration(seconds: 2));
      if (permission == LocationPermission.denied) {
        print('[GPS] Requesting permissions...');
        permission = await Geolocator.requestPermission().timeout(const Duration(seconds: 3));
        if (permission == LocationPermission.denied) return '';
      }
      
      if (permission == LocationPermission.deniedForever) return '';
      
      // Phase 162: If Windows, Geolocator might return error or empty. 
      // We try to handle it gracefully.

      // 1. Try Last Known Position (Instant)
      Position? position = await Geolocator.getLastKnownPosition();
      
      // 2. If null or old, try Current Position with Timeout (3s)
      if (position == null) {
        try {
          print('[GPS] Fetching current position (3s timeout)...');
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 3),
            ),
          ).timeout(const Duration(seconds: 3));
        } catch (e) {
          print('[GPS] Timeout or Error: $e');
        }
      }

      if (position == null) return '';

      print('[GPS] Converting coordinates to address...');
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude)
          .timeout(const Duration(seconds: 2));
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.administrativeArea ?? '';
        final sub = place.subLocality ?? place.thoroughfare ?? '';
        
        print('[GPS] Success: $city, $sub');
        if (sub.isNotEmpty && city.isNotEmpty) {
          return '$sub, $city';
        }
        return city.isNotEmpty ? city : place.country ?? '';
      }
    } catch (e) {
      debugPrint('[GPS] Final catch Error: $e');
    }
    return '';
  }

  Future<void> _sendMessage(AppLocalizations l10n) async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    debugPrint('>>> _sendMessage CRUCIAL START (globalLoading: ${appState.globalParticipantsLoading}, isLoading: $_isLoading)');
    
    // v14: REMOVE ALL GUARDS. Just let it through to see where it stops.
    // if (appState.globalParticipantsLoading) return;
    // if (_isLoading) return;

    final text = _textController.text.trim();
    if (text.isEmpty) return;

    debugPrint('[Chat] Sending message: $text');
    
    // v14.3: FORCE SNACKBAR FOR FEEDBACK
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('>>> 메시지 처리 시작: $text')),
    );

    // 1. IMMEDIATE UI UPDATE (Aggressive Refresh)
    setState(() {
      _messages = List.from(_messages)..add({
        'speaker': 'User',
        'source_text': text,
        'target_text': '[...] Processing...',
      });
      _textController.clear();
      _isLoading = true; 
    });
    debugPrint('>>> UI UPDATED. Total Messages: ${_messages.length}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('>>> 리스트 업데이트됨 (총 ${_messages.length}개)'), duration: Duration(milliseconds: 1000)),
    );
    _scrollToBottom();

    // 2. DETACHED BACKGROUND PROCESSING (Run in isolation)
    Future.microtask(() async {
      try {
        // Step 1: Usage Check
        await appState.checkUsageLimit();

        final inputLang = appState.sourceLang;
        final outputLang = appState.targetLang;

        // Step 2: Translation
        final translationResult = await TranslationService.translate(
          text: text,
          sourceLang: inputLang,
          targetLang: outputLang,
        ).timeout(const Duration(seconds: 10), onTimeout: () => {'text': '[Translation Timeout] $text', 'isValid': true});

        final trans = translationResult['text'] as String;
        
        if (mounted) {
          setState(() {
            _messages.last['target_text'] = trans;
          });
        }

        // Step 3: Local/Cloud Save
        await appState.saveUserMessage(text, trans);

        // Step 4: AI Response Processing
        await _processAiChat(appState, text, trans, l10n)
            .timeout(const Duration(seconds: 30), onTimeout: () => debugPrint('[Chat] AI response timeout'));

      } catch (e) {
        debugPrint('[Chat] BG Error: $e');
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('오류: $e'), backgroundColor: Colors.red));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        _scrollToBottom();
      }
    });
  }

  Future<void> _processAiChat(AppState appState, String userText, String userTranslation, AppLocalizations l10n) async {
      // Get GPS Context
      final location = await _getLocationString(l10n);
      final currentLocationLabel = l10n.currentLocation;
      final contextString = '${appState.activeDialogueTitle ?? "None"}. ${location.isNotEmpty ? "$currentLocationLabel: $location" : ""}';

      // Build History
      final history = _messages.where((m) => m['speaker'] != 'Partner').map((msg) {
        return {
          'role': msg['speaker'] == 'User' ? 'user' : 'model',
          'parts': [{'text': msg['source_text'] ?? ''}]
        };
      }).toList();

      // Phase 29: Use specific AI participant's langCode instead of global appState.targetLang
      final aiParticipant = appState.activeParticipants.firstWhere(
        (p) => p.id == 'ai' || p.role == 'ai' || p.role == 'assistant',
        orElse: () => ChatParticipant(id: 'ai', dialogueId: '', name: 'AI', role: 'ai', langCode: appState.targetLang)
      );
      final aiLangCode = aiParticipant.langCode;

      final result = await SupabaseService.processChat(
        text: userText,
        context: contextString,
        targetLang: aiLangCode, // Reflect individual AI setting
        history: history,
      );

      final String aiResponse = result['response'] as String? ?? '';
      final String translatedResponse = result['translatedResponse'] as String? ?? '';
      final String? pos = result['pos'] as String?;
      final String? formType = result['formType'] as String?;
      final String? root = result['root'] as String?;
      final String? explanation = result['explanation'] as String?;
      final String? suggestedTitle = result['title'] as String?;

      await appState.saveAiResponse(
        aiResponse, 
        translatedResponse,
        pos: pos,
        formType: formType,
        root: root,
        explanation: explanation,
      );
      
      if (suggestedTitle != null && 
          (appState.activeDialogueTitle == 'New Conversation' || appState.activeDialogueTitle == l10n.chatUntitled) &&
          appState.activeDialogueId != null &&
          _messages.length < 5) { // Phase 28: Only auto-title in early stage
        
        // Append Location to Title if available
        String finalTitle = suggestedTitle;
        if (location.isNotEmpty) {
           finalTitle = '$finalTitle @ ${location.split(',')[0]}';
        }
        
        await SupabaseService.updateDialogueTitle(appState.activeDialogueId!, finalTitle);
        // Do not force reload groups here to avoid UI flicker during active chat
        // appState.loadDialogueGroups(); 
      }

      if (mounted) {
        setState(() {
          _messages.add({
            'speaker': appState.activePersona ?? 'AI',
            'source_text': aiResponse, 
            'target_text': translatedResponse,
          });
          _isLoading = false;
        });
      }
  }

  Future<void> _endChat(AppLocalizations l10n) async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    // 1. Prepare Initial Values
    // Phase 162: Prioritize AppState's pre-fetched location
    String? detectedLocation = appState.activeDialogueLocation;
    
    // If not pre-fetched, try fetching now (last attempt)
    if (detectedLocation == null || detectedLocation.isEmpty) {
      detectedLocation = await _getLocationString(l10n);
    }
    
    // Auto-generate Title Logic: "Chat N"
    int count = await DatabaseService.getDialogueCount();
    // If saving NEW chat, it's count + 1. If updating existing, it's just existing title.
    // If activeDialogueTitle is user-set (not "New Conversation"), keep it.
    
    String defaultTitle;
    if (appState.activeDialogueTitle != null && 
        appState.activeDialogueTitle != 'New Conversation' && 
        appState.activeDialogueTitle != l10n.chatUntitled) {
      defaultTitle = appState.activeDialogueTitle!;
    } else {
      defaultTitle = 'Chat ${count + 1}'; // Ensure unique-ish name
    }
    
    final titleController = TextEditingController(text: defaultTitle);
    final locationController = TextEditingController(text: detectedLocation);
    final noteController = TextEditingController(); // Phase 62: Note

    if (!mounted) return;

    // 2. Trigger Background Fetch for AI Suggestions
    appState.fetchChatTitleSuggestions();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Consumer<AppState>(
            builder: (context, state, child) {
              return AlertDialog(
                title: Text(l10n.chatEndTitle),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.chatEndMessage),
                      const SizedBox(height: 20),
                      
                      // Title Input
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: l10n.subject, // Will be "Title" in L10n update
                          hintText: 'Chat 1',
                          prefixIcon: const Icon(Icons.title),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      
                      // AI Suggestions Area
                      if (state.isFetchingTitles)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                        )
                      else if (state.suggestedTitles.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            children: state.suggestedTitles.map<Widget>((suggestion) => ActionChip(
                              label: Text(suggestion, style: const TextStyle(fontSize: 12)),
                              onPressed: () {
                                setDialogState(() {
                                  titleController.text = suggestion;
                                });
                              },
                              backgroundColor: Colors.blue.shade50,
                            )).toList(),
                          ),
                        ),
                        
                      const SizedBox(height: 16),
                      
                      // Location Input
                      TextField(
                        controller: locationController,
                        readOnly: locationController.text.isNotEmpty, // Phase 162: Allow manual entry if empty
                        decoration: InputDecoration(
                          labelText: l10n.location,
                          prefixIcon: const Icon(Icons.location_on),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: const OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Note Input (New)
                      TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          labelText: l10n.labelNote, // Reuse "Note" label
                          prefixIcon: const Icon(Icons.note),
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(l10n.cancel),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final finalTitle = titleController.text.trim();
                      final finalLocation = locationController.text.trim();
                      final finalNote = noteController.text.trim();
                      
                      if (finalTitle.isEmpty) return;
                      
                      await state.saveDialogueProgress(
                        finalTitle, 
                        finalLocation,
                        finalNote.isNotEmpty ? finalNote : null,
                      );
                      
                      if (context.mounted) {
                        Navigator.of(dialogContext).pop(); 
                        Navigator.of(context).pop(); 
                      }
                    },
                    child: Text(l10n.chatSaveAndExit),
                  ),
                ],
              );
            }
          );
        },
      ),
    );
  }

  bool _isListening = false;
  Future<void> _startListening(AppLocalizations l10n) async {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noInternetWarningMic)),
      );
      return;
    }
    setState(() => _isListening = true);

    try {
      // Phase 6: Ensure any background/other mode STT is stopped
      await appState.stopListening();
      
      final isPartnerListen = _isPartnerMode && _isPartnerTurn;
      final listenLang = isPartnerListen ? appState.targetLang : appState.sourceLang;

      // ChatScreen의 _textController를 직접 업데이트하기 위해 _speechService 단돁 사용
      // appState.startListening()을 병용 호출 시 STT가 충돌하여 대화문이 입력되지 않는 버그 발생
      await _speechService.startSTT(
        lang: appState.getServiceLocale(listenLang),
        listenFor: const Duration(seconds: 30),
        onResult: (text, isFinal, alternates) {
          setState(() {
            _textController.text = text;
          });
          if (isFinal) {
            setState(() => _isListening = false);
            _sendMessage(l10n);
          }
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isListening = false;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.recognitionFailed(e.toString()))),
      );
    }
  }
  
  void _speak(String text, String languageCode, {bool isUser = true, String? gender}) {
    if (text.isEmpty) return;
    
    // Determine the actual locale to use
    // Priority: 1. Explicit languageCode, 2. Text-based detection (done inside SpeechService)
    String localeId = languageCode;
    
    // Clean text (remove brackets/metadata)
    final cleanText = text.replaceAllMapped(RegExp(r'\[([^\]]+)\]'), (match) {
      return match.group(1) ?? '';
    });
    
    final appState = Provider.of<AppState>(context, listen: false);
    
    // Determine Gender (Use provided gender or fallback to AppState)
    final resolvedGender = gender ?? (isUser ? appState.chatUserGender : appState.chatAiGender);

    _speechService.speak(cleanText, lang: localeId, gender: resolvedGender);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Phase 14.4: Remove dangerous microtask that overwrites optimistic UI updates
    // Language changes should be handled explicitly or via Consumer.

    return Scaffold(
      backgroundColor: Colors.yellow[50], // VISUAL PROOF OF v14.2
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A69BD), 
        elevation: 4,
        centerTitle: true,
        title: _isSearching 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: l10n.search,
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Only (Dropdown Removed per user request)
                Consumer<AppState>(
                  builder: (context, state, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.greenAccent),
                        const SizedBox(width: 8),
                        Text(
                           appState.activeDialogueTitle ?? 'Talkie',
                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                        ),
                      ],
                    );
                  }
                ),
                
                if (_isPartnerMode)
                   Padding(
                     padding: const EdgeInsets.only(top: 4, left: 4),
                     child: Text(
                       '${l10n.partnerMode}: ${l10n.manual}', 
                       style: const TextStyle(fontSize: 12, color: Colors.white70)
                     ),
                   ),
              ],
            ),
        foregroundColor: Colors.white,
        actions: [
          // Search Icon
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
            tooltip: l10n.search,
          ),
          // Partner Mode Toggle
          if (!_isSearching)
            IconButton(
              icon: Icon(_isPartnerMode ? Icons.person : Icons.smart_toy),
              tooltip: _isPartnerMode ? l10n.switchToAi : l10n.switchToPartner,
              onPressed: () {
                setState(() {
                  _isPartnerMode = !_isPartnerMode;
                  _isPartnerTurn = false; // Reset to User turn
                });
              },
            ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _endChat(l10n),
              tooltip: l10n.chatSaveAndExit,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty 
              ? Center(child: Text(l10n.noMaterialsInCategory, style: TextStyle(color: Colors.grey[400])))
              : ListView.builder(
                  key: ValueKey('msg_list_${_messages.length}_$_isSearching'), // Force whole list rebuild
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    
                    // Filter Logic for Search
                    if (_isSearching && _searchQuery.isNotEmpty) {
                      final src = (msg['source_text'] ?? '').toString().toLowerCase();
                      final tgt = (msg['target_text'] ?? '').toString().toLowerCase();
                      if (!src.contains(_searchQuery) && !tgt.contains(_searchQuery)) {
                        return const SizedBox.shrink();
                      }
                    }

                    return _buildMessageBubble(msg, appState, l10n, index);
                  },
                ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          _buildInputArea(appState, l10n),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, AppState appState, AppLocalizations l10n, int index) {
    final speakerIdOrName = msg['speaker'] ?? 'Unknown';
    final bool isUser = speakerIdOrName.toString().toLowerCase() == 'user' || speakerIdOrName == 'me';
    final bool isPartner = speakerIdOrName.toString().toLowerCase() == 'partner';

    // Phase 136/28: Securely find Participant Config by ID (or name fallback)
    final participant = appState.activeParticipants.firstWhere(
      (p) => p.id == speakerIdOrName || p.name.toLowerCase() == speakerIdOrName.toString().toLowerCase(),
      orElse: () {
        debugPrint('[ChatScreen] Participant NOT FOUND for $speakerIdOrName');
        return ChatParticipant(
          id: 'temp', dialogueId: '', name: speakerIdOrName.toString(), role: isUser ? 'user' : 'ai'
        );
      }
    );
    
    final int seq = msg['sequence_order'] as int? ?? index;
    final bool isTranslationVisible = _showTranslationMap[seq] ?? false;
    
    // Layout alignment: User Right, AI Left
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser ? Colors.blue[50] : (isPartner ? Colors.teal[50] : const Color(0xFFF5F5F5));
    
    // Text Logic for Acoustic Symmetry
    // If translation is visible, we show the target_text and speak in target_lang.
    // Otherwise, we show source_text and speak in source_lang.
    final String displayText = isTranslationVisible 
        ? (msg['target_text'] ?? '') 
        : (msg['source_text'] ?? '');
        
    final String displayLang = isTranslationVisible
        ? (isUser ? appState.targetLang : appState.sourceLang)
        : (isUser ? appState.sourceLang : participant.langCode);

    // Unified gender logic for identity consistency
    final String displayGender = isUser ? appState.chatUserGender : participant.gender;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Speaker Header
            if (isUser)
              _buildUserHeader(context, appState, l10n, msg)
            else
              _buildParticipantHeader(context, participant, appState, l10n, msg),

            // Bubble
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser) _buildToggle(seq, l10n),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        topRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                        topLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
                      ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2),
                        ],
                    ),
                    child: _buildTextRow(displayText, displayLang, displayGender, isUser),
                  ),
                ),
                if (isUser) _buildToggle(seq, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(int seq, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: _showTranslationMap[seq] ?? false,
              activeThumbColor: Colors.orange,
              onChanged: (val) {
                setState(() {
                  _showTranslationMap[seq] = val;
                });
              },
            ),
          ),
          Text(
            l10n.translation,
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, AppState appState, AppLocalizations l10n, Map<String, dynamic> msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4, right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 3. Name (Me)
          Text(
             l10n.me,
             style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantHeader(BuildContext context, ChatParticipant participant, AppState appState, AppLocalizations l10n, Map<String, dynamic> msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Rename (Name Click)
          InkWell(
            onTap: () => _showRenameDialog(participant, appState),
            child: Row(
               children: [
                 CircleAvatar(
                   radius: 10,
                   backgroundColor: Color(participant.avatarColor ?? Colors.grey.toARGB32()),
                   child: Text(participant.name[0], style: const TextStyle(fontSize: 10, color: Colors.white)),
                 ),
                 const SizedBox(width: 4),
                  Text(
                     participant.name.toLowerCase() == 'partner' ? l10n.partner : participant.name,
                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                 const SizedBox(width: 4),
                 Icon(Icons.edit, size: 10, color: Colors.grey[400]),
               ],
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildTextRow(String text, String lang, String gender, bool isUser) {
     return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ValueListenableBuilder<String?>(
            valueListenable: _speechService.currentlySpeakingText,
            builder: (context, speakingText, _) {
              final isSpeaking = speakingText == text;
              return IconButton(
                icon: Icon(
                  isSpeaking ? Icons.stop_circle : Icons.volume_up,
                  size: 20,
                  color: isSpeaking ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  if (isSpeaking) {
                    _speechService.stopSpeaking();
                  } else {
                    _speak(text, lang, isUser: isUser, gender: gender);
                  }
                },
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(left: 4),
              );
            },
          ),
        ],
      );
  }

  // Handle Logic Helpers
  Future<void> _showRenameDialog(ChatParticipant p, AppState appState) async {
     final controller = TextEditingController(text: p.name);
     final l10n = AppLocalizations.of(context)!;
     await showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Text(l10n.participantRename),
         content: TextField(
           controller: controller, 
           decoration: InputDecoration(labelText: l10n.labelName, border: const OutlineInputBorder())
         ),
         actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel')
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isNotEmpty && newName != p.name) {
                   await appState.updateParticipant(p.id, name: newName);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)?.confirm ?? 'Save')
            ),
         ],
       ),
     );
  }


  Widget _buildInputArea(AppState appState, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(
        left: 8, 
        right: 8, 
        top: 8, 
        bottom: MediaQuery.of(context).padding.bottom + 8
      ),
      decoration: BoxDecoration(
        color: _isPartnerMode ? Colors.teal.shade50 : Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Partner Turn Indicator / Toggle
          if (_isPartnerMode)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(l10n.speaker),
                   Switch(
                     value: _isPartnerTurn,
                     activeThumbColor: Colors.teal,
                     onChanged: (value) {
                       setState(() => _isPartnerTurn = value);
                     },
                   ),
                   Text(
                     _isPartnerTurn ? l10n.partner : l10n.me,
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: _isPartnerTurn ? Colors.teal : Colors.blue,
                     ),
                   ),
                ],
              ),
            ),

          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isListening ? Icons.stop_circle : Icons.mic,
                  color: _isListening ? Colors.red : (_isPartnerTurn ? Colors.teal : Colors.blue),
                ),
                onPressed: () {
                  if (_isListening) {
                    _speechService.stopSTT();
                    setState(() => _isListening = false);
                  } else {
                    _startListening(l10n);
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: _isPartnerMode 
                        ? (_isPartnerTurn ? '${l10n.partner} (${appState.targetLang})...' : '${l10n.me} (${appState.sourceLang})...')
                        : l10n.chatTypeHint,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(l10n),
                ),
              ),
              const SizedBox(width: 4),
              CircleAvatar(
                backgroundColor: _isPartnerMode ? Colors.teal : const Color(0xFF667eea),
                 child: Consumer<AppState>(
                  builder: (context, state, child) {
                    if (state.globalParticipantsLoading) {
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return IconButton(
                      icon: Icon(Icons.send, color: (_isLoading) ? Colors.grey : Colors.white),
                      onPressed: () {
                        debugPrint('>>> USER CLICKED SEND ICON (Reactively)');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.sendingMessage), duration: const Duration(milliseconds: 500)),
                        );
                        _sendMessage(l10n);
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
