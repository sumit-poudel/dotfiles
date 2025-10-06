#!/bin/bash

# === CONFIGURATION ===
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
TRANSITION_TYPE="center"
FPS=60
DURATION=1.0
STATE_FILE="$HOME/.cache/current_wallpaper"

# === PREPARE WALLPAPER LIST ===
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)
count=${#wallpapers[@]}
[[ $count -eq 0 ]] && echo "No wallpapers found." && exit 1

# === FIND CURRENT INDEX ===
current_index=0
if [[ -f "$STATE_FILE" ]]; then
  current_wall=$(<"$STATE_FILE")
  for i in "${!wallpapers[@]}"; do
    [[ "${wallpapers[$i]}" == "$current_wall" ]] && current_index=$i && break
  done
fi

# === HANDLE ARGUMENTS ===
case "$1" in
  --next)
    next_index=$(( (current_index + 1) % count ))
    wallpaper="${wallpapers[$next_index]}"
    ;;
  --prev)
    prev_index=$(( (current_index - 1 + count) % count ))
    wallpaper="${wallpapers[$prev_index]}"
    ;;
  --sync)
    wallpaper=$(<"$STATE_FILE")
    matugen image "$wallpaper"
    ;;
  --restore)
    if [[ -f "$STATE_FILE" ]]; then
      wallpaper=$(<"$STATE_FILE")
    else
      wallpaper=$(shuf -n 1 -e "${wallpapers[@]}")
    fi
   ;;
   --random|*)
    wallpaper=$(shuf -n 1 -e "${wallpapers[@]}")
   ;;
esac

# === APPLY WALLPAPER ===
swww img "$wallpaper" \
  --transition-type "$TRANSITION_TYPE" \
  --transition-fps "$FPS" \
  --transition-duration "$DURATION"

# === SAVE CURRENT WALLPAPER ===
echo "$wallpaper" > "$STATE_FILE"

