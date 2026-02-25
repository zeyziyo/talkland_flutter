import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'services/supabase_service.dart';
import 'services/background_sync_service.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'dart:io' as io;
import 'package:google_mobile_ads/google_mobile_ads.dart' hide AppState;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Kakao SDK before any UI build
  // v1.2.0: Added Kakao Login Support
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'],
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT_KEY'],
  );

  debugPrint('>>> MAIN [1] Widgets/Kakao Binding Initialized');
  
  // Desktop SQLite FFI setup (not for web)
  if (kIsWeb) {
    // Web setup
    databaseFactory = databaseFactoryFfiWeb;
  } else if (io.Platform.isWindows || io.Platform.isLinux) {
    // Desktop setup
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  debugPrint('>>> MAIN [2] Database Factory Set');
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Warning: Failed to load .env file: $e");
    // Ensure app continues even if .env fails to load
  }
  
  // Initialize AdMob (mobile only)
  if (!kIsWeb) {
    try {
      if (io.Platform.isAndroid || io.Platform.isIOS) {
        await MobileAds.instance.initialize();
      }
    } catch (e) {
      print("Warning: AdMob init failed: $e");
    }
  }

  // Initialize SharedPrefs
  final prefs = await SharedPreferences.getInstance();
  debugPrint('>>> MAIN [3] SharedPrefs Done');

  // Initialize Supabase
  try {
    await SupabaseService.initialize();
  } catch (e) {
    debugPrint('>>> MAIN [!] Supabase Error: $e');
    print("Error initializing Supabase: $e"); 
  }
  debugPrint('>>> MAIN [4] Supabase Init Attempted');
  
  // Initialize Background Sync (Workmanager)
  if (!kIsWeb && (io.Platform.isAndroid || io.Platform.isIOS)) {
    try {
      // Lazy import handled by file level, but logic conditional
      await BackgroundSyncService.initialize();
      await BackgroundSyncService.registerPeriodicTask();
    } catch (e) {
      print("Error initializing Background Sync: $e");
    }
  }

  runApp(TalkieApp(prefs: prefs));
}

class TalkieApp extends StatelessWidget {
  final SharedPreferences prefs;
  const TalkieApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(prefs),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Talkie',
            
            // Localization
            locale: _resolveLocale(appState.sourceLang),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  Locale _resolveLocale(String langCode) {
    // Handle special cases with script/country codes
    if (langCode == 'zh-CN') {
      return const Locale('zh', 'CN');
    } else if (langCode == 'zh-TW') {
      return const Locale('zh', 'TW');
    }
    // For simple language codes (ko, en, ja, etc.)
    return Locale(langCode);
  }
}
