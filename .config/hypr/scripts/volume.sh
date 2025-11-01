#!/bin/bash

# Get Volume
get_volume() {
  volume=$(pamixer --get-volume)
  echo "$volume"
}

# Notify
notify_user() {
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Volume : $(get_volume)"
}

# Increase Volume
inc_volume() {
  pamixer -i 5 && notify_user
  #pamixer -i 5
}

# Decrease Volume
dec_volume() {
  pamixer -d 5 && notify_user
  #pamixer -d 5
}

# Toggle Mute
toggle_mute() {
  if [ "$(pamixer --get-mute)" == "false" ]; then
    pamixer -m && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Speaker Muted"
    #pamixer -m
  elif [ "$(pamixer --get-mute)" == "true" ]; then
    pamixer -u && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Speaker UnMuted"
    #pamixer -u
  fi
}

# Toggle Mic
toggle_mic() {
  if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
    pamixer -m --default-source && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Microphone Muted"
    #pamixer -m --default-source
  elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
    pamixer -u --default-source && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Microphone UnMuted"
    #pamixer -u --default-source
  fi
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
  get_volume
elif [[ "$1" == "--inc" ]]; then
  inc_volume
elif [[ "$1" == "--dec" ]]; then
  dec_volume
elif [[ "$1" == "--toggle" ]]; then
  toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
  toggle_mic
else
  get_volume
fi
