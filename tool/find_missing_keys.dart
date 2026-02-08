import 'dart:convert';
import 'dart:io';

void main() {
  final masterFile = File('lib/l10n/app_ko.arb');
  final master = jsonDecode(masterFile.readAsStringSync()) as Map<String, dynamic>;
  final masterKeys = master.keys.where((k) => !k.startsWith('@') && k != '@@locale').toSet();

  final dir = Directory('lib/l10n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb') && !f.path.contains('app_ko.arb')).toList();

  final Map<String, List<String>> missingReport = {};

  for (final file in files) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final langCode = fileName.split('_').last.replaceAll('.arb', '');
    final target = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final targetKeys = target.keys.toSet();

    final missing = masterKeys.difference(targetKeys).toList();
    if (missing.isNotEmpty) {
      missingReport[langCode] = missing;
    }
  }

  print(jsonEncode(missingReport));
}
