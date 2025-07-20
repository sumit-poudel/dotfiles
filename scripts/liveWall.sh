#!/bin/bash

VIDEO="/home/sumit/Videos/liveWallpaper/purpleEyes.mp4"

if [ "$1" = "start" ]; then
    pkill mpvpaper
    swww kill

    for MON in $(hyprctl monitors | awk '/Monitor/ {print $2}'); do
        mpvpaper "$MON" -o "--loop --no-audio --no-osc --no-input-default-bindings --no-border --fullscreen --panscan=1 --geometry=100%x100%" "$VIDEO" &
    done

elif [ "$1" = "stop" ]; then
    pkill mpvpaper
    swww-daemon
else
    echo "Usage: $0 [start|stop]"
fi

