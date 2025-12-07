
#!/bin/bash

# Check arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <ColorschemeName> <BackgroundHexWithoutHash> <OutlineHexWithoutHash>"
    exit 1
fi

MyColorscheme=$1
BC=$2
OC=$3

# Directories
SVG_DIR="/home/gero/tools/Bibata_Cursor/svg/original"
BITMAP_DIR="/home/gero/tools/Bibata_Cursor/bitmaps/Bibata-$MyColorscheme"
BUILD_FILE="/home/gero/tools/Bibata_Cursor/configs/normal/x.build.toml"

# Generate bitmap
npx cbmp -d "$SVG_DIR" -o "$BITMAP_DIR" -bc "#$BC" -oc "#$OC" -wc "#000000"

# Generate cursor theme
ctgen "$BUILD_FILE" -d "$BITMAP_DIR" -n "Bibata-$MyColorscheme" -c "Groovy Bibata cursors."
