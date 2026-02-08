import 'dart:convert';
import 'dart:io';

const List<String> kKeysToClear = [
  'practiceModeTitle',
  'chatAiChat',
  'helpMode3Desc',
  'helpModeChatDesc',
  'tutorialAiChatTitle'
];

void main() async {
  final dir = Directory('lib/l10n');
  final masterPath = 'lib/l10n/app_ko.arb';
  
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb') && !f.path.contains('app_ko.arb')).toList();
  
  for (final file in files) {
    try {
      final content = await file.readAsString();
      final Map<String, dynamic> map = jsonDecode(content);
      bool changed = false;
      
      for (final key in kKeysToClear) {
        if (map.containsKey(key)) {
          map.remove(key);
          changed = true;
        }
      }
      
      if (changed) {
        const encoder = JsonEncoder.withIndent('  ');
        await file.writeAsString(encoder.convert(map));
        print('Cleared keys in ${file.path}');
      }
    } catch (e) {
      print('Error processing ${file.path}: $e');
    }
  }
}
