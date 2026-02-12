import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'audio_session_helper.dart';

class SpeechSttService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  bool _isRestarting = false;
  String _lastRecognizedText = '';
  
  final _statusController = StreamController<String>.broadcast();
  Stream<String> get statusStream => _statusController.stream;
  
  bool get isListening => _isListening;
  String get lastRecognizedText => _lastRecognizedText;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      final available = await _speechToText.initialize(
        onError: (error) => print('STT Error: $error'),
        onStatus: (status) async {
          print('STT Status: $status');
          _statusController.add(status);
          if ((status == 'done' || status == 'notListening') && !_isRestarting) {
            await AudioSessionHelper.configureForPlayback();
            _isListening = false;
          }
        },
      );
      _isInitialized = available;
      return available;
    } catch (e) {
      print('STT Initialization Error: $e');
      return false;
    }
  }

  Future<void> start({
    required String lang,
    required Function(String, bool, List<String>) onResult,
    Duration? listenFor,
    Duration? pauseFor,
    bool continuous = false,
  }) async {
    if (!_isInitialized) await initialize();

    if (_isListening) {
      _isRestarting = true;
      await _speechToText.cancel();
      _isListening = false;
      _isRestarting = false;
    }

    await AudioSessionHelper.configureForRecording();
    _lastRecognizedText = '';
    _isListening = true;

    await _speechToText.listen(
      onResult: (result) {
        _lastRecognizedText = result.recognizedWords;
        final alternates = result.alternates.map((alt) => alt.recognizedWords).toList();
        onResult(result.recognizedWords, result.finalResult, alternates);
      },
      localeId: lang,
      listenFor: listenFor ?? (continuous ? const Duration(seconds: 60) : const Duration(seconds: 30)),
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: !continuous,
        onDevice: false,
      ),
      pauseFor: pauseFor ?? (continuous ? const Duration(seconds: 10) : const Duration(seconds: 3)),
    );
  }

  Future<void> stop() async {
    if (!_isListening) return;
    await _speechToText.stop();
    _isListening = false;
    await AudioSessionHelper.configureForPlayback();
  }

  void cancel() {
    _speechToText.cancel();
    _isListening = false;
  }
}
