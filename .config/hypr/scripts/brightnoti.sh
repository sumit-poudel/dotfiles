#!/bin/bash

# Get brightness (requires brightnessctl)
BRIGHTNESS=$(brightnessctl get)
MAX=$(brightnessctl max)
PERCENT=$(( BRIGHTNESS * 100 / MAX ))

notify-send -u low \
    -h int:value:$PERCENT \
    -h string:synchronous:brightness \
    " Brightness" "${PERCENT}%"

