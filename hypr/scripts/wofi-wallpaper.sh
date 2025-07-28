#!/usr/bin/env bash

# Wallpaper picker for Hyprland using Wofi.  This script scans a
# directory of images (defaults to ~/Pictures/wallpapers) and presents
# them in a wofi dmenu.  Selecting an image sets it as the current
# wallpaper via hyprpaper and triggers a colour scheme update via
# update-colors.sh.

set -euo pipefail

WALL_DIR="${1:-$HOME/Pictures/wallpapers}"
# Fallback to ~/Pictures if the wallpapers directory is missing
if [[ ! -d "$WALL_DIR" ]]; then
    WALL_DIR="$HOME/Pictures"
fi

# Collect image files (jpg, png, jpeg, webp) within one level of
# WALL_DIR.  Use find with -print0 to handle spaces in filenames.
declare -a files=()
while IFS= read -r -d '' file; do
    files+=("$file")
done < <(find "$WALL_DIR" -maxdepth 2 -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \) -print0)

if [[ ${#files[@]} -eq 0 ]]; then
    # If no images are found, notify and exit gracefully.  notify-send is
    # provided by libnotify, but if it's missing the message is simply
    # printed to stderr.
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Wallpaper Picker" "No images found in $WALL_DIR"
    else
        echo "No images found in $WALL_DIR" >&2
    fi
    exit 1
fi

# Build the list of choices from basenames; this will be presented
# to the user via wofi.  Use newline separators.
choices=""
for f in "${files[@]}"; do
    name=$(basename "$f")
    choices+="$name\n"
done

selected=$(printf "%b" "$choices" | wofi --dmenu --prompt='Select wallpaper:' --insensitive --height=400 --width=600 --allow-markup)

[[ -z "$selected" ]] && exit 0

# Find the full path of the selected file by matching the basename.
fullpath=""
for f in "${files[@]}"; do
    if [[ "$(basename "$f")" == "$selected" ]]; then
        fullpath="$f"
        break
    fi
done

if [[ -z "$fullpath" ]]; then
    echo "Error: selected wallpaper could not be found" >&2
    exit 1
fi

# Use hyprpaper to set the wallpaper.  Preload improves transition
# performance.  The syntax is `hyprctl hyprpaper wallpaper \"<monitor>,<path>\"`.
hyprctl hyprpaper preload "$fullpath" >/dev/null 2>&1 || true
hyprctl hyprpaper wallpaper ",${fullpath}" >/dev/null 2>&1 || true

# Save the selected wallpaper path so update-colors.sh can read it later.
mkdir -p "$HOME/.cache"
echo "$fullpath" > "$HOME/.cache/current_wallpaper"

# Trigger colour scheme generation and propagation.  Pass the selected
# wallpaper path so that update-colors.sh doesn’t need to re‑detect it.
"$HOME/.config/hypr/scripts/update-colors.sh" "$fullpath" &

exit 0