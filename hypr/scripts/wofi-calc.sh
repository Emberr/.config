#!/usr/bin/env bash

# Calculator launcher for Wayland.  If the `wofi-calc` utility is
# installed (from the AUR), use it directly.  Otherwise, fall back
# to a basic calculator implemented via `bc` with input from a Wofi
# dmenu.

if command -v wofi-calc >/dev/null 2>&1; then
    exec wofi-calc "$@"
else
    # fallback: prompt the user for an expression using wofi in dmenu mode
    expression=$(wofi --show dmenu --prompt "Calc" --height 200 --width 300)
    [ -z "$expression" ] && exit 0
    result=$(echo "$expression" | bc -l 2>/dev/null)
    notify-send "Result" "$expression = $result"
fi