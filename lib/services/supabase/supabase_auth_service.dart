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
        // Phase v15.7: Dynamically determine redirect URL using current origin
        // This ensures compatibility regardless of the port (8080, 8081, etc.)
        final String redirectUrl = Uri.base.origin;
        
        debugPrint('[SupabaseAuth] Starting Redirect Login with origin: $redirectUrl');
        
        await SupabaseHelper.client.auth.signInWithOAuth(
          OAuthProvider.google,
          // Always provide redirectTo if determined, to ensure reliability on local release tests
          redirectTo: redirectUrl, 
        );
        return null; 
      }

      // 1. Configure Google Sign In (Native Only)
      final String? serverClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      
      if (serverClientId == null || serverClientId.isEmpty) {
        debugPrint('[SupabaseAuth] CRITICAL: GOOGLE_WEB_CLIENT_ID is missing in .env!');
        throw 'Google Client ID not configured. Please check .env file or GitHub Secrets.';
      }
      
      debugPrint('[SupabaseAuth] Native Sign-In - Using serverClientId: $serverClientId');

      final gn_auth.GoogleSignIn googleClient = gn_auth.GoogleSignIn(
        serverClientId: serverClientId,
        forceCodeForRefreshToken: true,
        scopes: [
          'email',
          'openid',
          'profile',
        ],
      );
      
      debugPrint('[SupabaseAuth] Native Sign-In - Starting googleClient.signIn()...');
      final googleUser = await googleClient.signIn();
      
      if (googleUser == null) {
        debugPrint('[SupabaseAuth] Native Sign-In - User cancelled the selection or an error occurred before selection.');
        return null; 
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      debugPrint('[SupabaseAuth] Native Sign-In - Auth Objects: '
                 'idToken: ${idToken != null ? "FOUND (${idToken.substring(0, 10)}...)" : "MISSING"}, '
                 'accessToken: ${accessToken != null ? "FOUND" : "MISSING"}');

      if (idToken == null) {
        debugPrint('[SupabaseAuth] CRITICAL ERROR: idToken is NULL but user signed in.');
        debugPrint('[SupabaseAuth] HINT: This usually means GOOGLE_WEB_CLIENT_ID is NOT a "Web Application" type ID, '
                   'OR the Android SHA-1 is missing in Google Cloud Console.');
        throw 'No ID Token found from Google Sign-In. Check console for details.';
      }

      // 2. Sign in to Supabase with the ID Token
      debugPrint('[SupabaseAuth] Native Sign-In - Attempting Supabase login with idToken...');
      return await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on gn_auth.GoogleSignInAccount catch (e) {
       debugPrint('[SupabaseAuth] GoogleSignInAccount Error: $e');
       rethrow;
    } catch (e) {
      debugPrint('[SupabaseAuth] UNEXPECTED ERROR during Google Sign-In: $e');
      if (e.toString().contains('PlatformException')) {
        debugPrint('[SupabaseAuth] PlatformException detected. This often relates to SHA-1 or package name mismatch.');
      }
      rethrow;
    }
  }

  /// Kakao Login (Native & Web)
  /// Phase v1.2.0: Support for Kakao OAuth
  static Future<void> signInWithKakao() async {
    try {
      if (kIsWeb) {
        // Phase v15.8.12: SDK 표준 흐름으로 복구하되, 리다이렉트 URI를 정규화하여 사용
        final String origin = Uri.base.origin;
        final String redirectUrl = origin.endsWith('/') ? origin : '$origin/';
        
        debugPrint('[SupabaseAuth] Web: Starting OAuth with redirect: $redirectUrl');
        
        await SupabaseHelper.client.auth.signInWithOAuth(
          OAuthProvider.kakao,
          redirectTo: redirectUrl,
        );
        return;
      }

      // Native Kakao Login (handles KakaoTalk or Browser automatically)
      debugPrint('[SupabaseAuth] Starting Native Kakao OAuth...');
      
      // We use signInWithOAuth for simplicity on Native as well, 
      // Supabase handles the deep link callback.
      await SupabaseHelper.client.auth.signInWithOAuth(
        OAuthProvider.kakao,
        redirectTo: 'io.supabase.talkie://login-callback',
      );
    } catch (e) {
      debugPrint('[SupabaseAuth] Kakao Sign-In Error: $e');
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
