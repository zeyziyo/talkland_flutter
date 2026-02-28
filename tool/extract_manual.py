import os
import json
import glob

def extract():
    l10n_dir = 'lib/l10n'
    output_file = 'docs/manual_data.js'
    
    # Target keys for the manual
    target_keys = [
        "helpTitle", "helpTabModes", "helpTabJson", "helpTabTour",
        "helpMode1Desc", "helpMode1Details",
        "helpMode2Desc", "helpMode2Details",
        "helpMode3Desc", "helpMode3Details",
        "helpModeChatDesc", "helpModeChatDetails",
        "helpJsonDesc", "helpJsonTypeDialogue", "helpJsonTypeSentence", "helpJsonTypeWord",
        "helpDialogueImportDesc", "helpDialogueImportDetails",
        "menuDeviceImport", "menuWebDownload", "appTitle",
        "saveData", "flip", "hide", "onlineMaterialsIndexUrl"
    ]
    
    all_data = {}
    
    arb_files = glob.glob(os.path.join(l10n_dir, 'app_*.arb'))
    
    for arb_path in arb_files:
        # Extract locale from filename (e.g., app_ko.arb -> ko)
        filename = os.path.basename(arb_path)
        locale = filename.replace('app_', '').replace('.arb', '')
        
        try:
            with open(arb_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
            locale_data = {}
            for key in target_keys:
                if key in data:
                    locale_data[key] = data[key]
            
            if locale_data:
                all_data[locale] = locale_data
                
        except Exception as e:
            print(f"Error processing {arb_path}: {e}")

    # Write as JS file to avoid CORS issues in static file hosting
    js_content = "const MANUAL_DATA = " + json.dumps(all_data, ensure_ascii=False, indent=2) + ";"
    
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(js_content)
    
    print(f"Successfully extracted {len(all_data)} languages to {output_file}")

if __name__ == "__main__":
    extract()
