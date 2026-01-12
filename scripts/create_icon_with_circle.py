#!/usr/bin/env python3
"""
Script untuk membuat launcher icon dengan lingkaran putih + logo
sesuai desain splash screen
"""

from PIL import Image, ImageDraw
import os

# Ukuran icon
SIZE = 1024

# Buat canvas dengan background biru
img = Image.new('RGB', (SIZE, SIZE), '#2563EB')
draw = ImageDraw.Draw(img)

# Gambar lingkaran putih (65% dari ukuran canvas)
circle_size = int(SIZE * 0.65)
circle_pos = (SIZE - circle_size) // 2

# Buat mask untuk lingkaran dengan anti-aliasing
mask = Image.new('L', (SIZE, SIZE), 0)
mask_draw = ImageDraw.Draw(mask)
mask_draw.ellipse(
    [circle_pos, circle_pos, circle_pos + circle_size, circle_pos + circle_size],
    fill=255
)

# Buat layer lingkaran putih
white_circle = Image.new('RGB', (SIZE, SIZE), '#FFFFFF')
img.paste(white_circle, (0, 0), mask)

# Load logo dan resize
logo_path = 'assets/images/logo_smartspend.png'
if os.path.exists(logo_path):
    logo = Image.open(logo_path)
    
    # Resize logo (50% dari lingkaran)
    logo_size = int(circle_size * 0.5)
    logo = logo.resize((logo_size, logo_size), Image.Resampling.LANCZOS)
    
    # Paste logo di tengah lingkaran
    logo_pos = (SIZE - logo_size) // 2
    
    # Convert logo to RGBA if needed
    if logo.mode != 'RGBA':
        logo = logo.convert('RGBA')
    
    img.paste(logo, (logo_pos, logo_pos), logo)
else:
    print(f"Warning: Logo file not found at {logo_path}")

# Save
output_path = 'assets/images/app_launcher_icon_with_circle.png'
img.save(output_path, 'PNG', quality=100)
print(f"✅ Icon created: {output_path}")
print(f"   Size: {SIZE}x{SIZE}")
print(f"   Design: Blue background + white circle + logo (same as splash)")









