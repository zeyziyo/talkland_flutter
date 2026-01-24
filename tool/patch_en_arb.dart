import 'dart:io';
import 'dart:convert';

void main() {
  final file = File('lib/l10n/app_en.arb');
  final content = file.readAsStringSync();
  Map<String, dynamic> json = jsonDecode(content);

  // Helper to add int metadata
  void addIntMetadata(String key, String placeholder) {
    String metaKey = '@$key';
    if (!json.containsKey(metaKey)) {
      json[metaKey] = {};
    }
    if (!json[metaKey].containsKey('placeholders')) {
      json[metaKey]['placeholders'] = {};
    }
    json[metaKey]['placeholders'][placeholder] = {'type': 'int'};
  }

  addIntMetadata('tabReview', 'count');
  addIntMetadata('tabStudyMaterial', 'count');
  addIntMetadata('studyRecords', 'count');
  addIntMetadata('importTotal', 'count');
  addIntMetadata('importAdded', 'count');
  addIntMetadata('importSkipped', 'count');
  addIntMetadata('reviewCount', 'count');
  addIntMetadata('totalRecords', 'count');
  addIntMetadata('intervalSeconds', 'seconds');
  
  // Progress has 2
  String key = 'progress';
  String metaKey = '@$key';
    if (!json.containsKey(metaKey)) {
      json[metaKey] = {};
    }
    if (!json[metaKey].containsKey('placeholders')) {
      json[metaKey]['placeholders'] = {};
    }
    json[metaKey]['placeholders']['current'] = {'type': 'int'};
    json[metaKey]['placeholders']['total'] = {'type': 'int'};

  final encoder = JsonEncoder.withIndent('  ');
  file.writeAsStringSync(encoder.convert(json));
  print('Patched app_en.arb');
}
