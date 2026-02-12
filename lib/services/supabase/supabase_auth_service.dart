import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_helper.dart';

class SupabaseAuthService {
  static User? get currentUser => SupabaseHelper.client.auth.currentUser;
  static Session? get currentSession => SupabaseHelper.client.auth.currentSession;

  static Future<void> signInAnonymously() async {
    try {
      if (currentSession == null) {
        await SupabaseHelper.client.auth.signInAnonymously();
      }
    } catch (e) {
      print("SupabaseAuth: Anonymous Sign-in Failed: $e");
    }
  }
}
