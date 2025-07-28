#!/usr/bin/env bash

# Simple power menu built with Wofi.  Presents a list of common
# power actions and performs them based on the user’s selection.

options="Lock\nLogout\nSuspend\nHibernate\nReboot\nShutdown"
selected=$(echo -e "$options" | wofi --show dmenu --prompt "Power" --height 300 --width 200 --cache-file "$XDG_CACHE_HOME/wofi-power.cache")

case "$selected" in
    Lock)
        hyprlock
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        systemctl suspend
        ;;
    Hibernate)
        systemctl hibernate
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac