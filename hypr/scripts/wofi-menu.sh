#!/usr/bin/env bash

# A custom menu for Hyprland using Wofi in dmenu mode.
#
# This script displays a list of actions such as launching
# applications, opening a floating terminal, changing the wallpaper
# using a picker, and showing a power menu.  Selecting an entry
# executes the associated command.  Icons are provided via Nerd Font
# glyphs; ensure you have a Nerd Font installed (e.g. JetBrains Mono
# Nerd Font).

set -euo pipefail

# Define menu entries and associated commands.  Each entry consists of
# a label (which will be shown in the menu) and a command to run when
# selected.  The icon codes come from the Nerd Font icon set.
declare -a options=(
  "󰍉 Applications | wofi --show drun --allow-images --prompt='Run:'"
  " Terminal | kitty --class kitty-floating"
  " Files (Yazi) | kitty --class yazi-floating -e yazi"
  " Wallpaper | ~/.config/hypr/scripts/wofi-wallpaper.sh"
  " Power | ~/.config/hypr/scripts/wofi-power.sh"
  "󰌍 Emoji | ~/.config/hypr/scripts/wofi-emoji.sh"
  " Calculator | ~/.config/hypr/scripts/wofi-calc.sh"
)

# Build the menu input (labels) and a parallel array of commands.
menu=""
declare -a commands=()
for entry in "${options[@]}"; do
    label="${entry%%|*}"
    cmd="${entry##*| }"
    menu+="${label}\n"
    commands+=("$cmd")
done

# Display the menu using wofi in dmenu mode.  The --insensitive flag
# makes matching case‑insensitive.  The height and width can be
# adjusted here; feel free to tune them to taste.
selected=$(printf "%b" "$menu" | wofi --dmenu --prompt='Menu:' --insensitive --height=400 --width=500 --allow-markup)

# Exit if the user cancelled or closed the menu.
if [[ -z "$selected" ]]; then
    exit 0
fi

# Find and execute the corresponding command.  We iterate through
# labels to find the match.  Once found, we run it in the background
# so that this script returns immediately and doesn’t block Hyprland.
for i in "${!options[@]}"; do
    label="${options[$i]%%|*}"
    if [[ "$selected" == "$label" ]]; then
        eval "${commands[$i]}" &
        exit 0
    fi
done

exit 0