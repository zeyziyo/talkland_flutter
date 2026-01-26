import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    // Auto-login anonymously to enable RLS (saving data)
    try {
      if (client.auth.currentSession == null) {
        await client.auth.signInAnonymously();
        print("Supabase: Anonymous Sign-in Success");
      }
    } catch (e) {
      print("Supabase: Sign-in Failed: $e");
    }
  }

  /// Call the 'translate-and-validate' Edge Function
  static Future<Map<String, dynamic>> translateAndValidate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    try {
      final response = await client.functions.invoke(
        'translate-and-validate',
        body: {
          'text': text,
          'sourceLang': sourceLang,
          'targetLang': targetLang,
        },
      );

      // Edge Function returns nested data in 'data' field sometimes depending on invocation method,
      // but client.functions.invoke returns the data directly usually.
      // Let's assume the function returns JSON: { translatedText, isValid, reason, note }
      
      final data = response.data;
      return Map<String, dynamic>.from(data);
      
    } catch (e) {
      print('Supabase Edge Function Error: $e');
      throw Exception('Translation Failed: $e');
    }
  }

  /// Save a validated sentence to the public dictionary
  static Future<void> saveSentence({
    required int groupId,
    required String text,
    required String langCode,
    String? note,
  }) async {
    await client.from('sentences').insert({
      'group_id': groupId,
      'text': text,
      'lang_code': langCode,
      'note': note,
      'status': 'approved', // Auto-approve for verified translations (simplification for now)
      'author_id': client.auth.currentUser?.id,
    });
  }

  /// Find an existing group for a text (Deduplication)
  static Future<int?> findGroupId(String text, String langCode) async {
    final response = await client
        .from('sentences')
        .select('group_id')
        .eq('text', text)
        .eq('lang_code', langCode)
        .maybeSingle();

    if (response != null) {
      return response['group_id'] as int;
    }
    return null;
  }
}
