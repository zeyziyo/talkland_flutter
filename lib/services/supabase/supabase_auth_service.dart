import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart' as gn_auth;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
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

  /// Google Login (Native & Web)
  /// v15.0: For permanent account persistence and data recovery after re-installation.
  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      // Phase 15.6: Web-specific OAuth logic to ensure response on browsers
      if (kIsWeb) {
        await SupabaseHelper.client.auth.signInWithOAuth(
          OAuthProvider.google,
          // Use redirect strategy for web to prevent popup blockers
          redirectTo: kDebugMode ? 'http://localhost:8081' : null, 
        );
        // signInWithOAuth starts redirect, session will be handled by auth listener
        return null; 
      }

      // 1. Configure Google Sign In (Native Only)
      final dynamic googleClient = gn_auth.GoogleSignIn();
      
      final googleUser = await googleClient.signIn();
      if (googleUser == null) return null; // Cancelled

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'No ID Token found from Google Sign-In.';
      }

      // 2. Sign in to Supabase with the ID Token
      final dynamic auth = Supabase.instance.client.auth;
      return await auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      print("SupabaseAuth: Google Sign-in Error: $e");
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await SupabaseHelper.client.auth.signOut();
  }
}
