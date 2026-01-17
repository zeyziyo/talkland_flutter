
import os
from PIL import Image

dir_path = r"c:\FlutterProjects\talkie\docs\play_store\screenshots"
files = [f for f in os.listdir(dir_path) if f.lower().endswith('.jpg')]

print(f"Checking {len(files)} images...")

for f in files:
    path = os.path.join(dir_path, f)
    try:
        with Image.open(path) as img:
            w, h = img.size
            ratio = w / h
            print(f"File: {f} | Size: {w}x{h} | Ratio: {ratio:.2f}")
            
            # Check constraints
            if w < 320 or h < 320:
                print("  -> WARNING: Too small")
            if w > 3840 or h > 3840:
                print("  -> WARNING: Too large")
                
            # Check aspect ratio roughly
            # 9:16 = 0.5625
            # 16:9 = 1.77
            if 0.4 < ratio < 0.7:
                print("  -> Looks like Portrait (9:16 ok)")
            elif 1.4 < ratio < 2.0:
                print("  -> Looks like Landscape (16:9 ok)")
            else:
                print("  -> WARNING: Odd aspect ratio")
                
    except Exception as e:
        print(f"Error reading {f}: {e}")
