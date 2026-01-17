
import os
from PIL import Image

# Use the REAL source asset this time
source_path = r"c:\FlutterProjects\talkie\assets\icon.png"
dest_path = r"c:\FlutterProjects\talkie\docs\play_store\store_icon_512.jpg"

try:
    if not os.path.exists(source_path):
        print(f"Error: Source file not found at {source_path}")
        # Fallback to try finding it
        source_path = r"c:\FlutterProjects\talkie\assets\icon1.png"
        
    print(f"Processing source: {source_path}")
    
    with Image.open(source_path) as img:
        print(f"Original size: {img.size}")
        
        # Convert to RGB (removes alpha channel, replacing transparent with white/black depending on impl)
        # Better to paste onto a solid background if transparent
        if img.mode in ('RGBA', 'LA'):
            background = Image.new('RGB', img.size, (255, 255, 255)) # White background
            # Or maybe we want to keep the icon's background? 
            # Usually app icons are squares. If it's a circle with transparency, Play Store wants a square.
            # Assuming the icon.png is the full square asset.
            
            # Let's just convert to RGB directly first, usually safe for full bleed icons
            rgb_img = img.convert('RGB') 
        else:
            rgb_img = img.convert('RGB')
            
        # Resize to 512x512 exactly using high quality resampling
        final_img = rgb_img.resize((512, 512), Image.Resampling.LANCZOS)
        
        # Save as JPEG (No alpha, small size)
        final_img.save(dest_path, "JPEG", quality=95)
        print(f"Successfully saved REAL icon to {dest_path}")
        print(f"New size: {final_img.size}")

except Exception as e:
    print(f"Error: {e}")
