#!/bin/bash

# --- Configuration ---
MUSIC_DIR="$HOME/Music"
CACHE_DIR="$HOME/.cache/mpd_art"
THEME_FILE="$HOME/.cache/wal/current_theme_name"
WALL_ROOT="$HOME/Pictures/Wallpapers"

# SIZE CONFIGURATION
ART_SIZE="600"

mkdir -p "$CACHE_DIR"

# State variables
last_album=""
last_state=""

# --- FUNCTION: Restore Theme ---
restore_theme() {
    echo "⏸️  Music paused. Reverting to default theme..."
    if [ -f "$THEME_FILE" ]; then
        THEME_NAME=$(cat "$THEME_FILE")
        SCHEME_PATH="$HOME/nix-dots/config/wal/colorschemes/${THEME_NAME}.json"
        [ ! -f "$SCHEME_PATH" ] && SCHEME_PATH="$HOME/.config/wal/colorschemes/${THEME_NAME}.json"

        if [ -f "$SCHEME_PATH" ]; then
            wal -f "$SCHEME_PATH" -n -t -q
        fi

        WALL_DIR="$WALL_ROOT/$THEME_NAME"
        if [ -d "$WALL_DIR" ]; then
            TARGET_WALL=$(find "$WALL_DIR" -maxdepth 1 -type f -name "main.*" | head -n 1)
            [ -z "$TARGET_WALL" ] && TARGET_WALL=$(find "$WALL_DIR" -maxdepth 1 -type f | head -n 1)

            if [ -n "$TARGET_WALL" ]; then
                [ -x "$(command -v swww)" ] && swww img "$TARGET_WALL" --transition-type none
                HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
                [ -f "$HYPRLOCK_CONFIG" ] && sed -i "s|^\$wallpaper = .*|\$wallpaper = $TARGET_WALL|" "$HYPRLOCK_CONFIG"
            fi
        fi
        reload_apps
    fi
}

# --- FUNCTION: Reload Apps ---
reload_apps() {
    sleep 0.1
    hyprctl reload > /dev/null
    pkill dunst && dunst & disown
    [ -x "$(command -v pywalfox)" ] && pywalfox update
    if [ -x "$(command -v nvr)" ]; then
        for socket in /tmp/nvim.*.0; do
            [ -S "$socket" ] && nvr --servername "$socket" --remote-send ":colorscheme wal<CR>" &
        done
    fi
}

echo "🎨 Mood Ring started. Waiting for MPD events..."

while true; do
    status_output=$(mpc status)
    if echo "$status_output" | grep -q "\[playing\]"; then
        current_state="playing"
    else
        current_state="paused"
    fi

    # A. PAUSE LOGIC
    if [ "$current_state" == "paused" ]; then
        if [ "$last_state" == "playing" ]; then
            restore_theme
            last_album="" 
        fi
    fi

    # B. PLAYING LOGIC
    if [ "$current_state" == "playing" ]; then
        current_file=$(mpc current -f "%file%")
        current_album=$(mpc current -f "%album%")

        if [ "$current_album" != "$last_album" ] || [ "$last_state" == "paused" ]; then
             echo "✨ applying music theme: $current_album"
             
             full_path="$MUSIC_DIR/$current_file"
             safe_name=$(echo "$current_album" | sed 's/[^a-zA-Z0-9]/_/g')
             
             # CLEANUP: Remove old specific files to save space
             rm "$CACHE_DIR/"*_raw.png 2>/dev/null
             rm "$CACHE_DIR/"wallpaper_*.png 2>/dev/null

             # NEW UNIQUE FILENAMES
             raw_art="$CACHE_DIR/${safe_name}_raw.png"
             final_wall="$CACHE_DIR/wallpaper_${safe_name}.png" # Unique name forces swww reload
             temp_extract="$CACHE_DIR/temp_extract.jpg"

             # --- 1. SMART EXTRACTION (Bit-Perfect to PNG) ---
             ffmpeg -i "$full_path" -an -c:v copy "$temp_extract" -y &> /dev/null

             if [ -f "$temp_extract" ]; then
                 dims=$(identify -format "%w:%h" "$temp_extract" 2>/dev/null)
                 w=$(echo "$dims" | cut -d: -f1)
                 h=$(echo "$dims" | cut -d: -f2)
                 
                 if [ "$w" -eq "$h" ] && [ "$w" -gt 0 ]; then
                     echo "   💎 Using Original Art (Converting to PNG...)"
                     magick "$temp_extract" "$raw_art"
                 else
                     echo "   ✂️  Cropping rectangular art to PNG..."
                     ffmpeg -i "$temp_extract" -vf "crop=ih:ih" -c:v png "$raw_art" -y &> /dev/null
                 fi
             fi

             if [ -f "$raw_art" ]; then
                RES=$(hyprctl monitors -j | jq -r '.[0] | "\(.width)x\(.height)"')
                [ -z "$RES" ] && RES="1920x1080"

                # 2. GENERATE WALLPAPER (With Drop Shadow & Cache Busting)
                magick "$raw_art" \
                    \( -clone 0 -filter Gaussian -resize 25% -blur 0x10 -resize "$RES^" \
                       -gravity center -extent "$RES" \
                       -attenuate 0.1 +noise Gaussian \
                       -fill black -colorize 50% \) \
                    \( -clone 0 -filter Lanczos -resize x${ART_SIZE} \
                       \( +clone -background black -shadow 60x20+0+15 \) \
                       +swap -background none -layers merge +repage \) \
                    -delete 0 \
                    -gravity center -composite \
                    "$final_wall"

                # 3. Generate Colors
                wal -i "$raw_art" -n -t -q

                # 4. Apply
                # Use the UNIQUE filename so swww sees it as a new image
                [ -x "$(command -v swww)" ] && swww img "$final_wall" --transition-type none
                
                HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
                [ -f "$HYPRLOCK_CONFIG" ] && sed -i "s|^\$wallpaper = .*|\$wallpaper = $final_wall|" "$HYPRLOCK_CONFIG"
                
                reload_apps
             else
                echo "   ⚠️ No cover art found."
             fi
             last_album="$current_album"
        fi
    fi

    last_state="$current_state"
    mpc idle player
done
