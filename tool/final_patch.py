import os

# 1. Update devWebsiteUrl in app_constants.dart
file_const = 'lib/constants/app_constants.dart'
with open(file_const, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace existing devWebsiteUrl (which might be index.html or readme anchor)
import re
pattern = r"static const String devWebsiteUrl = '.*';"
replacement = "static const String devWebsiteUrl = '$githubBaseUrl/index.html';"
content = re.sub(pattern, replacement, content)

with open(file_const, 'w', encoding='utf-8') as f:
    f.write(content)

# 2. Update home_screen.dart
file_home = 'lib/screens/home_screen.dart'
with open(file_home, 'r', encoding='utf-8') as f:
    content = f.read()

# Find the block we added or the original block
# We are looking for the case 'downloads' block
# It might look like our previous patch or original

# Search for the downloads case block
pattern_home = r"(case 'downloads':\s+)(.*?)(break;)"
# Replace whatever is inside with our new clean query param logic
replacement_home = r"""\1final localeCode = Localizations.localeOf(context).languageCode;
                      final targetUrl = '${AppConstants.devWebsiteUrl}?lang=$localeCode';
                      _launchURL(targetUrl);
                      \3"""

content = re.sub(pattern_home, replacement_home, content, flags=re.DOTALL)

with open(file_home, 'w', encoding='utf-8') as f:
    f.write(content)

# 3. Bump version in pubspec.yaml
file_pub = 'pubspec.yaml'
with open(file_pub, 'r', encoding='utf-8') as f:
    content_pub = f.read()

content_pub = content_pub.replace('version: 1.4.2+20', 'version: 1.5.0+21')

with open(file_pub, 'w', encoding='utf-8') as f:
    f.write(content_pub)

# 4. Clean up README.md (Remove manual guide sections at the end)
readme_path = 'README.md'
with open(readme_path, 'r', encoding='utf-8') as f:
    content_readme = f.read()

if '## <a id="readme-ko"></a>📘' in content_readme:
    split_parts = content_readme.split('---')
    # Assuming it's the last part we added
    new_readme = '---'.join(split_parts[:-1]) # Remove the last appended part if possible
    # A safer way is to just cut from the first anchor
    cut_index = content_readme.find('## <a id="readme-ko"></a>')
    if cut_index != -1:
        # Find the separator before it
        sep_index = content_readme.rfind('---', 0, cut_index)
        if sep_index != -1:
            new_readme = content_readme[:sep_index].strip()
        else:
            new_readme = content_readme[:cut_index].strip()
        
        with open(readme_path, 'w', encoding='utf-8') as f:
            f.write(new_readme)

# 5. Remove temporary files
if os.path.exists('docs/index.html'):
    os.remove('docs/index.html')
