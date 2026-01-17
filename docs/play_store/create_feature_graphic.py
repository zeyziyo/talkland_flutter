
from PIL import Image

source_path = r"c:\FlutterProjects\talkie\docs\play_store\graphics\feature_graphic.png"
dest_path = r"c:\FlutterProjects\talkie\docs\play_store\feature_graphic_1024x500.png"

try:
    # Open source (which we know is 1024x1024)
    img = Image.open(source_path).convert('RGB')
    
    # Target dimensions
    TARGET_WIDTH = 1024
    TARGET_HEIGHT = 500
    
    # Get background color from top-left
    bg_color = img.getpixel((0, 0))
    print(f"Background Color: {bg_color}")
    
    # Create new canvas 1024x500
    canvas = Image.new('RGB', (TARGET_WIDTH, TARGET_HEIGHT), bg_color)
    
    # Strategy: Resize the original square image to fit within the height of 500
    # giving it some padding so it doesn't touch edges.
    # Let's say we want the logo part to be about 400px high.
    aspect_ratio = img.width / img.height
    new_height = 420
    new_width = int(new_height * aspect_ratio)
    
    resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    
    # Center it
    x = (TARGET_WIDTH - new_width) // 2
    y = (TARGET_HEIGHT - new_height) // 2
    
    canvas.paste(resized_img, (x, y))
    
    # Save as PNG
    canvas.save(dest_path, "PNG")
    print(f"Successfully saved feature graphic to {dest_path}")

except Exception as e:
    print(f"Error: {e}")
