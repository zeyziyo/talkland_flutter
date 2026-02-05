import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String kGeminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
const String kSourceLang = 'English';
const String kBaseDir = 'docs/materials';

final List<Map<String, String>> kAllLanguages = [
  {"name": "Afrikaans", "code": "af"},
  {"name": "Albanian", "code": "sq"},
  {"name": "Amharic", "code": "am"},
  {"name": "Arabic", "code": "ar"},
  {"name": "Armenian", "code": "hy"},
  {"name": "Assamese", "code": "as"},
  {"name": "Azerbaijani", "code": "az"},
  {"name": "Basque", "code": "eu"},
  {"name": "Belarusian", "code": "be"},
  {"name": "Bengali", "code": "bn"},
  {"name": "Bosnian", "code": "bs"},
  {"name": "Bulgarian", "code": "bg"},
  {"name": "Burmese", "code": "my"},
  {"name": "Catalan", "code": "ca"},
  {"name": "Chinese (Simplified)", "code": "zh-CN"},
  {"name": "Chinese (Traditional)", "code": "zh-TW"},
  {"name": "Croatian", "code": "hr"},
  {"name": "Czech", "code": "cs"},
  {"name": "Danish", "code": "da"},
  {"name": "Dutch", "code": "nl"},
  {"name": "English", "code": "en"},
  {"name": "Estonian", "code": "et"},
  {"name": "Filipino", "code": "fil"},
  {"name": "Finnish", "code": "fi"},
  {"name": "French", "code": "fr"},
  {"name": "Galician", "code": "gl"},
  {"name": "Georgian", "code": "ka"},
  {"name": "German", "code": "de"},
  {"name": "Greek", "code": "el"},
  {"name": "Gujarati", "code": "gu"},
  {"name": "Hebrew", "code": "he"},
  {"name": "Hindi", "code": "hi"},
  {"name": "Hungarian", "code": "hu"},
  {"name": "Icelandic", "code": "is"},
  {"name": "Indonesian", "code": "id"},
  {"name": "Italian", "code": "it"},
  {"name": "Japanese", "code": "ja"},
  {"name": "Kannada", "code": "kn"},
  {"name": "Kazakh", "code": "kk"},
  {"name": "Khmer", "code": "km"},
  {"name": "Korean", "code": "ko"},
  {"name": "Kyrgyz", "code": "ky"},
  {"name": "Lao", "code": "lo"},
  {"name": "Latvian", "code": "lv"},
  {"name": "Lithuanian", "code": "lt"},
  {"name": "Macedonian", "code": "mk"},
  {"name": "Malay", "code": "ms"},
  {"name": "Malayalam", "code": "ml"},
  {"name": "Marathi", "code": "mr"},
  {"name": "Mongolian", "code": "mn"},
  {"name": "Nepali", "code": "ne"},
  {"name": "Norwegian", "code": "no"},
  {"name": "Odia", "code": "or"},
  {"name": "Persian", "code": "fa"},
  {"name": "Polish", "code": "pl"},
  {"name": "Portuguese", "code": "pt"},
  {"name": "Punjabi", "code": "pa"},
  {"name": "Romanian", "code": "ro"},
  {"name": "Russian", "code": "ru"},
  {"name": "Serbian", "code": "sr"},
  {"name": "Sinhala", "code": "si"},
  {"name": "Slovak", "code": "sk"},
  {"name": "Slovenian", "code": "sl"},
  {"name": "Spanish", "code": "es"},
  {"name": "Swahili", "code": "sw"},
  {"name": "Swedish", "code": "sv"},
  {"name": "Tagalog", "code": "tl"},
  {"name": "Tamil", "code": "ta"},
  {"name": "Telugu", "code": "te"},
  {"name": "Thai", "code": "th"},
  {"name": "Tibetan", "code": "bo"},
  {"name": "Turkish", "code": "tr"},
  {"name": "Ukrainian", "code": "uk"},
  {"name": "Urdu", "code": "ur"},
  {"name": "Uzbek", "code": "uz"},
  {"name": "Vietnamese", "code": "vi"},
  {"name": "Welsh", "code": "cy"},
  {"name": "Xhosa", "code": "xh"},
  {"name": "Zulu", "code": "zu"}
];

void main() async {
  print('🚀 Generating Homepage Materials for Missing Locales...');
  final envFile = File('.env');
  if (!envFile.existsSync()) return;
  final env = await envFile.readAsLines();
  final apiKeyLine = env.firstWhere((l) => l.startsWith('GEMINI_API_KEY='), orElse: () => '');
  final apiKey = apiKeyLine.split('=').last;

  if (apiKey.isEmpty) {
    print('❌ API Key not found.');
    return;
  }

  // 1. Get Master Files
  final masterDir = Directory('$kBaseDir/$kSourceLang');
  final masterFiles = <String>[];
  if (masterDir.existsSync()) {
    await for (final entity in masterDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.json')) {
        // Use path normalization
        final normalizedPath = entity.path.replaceAll('\\', '/');
        final normalizedBase = '$kBaseDir/$kSourceLang/'.replaceAll('\\', '/');
        masterFiles.add(normalizedPath.replaceFirst(normalizedBase, ''));
      }
    }
  }

  print('📦 Master files identified: ${masterFiles.length}');

  // 2. Process each language
  for (final lang in kAllLanguages) {
    final langName = lang['name']!;
    final targetDir = Directory('$kBaseDir/$langName');
    
    if (targetDir.existsSync() && targetDir.listSync(recursive: true).whereType<File>().length == masterFiles.length) {
      // Already complete
      continue;
    }

    print('🌐 Processing: $langName...');
    
    for (final relPath in masterFiles) {
      final sourceFile = File('$kBaseDir/$kSourceLang/$relPath');
      final targetFile = File('$kBaseDir/$langName/$relPath');
      
      if (targetFile.existsSync()) continue;

      targetFile.parent.createSync(recursive: true);
      
      final content = await sourceFile.readAsString();
      final data = jsonDecode(content);
      
      print('   📝 Translating $relPath...');
      try {
        final translatedData = await translateJson(data, langName, apiKey);
        await targetFile.writeAsString(JsonEncoder.withIndent('    ').convert(translatedData));
        print('   ✅ Saved $relPath');
      } catch (e) {
        print('   ❌ Error translating $relPath: $e');
      }
      
      // Delay for rate limiting
      await Future.delayed(Duration(seconds: 4));
    }
  }

  print('✨ All materials generated.');
}

Future<dynamic> translateJson(dynamic data, String targetLang, String apiKey) async {
  final prompt = '''
Translate the following JSON object values from English to $targetLang.
Return ONLY a valid JSON object with the same keys and structure.
Translate the "subject" and all "text" values in the "entries" array.
Keep "note" as is (or translate if it seems like a translation hint).
Do not translate keys.

Input JSON:
${jsonEncode(data)}
''';

  final response = await http.post(
    Uri.parse('$kGeminiUrl?key=$apiKey'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
        {
          'parts': [{'text': prompt}]
        }
      ],
      'generationConfig': {
        'response_mime_type': 'application/json',
      }
    }),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    final text = result['candidates'][0]['content']['parts'][0]['text'];
    return jsonDecode(text);
  } else if (response.statusCode == 429) {
    print('   ⚠️ Rate limited. Waiting 10s...');
    await Future.delayed(Duration(seconds: 10));
    return translateJson(data, targetLang, apiKey);
  } else {
    throw Exception('Gemini Error: ${response.statusCode} - ${response.body}');
  }
}
