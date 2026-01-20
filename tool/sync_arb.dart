import 'dart:io';
import 'dart:convert';

void main() async {
  final l10nDir = Directory('lib/l10n');
  final enFile = File('${l10nDir.path}/app_en.arb');
  
  if (!enFile.existsSync()) {
    print('Error: app_en.arb not found');
    exit(1);
  }

  final enContent = await enFile.readAsString();
  final Map<String, dynamic> enMap = jsonDecode(enContent);
  final Set<String> enKeys = enMap.keys.toSet();

  await for (final file in l10nDir.list()) {
    if (file is File && file.path.endsWith('.arb') && !file.path.endsWith('app_en.arb')) {
      print('Processing ${file.path}...');
      
      try {
        final content = await file.readAsString();
        final Map<String, dynamic> targetMap = jsonDecode(content);
        final Set<String> targetKeys = targetMap.keys.toSet();
        
        bool changed = false;

        // 1. Remove extra keys (not in EN)
        final keysToRemove = targetKeys.difference(enKeys);
        for (final key in keysToRemove) {
          targetMap.remove(key);
          changed = true;
        }

        // 2. Add missing keys from EN
        final keysToAdd = enKeys.difference(targetKeys);
        for (final key in keysToAdd) {
            targetMap[key] = enMap[key];
            changed = true;
            print('  Added: $key');
        }

        if (changed) {
          final encoder = JsonEncoder.withIndent('  ');
          await file.writeAsString(encoder.convert(targetMap));
          print('  Updated ${file.path}');
        }
      } catch (e) {
        print('Error processing ${file.path}: $e');
      }
    }
  }
  print('Sync complete.');
}
