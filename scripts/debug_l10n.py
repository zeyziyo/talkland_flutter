import os
import json

def check_l10n():
    l10n_dir = 'lib/l10n'
    required_keys = ['helpModeChatDesc', 'noDialogueHistory']
    missing_report = {}

    for filename in os.listdir(l10n_dir):
        if filename.endswith('.arb'):
            filepath = os.path.join(l10n_dir, filename)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    for key in required_keys:
                        if key not in data:
                            if filename not in missing_report:
                                missing_report[filename] = []
                            missing_report[filename].append(key)
            except Exception as e:
                print(f"Error reading {filename}: {e}")

    if not missing_report:
        print("✅ All .arb files contain the required keys.")
    else:
        print("❌ Missing keys found:")
        for file, keys in missing_report.items():
            print(f"  {file}: {', '.join(keys)}")

if __name__ == "__main__":
    check_l10n()
