import os, json

master_en = json.load(open('lib/l10n/app_en.arb', encoding='utf-8'))

for fl in os.listdir('lib/l10n'):
    if not (fl.startswith('app_') and fl.endswith('.arb')): continue
    if fl in ('app_en.arb', 'app_ko.arb'): continue
    
    p = os.path.join('lib/l10n', fl)
    with open(p, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    changed = False
    for k, v in data.items():
        if k.startswith('@') or k not in master_en: continue
        
        en_val = master_en[k]
        # 영문 원문과 일치하고 길이가 2자 이상인 경우 미번역으로 간주
        if v == en_val and len(str(v)) > 2 and v not in ['Talkie', '1.', '2.', '3.']:
            data[k] = f"{v} (TODO: Translate)"
            changed = True
            
    if changed:
        with open(p, 'w', encoding='utf-8', newline='\n') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write('\n') # Ensure trailing newline
        print(f"Updated {fl}")
