#!/usr/bin/env bash

# Update the colour scheme across the desktop using Pywal or Matugen.
#
# Usage: update-colors.sh [wallpaper]
# If a wallpaper path is provided, that image will be used to generate
# colours.  Otherwise, the script will read the last wallpaper from
# ~/.cache/current_wallpaper or use the image configured in
# hyprpaper.conf.  The script then copies the generated colour files
# into the appropriate config directories and signals applications to
# reload their themes.

set -e

WALLPAPER="$1"

# Determine wallpaper
if [ -z "$WALLPAPER" ]; then
    if [ -f ~/.cache/current_wallpaper ]; then
        WALLPAPER=$(<~/.cache/current_wallpaper)
    elif [ -f ~/.config/hypr/hyprpaper.conf ]; then
        # Extract wallpaper path from hyprpaper.conf
        WALLPAPER=$(grep -E '^wallpaper\s*=' ~/.config/hypr/hyprpaper.conf | head -1 | sed 's/^wallpaper\s*=\s*[^,]*,\s*//' | sed 's|\$HOME|'"$HOME"'|g' | xargs)
    elif [ -f ~/Pictures/wallpapers/desert.jpg ]; then
        WALLPAPER=~/Pictures/wallpapers/desert.jpg
    fi
fi

if [ -z "$WALLPAPER" ]; then
    echo "No wallpaper specified and no cached wallpaper found." >&2
    exit 1
fi

# Generate colours using matugen or wal
if command -v matugen >/dev/null 2>&1; then
    matugen --destination ~/.cache/wal "$WALLPAPER"
elif command -v wal >/dev/null 2>&1; then
    wal -i "$WALLPAPER" -n
else
    echo "Error: neither matugen nor pywal is installed." >&2
    exit 1
fi

# Save the current wallpaper path for future runs
echo "$WALLPAPER" > ~/.cache/current_wallpaper

# Copy generated colour files where applications expect them
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/wofi ~/.config/kitty

# Hyprland colours
if [ -f ~/.cache/wal/colors-hyprland.conf ]; then
    cp ~/.cache/wal/colors-hyprland.conf ~/.config/hypr/colors.conf
fi

# Waybar colours (CSS variables).  Wal names this file `colors.css`
if [ -f ~/.cache/wal/colors.css ]; then
    cp ~/.cache/wal/colors.css ~/.config/waybar/colors.css
fi

# Wofi colours (simple list)
if [ -f ~/.cache/wal/colors-wofi ]; then
    cp ~/.cache/wal/colors-wofi ~/.config/wofi/colors
fi

# Kitty colours
if [ -f ~/.cache/wal/colors-kitty.conf ]; then
    cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/pywal.conf
fi

# Reload Hyprland and Waybar to apply new colours
hyprctl reload || true
pkill -SIGUSR2 waybar || true

echo "Colour scheme updated based on $WALLPAPER"