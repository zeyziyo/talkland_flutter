import 'package:flutter/material.dart';
import 'speech/speech_stt_service.dart';
import 'speech/speech_tts_service.dart';

/// Speech service for STT and TTS across platforms (Facade)
class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final SpeechSttService _stt = SpeechSttService();
  final SpeechTtsService _tts = SpeechTtsService();
  
  ValueNotifier<String?> get currentlySpeakingText => _tts.currentlySpeakingText;
  Stream<String> get statusStream => _stt.statusStream;
  bool get isListening => _stt.isListening;
  String get lastRecognizedText => _stt.lastRecognizedText;
  
  Function? onSilenceDetected; // Keep for compatibility if used elsewhere

  Future<bool> initialize() async {
    final sttInit = await _stt.initialize();
    final ttsInit = await _tts.initialize();
    return sttInit && ttsInit;
  }

  Future<void> startSTT({
    required String lang,
    required Function(String, bool, List<String>) onResult,
    Duration? listenFor,
    Duration? pauseFor,
  }) {
    return _stt.start(
      lang: lang,
      onResult: onResult,
      listenFor: listenFor,
      pauseFor: pauseFor,
      continuous: false,
    );
  }

  Future<void> startContinuousSTT({
    required String lang,
    required Function(String, bool, List<String>) onResult,
  }) {
    return _stt.start(
      lang: lang,
      onResult: onResult,
      continuous: true,
    );
  }

  Future<void> stopSTT() => _stt.stop();

  Future<void> speak(String text, {String lang = 'ko-KR', bool slow = false, String? gender}) {
    return _tts.speak(text, lang: lang, slow: slow, gender: gender);
  }

  Future<void> stopSpeaking() => _tts.stop();

  void dispose() {
    _stt.cancel();
    _tts.stop();
  }
}
