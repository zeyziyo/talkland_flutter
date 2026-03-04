import os, json

master_en = json.load(open('lib/l10n/app_en.arb', encoding='utf-8'))

# Keys to skip (intentionally English)
skip_keys = {'appTitle', 'titleFormat', '@@locale'}

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
        if k in skip_keys: continue
        if k not in master_en: continue
        
        # If value is same as English AND doesn't have TODO marker already
        if v == master_en[k] and '(TODO' not in str(v):
            data[k] = v + ' (TODO: Translate)'
            changed = True
            file_marked += 1
    
    if changed:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"  Marked {file_marked} keys in {fl}")
        total_marked += file_marked

print(f"\nTotal marked: {total_marked}")
