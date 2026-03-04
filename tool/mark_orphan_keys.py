import os, json

# Keys that exist in non-English ARB files but are not in app_en.arb
# and have English text that needs translation
# We'll use app_ko.arb as the reference to understand the meaning

ko_data = json.load(open('lib/l10n/app_ko.arb', encoding='utf-8'))
en_data = json.load(open('lib/l10n/app_en.arb', encoding='utf-8'))

# Find keys that are in ko but not in en (orphaned keys)
orphan_keys = set()
for k in ko_data:
    if k.startswith('@') or k.startswith('@@'):
        continue
    if k not in en_data:
        orphan_keys.add(k)

print(f"Orphan keys (in ko but not in en): {len(orphan_keys)}")
for k in sorted(orphan_keys):
    print(f"  {k}: {ko_data[k]}")

# Now mark English text in these orphan keys across all non-en/ko ARB files
total_marked = 0
for fl in sorted(os.listdir('lib/l10n')):
    if not (fl.startswith('app_') and fl.endswith('.arb')): continue
    if fl in ('app_en.arb', 'app_ko.arb'): continue
    
    path = os.path.join('lib/l10n', fl)
    data = json.load(open(path, encoding='utf-8'))
    changed = False
    file_marked = 0
    
    for k in orphan_keys:
        if k in data and '(TODO' not in str(data[k]):
            # Check if the value looks like English text (not already translated)
            val = data[k]
            # Simple heuristic: if all chars are ASCII and length > 3, it's likely untranslated English
            if all(ord(c) < 256 for c in val) and len(val) > 3:
                data[k] = val + ' (TODO: Translate)'
                changed = True
                file_marked += 1
    
    if changed:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"  Marked {file_marked} keys in {fl}")
        total_marked += file_marked

print(f"\nTotal marked: {total_marked}")
