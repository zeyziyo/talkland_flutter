import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class SupabaseHelper {
  static bool _initialized = false;
  
  static const String _fallbackUrl = 'https://soxdzielqtabyradajle.supabase.co';
  static const String _fallbackAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNveGR6aWVscXRhYnlyYWRhamxlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkzNzI0NDQsImV4cCI6MjA4NDk0ODQ0NH0.MHLZSXBWJlN6xojyqJR57DLulUWMUg67V458h6Sq2nY';
  
  static SupabaseClient get client {
    if (!_initialized) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return Supabase.instance.client;
  }

  static Future<void> initialize() async {
    if (_initialized) return;
    
    final envUrl = dotenv.env['SUPABASE_URL'];
    final envKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (kReleaseMode && (envUrl == null || envKey == null)) {
      debugPrint('CRITICAL: Supabase environment variables missing in Release Mode!');
    }

    final url = envUrl?.isNotEmpty == true ? envUrl! : _fallbackUrl;
    final anonKey = envKey?.isNotEmpty == true ? envKey! : _fallbackAnonKey;
    
    await Supabase.initialize(url: url, anonKey: anonKey);
    _initialized = true;
  }
}
