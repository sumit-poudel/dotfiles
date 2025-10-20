#!/usr/bin/env bash

if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

monitor_json=$(hyprctl -j monitors)
monitor_info=$(echo "$monitor_json" | jq '.[] | select(.focused==true)')
height=$(echo "$monitor_info" | jq -r '.height')
scale=$(echo "$monitor_info" | jq -r '.scale')

effective_height=$(awk "BEGIN {printf \"%.0f\", $height / $scale}")
wlogout_height=400
margin=$(awk "BEGIN {printf \"%.0f\", ($effective_height - $wlogout_height) / 2}")

wlogout \
  -C "$HOME/.config/wlogout/matugen-wlogout.css" \
  -l "$HOME/.config/wlogout/layout" \
  --protocol layer-shell \
  -T "$margin" -B "$margin" \
  -b 5 &
 
