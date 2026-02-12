import 'supabase_helper.dart';

class SupabaseEdgeService {
  static Future<Map<String, dynamic>> translateAndValidate({
    required String text,
    required String sourceLang,
    required String targetLang,
    String? note,
  }) async {
    try {
      final response = await SupabaseHelper.client.functions.invoke(
        'translate-and-validate',
        body: {
          'text': text,
          'sourceLang': sourceLang,
          'targetLang': targetLang,
          'note': note,
        },
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw Exception('Translation Failed: $e');
    }
  }

  static Future<Map<String, dynamic>> processChat({
    required String text,
    required String context,
    required String targetLang,
    List<Map<String, dynamic>>? history,
  }) async {
    try {
      final response = await SupabaseHelper.client.functions.invoke(
        'process-chat',
        body: {
          'text': text,
          'context': context,
          'targetLang': targetLang,
          'history': history,
        },
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw Exception('Chat Failed: $e');
    }
  }

  static Future<List<String>> suggestTitles({
    required List<Map<String, dynamic>> history,
  }) async {
    try {
      final response = await SupabaseHelper.client.functions.invoke(
        'suggest-titles',
        body: {'history': history},
      );
      final data = response.data as Map<String, dynamic>;
      final titles = data['titles'] as List<dynamic>?;
      return titles?.cast<String>() ?? [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getRecommendations({
    required List<Map<String, dynamic>> history,
    required String sourceLang,
    required String targetLang,
  }) async {
    try {
      final response = await SupabaseHelper.client.functions.invoke(
        'get-recommendations',
        body: {
          'history': history,
          'sourceLang': sourceLang,
          'targetLang': targetLang,
        },
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw Exception('Recommendations Failed: $e');
    }
  }
}
