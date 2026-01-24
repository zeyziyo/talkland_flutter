import 'dart:io';

void main() {
  final dir = Directory('lib/l10n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb'));

  for (final file in files) {
    String content = file.readAsStringSync();
    
    // Regex to find "titleFormat": "..." and inside it, replace content with {type}: {materialName}
    // ACTUALLY, simpler: simple replacement of the whole line if the key matches.
    // Because the format is simple: "titleFormat": "SOMETHING",
    
    // We want to preserve the translation of the "structure" if possible, but the placeholders MUST be {type} and {materialName}.
    // But since the structure is just "{type}: {materialName}", checking if it was translated to "{tipo}: {nombre}" implies the *structure* is just placeholders.
    // So we can arguably just force reset the value to "{type}: {materialName}" for consistency, OR try to find the translated words and revert them.
    
    // Given the simple format "{A}: {B}", it is safer to just RESET it to "{type}: {materialName}" for all files to ensure build passes.
    // If we want localized colon usage, that's minor.
    
    // Let's just force replace the value of titleFormat to "{type}: {materialName}" to rescue the build.
    
    final regex = RegExp(r'"titleFormat":\s*".*?"');
    if (content.contains('"titleFormat"')) {
       final newContent = content.replaceAll(regex, '"titleFormat": "{type}: {materialName}"');
       file.writeAsStringSync(newContent);
       print('Fixed ${file.path}');
    }
  }
}
