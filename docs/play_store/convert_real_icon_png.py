
import os
from PIL import Image

# Use the REAL source asset
source_path = r"c:\FlutterProjects\talkie\assets\icon.png"
dest_path = r"c:\FlutterProjects\talkie\docs\play_store\store_icon_512.png" # Changed to PNG

try:
    if not os.path.exists(source_path):
        source_path = r"c:\FlutterProjects\talkie\assets\icon1.png"
        
    print(f"Processing source: {source_path}")
    
    with Image.open(source_path) as img:
        print(f"Original size: {img.size}")
        
        # Guidelines say "32-bit PNG (with alpha)".
        # So we should convert to RGBA to ensure alpha channel exists, 
        # or keep original mode if it has alpha.
        if img.mode != 'RGBA':
            final_img = img.convert('RGBA')
        else:
            final_img = img
            
        # Resize to 512x512 exactly
        final_img = final_img.resize((512, 512), Image.Resampling.LANCZOS)
        
        # Save as PNG
        final_img.save(dest_path, "PNG")
        print(f"Successfully saved REAL icon to {dest_path}")
        print(f"New size: {final_img.size}")

except Exception as e:
    print(f"Error: {e}")
