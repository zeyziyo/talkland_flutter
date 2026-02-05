import os
import json

def sync_bo():
    en_path = r"c:\FlutterProjects\talkie\lib\l10n\app_en.arb"
    bo_path = r"c:\FlutterProjects\talkie\lib\l10n\app_bo.arb"
    
    with open(en_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    data["@@locale"] = "bo"
    
    with open(bo_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print("app_bo.arb sycned with en keys")

sync_bo()
