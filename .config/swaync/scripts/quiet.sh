#!/bin/bash

if ! asusctl profile -p | grep -q "Active profile is Quiet"; then
  notify-send "Setting quiet mode..." asusctl -i asus_notif_white -a asusctl
  asusctl profile -P Quiet
else
  notify-send "Setting balanced mode..." asusctl -i asus_notif_white -a asusctl
  asusctl profile -P Balanced
fi
