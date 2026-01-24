---
description: How to add new localization strings and auto-translate them
---
# Localization Update Workflow

1. **Add to Master ARB**
   - Open `lib/l10n/app_ko.arb` (Master Language).
   - Add your new key and Korean text:
     ```json
     "newKey": "새로운 텍스트"
     ```

2. **Add to English ARB (Optional but Recommended)**
   - Open `lib/l10n/app_en.arb`.
   - Add the English translation for reference:
     ```json
     "newKey": "New text"
     ```

3. **Run Automation Script**
   - Execute the following command in the terminal:
     ```bash
     dart tool/manage_l10n.dart
     ```
   - This script will:
     - Detect keys missing in other language ARB files.
     - Automatically translate the Korean text to the target language using Google Cloud Translation API.
     - Update all 40+ ARB files.

**IMPORTANT:**
- Do NOT manually add keys to `app_ja.arb`, `app_fr.arb`, etc., unless you are improving the translation quality.
- Let the script handle the heavy lifting to avoid inconsistencies and tedious manual work.
