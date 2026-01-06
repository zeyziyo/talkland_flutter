import 'package:translator/translator.dart';
import 'database_service.dart';

/// Translation service using Google Translate
class TranslationService {
  static final _translator = GoogleTranslator();
  
  /// Translate text from source language to target language
  /// 
  /// Parameters:
  /// - text: Text to translate
  /// - sourceLang: Source language code (e.g., 'ko', 'zh-CN')
  /// - targetLang: Target language code (e.g., 'ja', 'zh-CN')
  /// 
  /// Returns translated text or throws exception
  static Future<String> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return '';
    }
    
    final cacheKey = '$sourceLang-$targetLang-$normalized';
    
    // 1. Check cache first (skip on web)
    try {
      final cached = await DatabaseService.getCachedTranslation(cacheKey);
      
      if (cached != null) {
        print('[Translation] Cache hit');
        return cached;
      }
    } catch (e) {
      // Database not available (web platform) - skip caching
      print('[Translation] Cache unavailable (web platform)');
    }
    
    // 2. Call Google Translate API directly
    try {
      print('[Translation] Calling Google Translate: $sourceLang -> $targetLang');
      print('[Translation] Text: ${normalized.substring(0, normalized.length > 20 ? 20 : normalized.length)}...');
      
      final translation = await _translator.translate(
        normalized,
        from: sourceLang,
        to: targetLang,
      );
      
      final translatedText = translation.text;
      
      // 3. Cache the result (skip on web)
      try {
        await DatabaseService.cacheTranslation(cacheKey, translatedText);
      } catch (e) {
        // Database not available - skip
        print('[Translation] Could not cache (web platform)');
      }
      
      print('[Translation] Translation successful: $translatedText');
      return translatedText;
    } catch (e) {
      print('[Translation] Error: $e');
      rethrow;
    }
  }
}
  
  /// Health check for server availability
  static Future<bool> checkServerHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/api/health');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 5),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('[Translation] Health check failed: $e');
      return false;
    }
  }
}
