#!/bin/bash

# Get current volume and mute status
VOLUME=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)

if [ "$MUTED" = "true" ]; then
    notify-send -e -u low \
        -h string:synchronous:volume \
        " Volume" "Muted"
else
    notify-send -e -u low \
        -h int:value:$VOLUME \
        -h string:synchronous:volume \
        " Volume" "${VOLUME}%"
fi

