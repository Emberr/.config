#!/usr/bin/env bash

# A simple power menu implemented with wofi.  Presents a list of
# actions and performs them based on selection.  Feel free to add
# additional options such as hibernate or hybrid‑sleep.

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