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
    
    // Phase v15.8.12: Support for --dart-define environment variables (Release Priority)
    final String? defineUrl = const String.fromEnvironment('SUPABASE_URL').isNotEmpty 
        ? const String.fromEnvironment('SUPABASE_URL') : null;
    final String? defineKey = const String.fromEnvironment('SUPABASE_ANON_KEY').isNotEmpty 
        ? const String.fromEnvironment('SUPABASE_ANON_KEY') : null;

    final envUrl = defineUrl ?? dotenv.env['SUPABASE_URL'];
    final envKey = defineKey ?? dotenv.env['SUPABASE_ANON_KEY'];

    if (kReleaseMode && (envUrl == null || envKey == null)) {
      debugPrint('CRITICAL: Supabase environment variables missing in Release Mode!');
      debugPrint('HINT: Check if .env is in pubspec.yaml assets or use --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...');
    }

    final url = envUrl?.isNotEmpty == true ? envUrl! : _fallbackUrl;
    final anonKey = envKey?.isNotEmpty == true ? envKey! : _fallbackAnonKey;
    
    debugPrint('[SupabaseHelper] Initializing with URL: ${url.substring(0, 15)}...');
    
    await Supabase.initialize(
      url: url, 
      anonKey: anonKey,
    );
    _initialized = true;
  }
}
