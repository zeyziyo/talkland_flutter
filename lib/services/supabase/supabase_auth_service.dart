import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart' as gn_auth;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      // v15.7: Explicitly pass serverClientId (Web Client ID from Google Cloud Console)
      // This is REQUIRED for native Google Sign-In with Supabase.
      final String? serverClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      debugPrint('[SupabaseAuth] Native Sign-In - Using serverClientId: $serverClientId');

      final dynamic googleClient = gn_auth.GoogleSignIn(
        serverClientId: serverClientId,
        forceCodeForRefreshToken: true, // v15.7: Ensure token/code is always requested
        scopes: [
          'email',
          'openid',
          'profile',
        ],
      );
      
      debugPrint('[SupabaseAuth] Native Sign-In - Starting googleClient.signIn()...');
      final googleUser = await googleClient.signIn();
      if (googleUser == null) {
        debugPrint('[SupabaseAuth] Native Sign-In - User cancelled or failed.');
        return null; 
      }

      debugPrint('[SupabaseAuth] Native Sign-In - Google Sign-In Success. Fetching authentication...');
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      final serverAuthCode = googleAuth.serverAuthCode; // New: For debug info

      debugPrint('[SupabaseAuth] Native Sign-In - Tokens received: '
                 'idToken: ${idToken != null ? "FOUND (${idToken.substring(0, 10)}...)" : "MISSING"}, '
                 'accessToken: ${accessToken != null ? "FOUND" : "MISSING"}, '
                 'serverAuthCode: ${serverAuthCode != null ? "FOUND" : "MISSING"}');

      if (idToken == null) {
        throw 'No ID Token found from Google Sign-In. Check if GOOGLE_WEB_CLIENT_ID in .env is correct AND is a WEB CLIENT ID.';
      }

      // 2. Sign in to Supabase with the ID Token
      debugPrint('[SupabaseAuth] Native Sign-In - Attempting Supabase signInWithIdToken...');
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

  /// Email Sign-Up
  /// v15.7: Traditional email/password registration
  static Future<AuthResponse> signUpWithEmail(String email, String password) async {
    try {
      return await SupabaseHelper.client.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('[SupabaseAuth] Email Sign-Up Error: $e');
      rethrow;
    }
  }

  /// Email Sign-In
  /// v15.7: Traditional email/password login
  static Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      return await SupabaseHelper.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('[SupabaseAuth] Email Sign-In Error: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await SupabaseHelper.client.auth.signOut();
  }
}
