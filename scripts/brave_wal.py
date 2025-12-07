#!/usr/bin/env python3
import json
import os
import sys

# Paths
CACHE_FILE = os.path.expanduser("~/.cache/wal/colors.json")
THEME_DIR = os.path.expanduser("~/.cache/wal/brave_theme")
MANIFEST_FILE = os.path.join(THEME_DIR, "manifest.json")

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return list(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def main():
    # 1. Read Pywal Colors
    if not os.path.exists(CACHE_FILE):
        print("❌ Wal cache not found. Run 'wal' first.")
        sys.exit(1)
        
    with open(CACHE_FILE, 'r') as f:
        data = json.load(f)
        c = data['colors']
        bg = data['special']['background']
        fg = data['special']['foreground']

    # 2. Map Colors to Chrome Theme Keys
    # We use a mix of the background and accent colors for a cohesive look
    theme_colors = {
        "frame": hex_to_rgb(bg),
        "frame_inactive": hex_to_rgb(bg),
        "toolbar": hex_to_rgb(c['color0']), 
        "ntp_background": hex_to_rgb(bg),
        "ntp_text": hex_to_rgb(fg),
        "tab_text": hex_to_rgb(fg),
        "tab_background_text": hex_to_rgb(c['color8']),
        "button_background": hex_to_rgb(c['color2']),
        "omnibox_background": hex_to_rgb(bg),
        "omnibox_text": hex_to_rgb(fg),
    }

    # 3. Create Manifest Structure
    manifest = {
        "manifest_version": 3,
        "version": "1.0",
        "name": "Wal Brave Theme",
        "description": "Auto-generated theme from Pywal",
        "theme": {
            "colors": theme_colors
        }
    }

    # 4. Write to File
    os.makedirs(THEME_DIR, exist_ok=True)
    with open(MANIFEST_FILE, 'w') as f:
        json.dump(manifest, f, indent=4)
    
    print(f"✅ Brave theme generated at: {THEME_DIR}")

if __name__ == "__main__":
    main()
