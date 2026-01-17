
import os
from PIL import Image

src_dir = r"c:\FlutterProjects\talkie\docs\play_store\screenshots"
dest_dir = r"c:\FlutterProjects\talkie\docs\play_store\screenshots_9_16"

if not os.path.exists(dest_dir):
    os.makedirs(dest_dir)

files = [f for f in os.listdir(src_dir) if f.lower().endswith('.jpg')]

for i, f in enumerate(files):
    try:
        path = os.path.join(src_dir, f)
        with Image.open(path) as img:
            w, h = img.size
            
            # Target 9:16 ratio
            # Width is usually 1080.
            # Target Height = Width * (16/9)
            target_h = int(w * (16/9))
            
            if h > target_h:
                # Too tall, crop the bottom
                # (Keep top 0 to target_h)
                crop_box = (0, 0, w, target_h)
                new_img = img.crop(crop_box)
                print(f"Cropped {f} from {w}x{h} to {w}x{target_h}")
                
            elif h < target_h:
                # Too short (rare for screenshots), maybe pad? 
                # Or just leave it if it's close.
                # If it's 16:9 (landscape), we should check.
                # But here we assume portrait based on previous check.
                print(f"Skipping {f} (Height {h} < {target_h})")
                new_img = img
            else:
                new_img = img
                
            # Rename for safety (no spaces, english)
            new_name = f"screenshot_{i+1}.jpg"
            save_path = os.path.join(dest_dir, new_name)
            new_img.save(save_path, "JPEG", quality=95)
            print(f"Saved to {save_path}")

    except Exception as e:
        print(f"Error processing {f}: {e}")
