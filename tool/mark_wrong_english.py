import os, json

en_data = json.load(open('lib/l10n/app_en.arb', encoding='utf-8'))

# Find keys where the value in a non-en/ko file is English text 
# that is DIFFERENT from the English master value.
# This catches cases like "Get Material from Web" instead of "User Manual"

total_marked = 0
problem_keys = {}

for fl in sorted(os.listdir('lib/l10n')):
    if not (fl.startswith('app_') and fl.endswith('.arb')): continue
    if fl in ('app_en.arb', 'app_ko.arb'): continue
    
    path = os.path.join('lib/l10n', fl)
    data = json.load(open(path, encoding='utf-8'))
    changed = False
    file_marked = 0
    
    for k, v in list(data.items()):
        if k.startswith('@') or k.startswith('@@'): continue
        if k not in en_data: continue
        if '(TODO' in str(v): continue
        
        # Check if value is ASCII English text (not the correct en master value)
        if isinstance(v, str) and len(v) > 3:
            # Check if all chars are ASCII (likely English)
            is_ascii = all(ord(c) < 256 for c in v)
            # And different from English master
            if is_ascii and v != en_data[k]:
                # This is suspicious - English text that doesn't match master
                problem_keys.setdefault(k, {'en': en_data[k], 'files': []})
                problem_keys[k]['files'].append((fl, v))
                data[k] = v + ' (TODO: Translate)'
                changed = True
                file_marked += 1
    
    if changed:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        total_marked += file_marked

print(f"Problem keys found: {len(problem_keys)}")
for k, info in sorted(problem_keys.items()):
    print(f"\n  Key: {k}")
    print(f"  EN master: {info['en']}")
    print(f"  Files affected: {len(info['files'])}")
    for fl, v in info['files'][:3]:
        print(f"    {fl}: {v}")

print(f"\nTotal marked: {total_marked}")
