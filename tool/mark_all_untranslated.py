import os, json

"""
Comprehensive script to mark ALL untranslated/incorrectly-translated entries.
Combines 1st pass (same as EN), 2nd pass (short words), and 3rd pass (wrong English like menuWebDownload).
"""

en_data = json.load(open('lib/l10n/app_en.arb', encoding='utf-8'))
ko_data = json.load(open('lib/l10n/app_ko.arb', encoding='utf-8'))

# Keys to always skip (intentionally same across all languages)
SKIP_KEYS = {'appTitle', 'titleFormat', '@@locale'}

# Known incorrect English values that need translation 
# (key -> wrong value that should be replaced)
KNOWN_WRONG_ENGLISH = {
    'menuWebDownload': 'Get Material from Web',
}

total_marked = 0

for fl in sorted(os.listdir('lib/l10n')):
    if not (fl.startswith('app_') and fl.endswith('.arb')): continue
    if fl in ('app_en.arb', 'app_ko.arb'): continue
    
    path = os.path.join('lib/l10n', fl)
    data = json.load(open(path, encoding='utf-8'))
    changed = False
    file_marked = 0
    
    for k, v in list(data.items()):
        if k.startswith('@') or k.startswith('@@'): continue
        if k in SKIP_KEYS: continue
        if k not in en_data: continue
        if '(TODO' in str(v): continue
        
        should_mark = False
        
        # Case 1: Value is exactly same as English master (untranslated)
        if v == en_data[k]:
            should_mark = True
        
        # Case 2: Value matches a known wrong English value
        if k in KNOWN_WRONG_ENGLISH and v == KNOWN_WRONG_ENGLISH[k]:
            should_mark = True
        
        if should_mark:
            data[k] = en_data[k] + ' (TODO: Translate)'
            changed = True
            file_marked += 1
    
    if changed:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"  Marked {file_marked} keys in {fl}")
        total_marked += file_marked

print(f"\nTotal marked: {total_marked}")
