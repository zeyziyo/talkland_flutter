import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart' as gn_auth;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, debugPrint;
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
      if (kIsWeb) {
        // Phase 15.6: Dynamically determine redirect URL
        // We use the full URL to check which host we are on, then pick the corresponding allowed redirect URL.
        final String currentUrl = Uri.base.toString();
        String? redirectUrl;
        
        if (currentUrl.contains('127.0.0.1')) {
          redirectUrl = 'http://127.0.0.1:8081';
        } else if (currentUrl.contains('localhost')) {
          redirectUrl = 'http://localhost:8081';
        }
        
        // Safety check to ensure we don't pass null if somehow both fail
        redirectUrl ??= 'http://localhost:8081';
        
        debugPrint('[SupabaseAuth] Starting Redirect Login with: $redirectUrl');
        
        await SupabaseHelper.client.auth.signInWithOAuth(
          OAuthProvider.google,
          // Always provide redirectTo if determined, to ensure reliability on local release tests
          redirectTo: redirectUrl, 
        );
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
