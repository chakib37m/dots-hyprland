#!/bin/bash

function check_curl() {
    echo a
    if [[ "$IMAGE_URL" != "null" && -n "$IMAGE_URL" ]]; then
        curl -s -o "$FILENAME" "$IMAGE_URL"
    else
        check_curl
    fi
}

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="$XDG_CONFIG_HOME/ags"
CACHE_DIR="$HOME/.cache/wc/images"
FILENAME="$CACHE_DIR/wp2.jpg"
PURITY="110"
API_URL="https://wallhaven.cc/api/v1/search?sorting=random&order=desc&categories=010&purity=${PURITY}&atleast=1920x1080&resolutions=1920x1080,2560x1440,3840x2160&ratios=16x9&topRange=1M&seed=$RANDOM"

RESPONSE=$(curl -s "$API_URL")
IMAGE_URL=$(echo "$RESPONSE" | jq -r '.data[0].path')
check_curl

killall -9 hyprpaper2
waypaper --wallpaper "$FILENAME"
# Generate colors for ags n stuff
"$CONFIG_DIR"/scripts/color_generation/colorgen.sh "${FILENAME}" --apply --smart
wait
mv "$FILENAME" "$CACHE_DIR/wp.jpg"
exit
