#!/usr/bin/env bash

# Emoji picker wrapper.  Prefer the `wofimoji` utility (GitHub
# project) if installed; fall back to `wofi-emoji` from the AUR.

if command -v wofimoji >/dev/null 2>&1; then
    exec wofimoji "$@"
elif command -v wofi-emoji >/dev/null 2>&1; then
    exec wofi-emoji "$@"
else
    notify-send -u low "Emoji picker not installed" "Install the wofimoji or wofi-emoji package."
fi