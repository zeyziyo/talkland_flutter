import 'dart:io';

const List<String> kTargetLocales = [
  'af', 'am', 'ar', 'as', 'az', 'be', 'bg', 'bn', 'bo', 'bs', 'ca', 'cs', 'cy', 'da', 
  'de', 'el', 'en', 'es', 'et', 'eu', 'fa', 'fi', 'fil', 'fr', 'gl', 'gu', 'he', 'hi', 
  'hr', 'hu', 'hy', 'id', 'is', 'it', 'ja', 'ka', 'kk', 'km', 'kn', 'ko', 'ky', 'lo', 
  'lt', 'lv', 'mk', 'ml', 'mn', 'mr', 'ms', 'my', 'nb', 'ne', 'nl', 'or', 'pa', 'pl', 
  'pt', 'ro', 'ru', 'si', 'sk', 'sl', 'sq', 'sr', 'sv', 'sw', 'ta', 'te', 'th', 'tl', 
  'tr', 'uk', 'ur', 'uz', 'vi', 'zh', 'zu'
];

void main() async {
  print('🌍 Starting Locale Expansion...');
  final l10nDir = Directory('lib/l10n');
  if (!l10nDir.existsSync()) {
    print('❌ Error: lib/l10n directory not found.');
    return;
  }

  int createdCount = 0;
  for (final code in kTargetLocales) {
    final file = File('lib/l10n/app_$code.arb');
    if (!file.existsSync()) {
      print('➕ Creating new locale: $code');
      // Use zh_CN/zh_TW style for zh if needed, but for now base is fine.
      // Special case for zh: we already have zh, zh_CN, zh_TW.
      if (code == 'zh' && File('lib/l10n/app_zh_CN.arb').existsSync()) continue;
      
      await file.writeAsString('{\n  "@@locale": "$code"\n}\n');
      createdCount++;
    }
  }

  print('✅ Finished. Created $createdCount new ARB files.');
  print('👉 Now run: dart tool/manage_l10n.dart');
}
