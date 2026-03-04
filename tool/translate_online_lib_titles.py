import os
import json
import asyncio
from google import genai
from google.genai import types

# Load .env manually
env_file = ".env"
if os.path.exists(env_file):
    with open(env_file, "r") as f:
        for line in f:
            if line.startswith("GEMINI_API_KEY="):
                os.environ["GEMINI_API_KEY"] = line.split("=", 1)[1].strip()

# 1. 대상 키바인딩 정의
new_keys = {
    "libTitleNouns1": "Nouns 1",
    "libTitleVerbs1": "Verbs 1",
    "libTitleGreetings1": "Greetings 1",
    "libTitleFirstMeeting": "First Meeting"
}

L10N_DIR = "lib/l10n"
MASTER_FILE = os.path.join(L10N_DIR, "app_en.arb")

# Initialize Gemini Client
client = genai.Client()

async def translate_text(text: str, target_lang: str) -> str:
    prompt = f"Translate the following short UI title into {target_lang}. Only provide the translated text, no explanation or punctuation: '{text}'"
    try:
        # Run synchronous generate_content in an executor to not block the event loop
        loop = asyncio.get_event_loop()
        response = await loop.run_in_executor(
            None,
            lambda: client.models.generate_content(
                model='gemini-2.5-flash',
                contents=prompt,
                config=types.GenerateContentConfig(
                    temperature=0.1,
                ),
            )
        )
        return response.text.strip()
    except Exception as e:
        print(f"Error translating '{text}' to {target_lang}: {e}")
        return text # fallback to english

async def process_file(filename):
    if not filename.endswith(".arb"): return
    if filename == "app_en.arb": return

    filepath = os.path.join(L10N_DIR, filename)
    with open(filepath, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    lang_code = filename.split("_")[1].split(".")[0]
    
    # Check if we need to update
    needs_update = False
    for key, en_text in new_keys.items():
        if key not in data:
            needs_update = True
            break
            
    if not needs_update:
        return
        
    print(f"Translating for {lang_code}...")
    for key, en_text in new_keys.items():
        if key not in data:
            translated_text = await translate_text(en_text, lang_code)
            data[key] = translated_text
            
    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

async def main():
    # 1. Update master file (app_en.arb) first
    with open(MASTER_FILE, "r", encoding="utf-8") as f:
        master_data = json.load(f)
        
    master_updated = False
    for k, v in new_keys.items():
        if k not in master_data:
            master_data[k] = v
            master_updated = True
            
    if master_updated:
        with open(MASTER_FILE, "w", encoding="utf-8") as f:
            json.dump(master_data, f, ensure_ascii=False, indent=2)
            
    # 2. Update all other files concurrently
    files = [f for f in os.listdir(L10N_DIR) if f.startswith("app_") and f.endswith(".arb")]
    tasks = [process_file(f) for f in files]
    await asyncio.gather(*tasks)
    print("Done translating online library titles.")

if __name__ == "__main__":
    asyncio.run(main())
