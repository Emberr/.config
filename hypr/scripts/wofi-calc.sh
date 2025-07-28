#!/usr/bin/env bash

# Calculator launcher.  If the `wofi-calc` utility is available it will
# be invoked.  Otherwise, fall back to a basic calculator using bash.

if command -v wofi-calc >/dev/null 2>&1; then
    exec wofi-calc "$@"
else
    # fallback: use bc with a simple prompt
    expression=$(wofi --show dmenu --prompt "Calc" --height 200 --width 300)
    [ -z "$expression" ] && exit 0
    result=$(echo "$expression" | bc -l 2>/dev/null)
    notify-send "Result" "$expression = $result"
fi