#!/bin/bash

# Get current microphone mute status
MUTED=$(pamixer --default-source --get-mute) 

if [ "$MUTED" = "true" ]; then
    notify-send -u low \
        -h string:synchronous:mic \
        "  Microphone" "muted"
else
    notify-send -u low \
        -h string:synchronous:mic \
        " Microphone" "unmuted"
fi

