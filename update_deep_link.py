import sys
import re

file1 = r'c:\FlutterProjects\talkie\android\app\src\main\AndroidManifest.xml'
with open(file1, 'r', encoding='utf-8') as f:
    content = f.read()

intent_to_add = '''
            <!-- Deep Links for Supabase OAuth Callback (Prevents collision with Kakao SDK) -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="io.supabase.talkie" android:host="login-callback" />
            </intent-filter>
        </activity>'''

content = content.replace('        </activity>', intent_to_add, 1)

with open(file1, 'w', encoding='utf-8') as f:
    f.write(content)

file2 = r'c:\FlutterProjects\talkie\lib\services\supabase\supabase_auth_service.dart'
with open(file2, 'r', encoding='utf-8') as f:
    content2 = f.read()

old_text = "redirectTo: 'kakao${dotenv.env['KAKAO_NATIVE_APP_KEY']}://oauth',"
new_text = "redirectTo: 'io.supabase.talkie://login-callback',"

content2 = content2.replace(old_text, new_text)

with open(file2, 'w', encoding='utf-8') as f:
    f.write(content2)

print('Success')
