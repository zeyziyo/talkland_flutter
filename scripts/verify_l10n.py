import os
import json
import re

def verify_json(file_path):
    """유효한 JSON 형식인지 확인"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return True, None
    except Exception as e:
        return False, str(e)

def check_encoding_corruption(file_path):
    """인코딩 깨짐(REPLACEMENT CHARACTER 등) 탐지"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            if '\ufffd' in content:
                return False, "Found replacement character (\\ufffd)"
            
            # 비정상적인 깨짐 패턴 (가정: 한글/영어가 아닌데 깨진 문자열 조합 감지)
            # 여기서는 간단히 UTF-8로 읽히지 않는 경우 등으로 대체 가능
            return True, None
    except UnicodeDecodeError as e:
        return False, f"Decode error: {str(e)}"

def verify_arb_files(l10n_dir):
    """ARB 파일들의 키 일관성 확인"""
    en_path = os.path.join(l10n_dir, 'app_en.arb')
    if not os.path.exists(en_path):
        return ["app_en.arb not found"]
    
    with open(en_path, 'r', encoding='utf-8') as f:
        en_keys = set(json.load(f).keys())
    
    errors = []
    for filename in os.listdir(l10n_dir):
        if filename.endswith('.arb') and filename != 'app_en.arb':
            path = os.path.join(l10n_dir, filename)
            try:
                with open(path, 'r', encoding='utf-8') as f:
                    current_keys = set(json.load(f).keys())
                    missing = en_keys - current_keys
                    if missing:
                        errors.append(f"{filename}: Missing keys {missing}")
            except Exception as e:
                errors.append(f"{filename}: Load failed - {str(e)}")
    return errors

def main():
    base_dir = r"c:\FlutterProjects\talkie"
    l10n_dir = os.path.join(base_dir, "lib", "l10n")
    materials_dir = os.path.join(base_dir, "docs", "materials")
    
    print("=== Talkie L10n Verification Start ===")
    
    # 1. ARB 검증
    print("\n[1] Verifying ARB files consistency...")
    arb_errors = verify_arb_files(l10n_dir)
    if arb_errors:
        for err in arb_errors:
            print(f"  [ERROR] {err}")
    else:
        print("  [OK] All ARB files are consistent with app_en.arb")
    
    # 2. JSON 학습 자료 검증
    print("\n[2] Verifying Study Material JSONs (Encoding & Syntax)...")
    json_count = 0
    error_count = 0
    
    for root, dirs, files in os.walk(materials_dir):
        for file in files:
            if file.endswith('.json'):
                json_count += 1
                path = os.path.join(root, file)
                rel_path = os.path.relpath(path, materials_dir)
                
                # 구문 검사
                valid, err = verify_json(path)
                if not valid:
                    print(f"  [ERROR] {rel_path}: JSON Syntax Error - {err}")
                    error_count += 1
                    continue
                
                # 인코딩 깨짐 검사
                valid, err = check_encoding_corruption(path)
                if not valid:
                    print(f"  [WARNING] {rel_path}: Encoding Issue - {err}")
                    error_count += 1

    print(f"\nSummary: Checked {json_count} JSON files. Errors/Warnings: {error_count}")
    print("\n=== Verification Complete ===")

if __name__ == "__main__":
    main()
