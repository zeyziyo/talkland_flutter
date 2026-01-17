
import os
import json

l10n_dir = r"c:\FlutterProjects\talkie\lib\l10n"
en_arb_path = os.path.join(l10n_dir, "app_en.arb")

def load_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_json(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

def main():
    if not os.path.exists(en_arb_path):
        print(f"Error: {en_arb_path} not found.")
        return

    en_data = load_json(en_arb_path)
    en_keys = set(en_data.keys())

    print(f"Loaded English master ARB with {len(en_keys)} keys.")

    arb_files = [f for f in os.listdir(l10n_dir) if f.endswith('.arb') and f != 'app_en.arb']
    
    for arb_file in arb_files:
        path = os.path.join(l10n_dir, arb_file)
        try:
            data = load_json(path)
            
            # Find missing keys
            missing_keys = [k for k in en_keys if k not in data]
            
            if not missing_keys:
                print(f"Skipping {arb_file} (no missing keys)")
                continue
                
            print(f"Updating {arb_file}: Adding {len(missing_keys)} missing keys.")
            
            # Add missing keys - Using English value as fallback
            # We also need to handle metadata keys starting with @
            for key in missing_keys:
                 data[key] = en_data[key]

            # Sort keys to match EN order somewhat or just alphabetically?
            # Keeping it simple for now, just appending. 
            # Actually, standard JSON dicts are insertion ordered in modern python, but rebuilding might be cleaner.
            
            save_json(path, data)
            
        except Exception as e:
            print(f"Failed to process {arb_file}: {e}")

if __name__ == "__main__":
    main()
