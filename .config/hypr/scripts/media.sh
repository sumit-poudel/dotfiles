#!/bin/bash

# Max lenght for media
maxlength=40
# Get current playing song from playerctl
if command -v playerctl &> /dev/null; then
    # Check if any player is running
    if playerctl status &> /dev/null; then
        artist=$(playerctl metadata artist 2>/dev/null)
        title=$(playerctl metadata title 2>/dev/null)

        if [[ -n "$artist" && -n "$title" ]]; then
            song="♪ $artist - $title"
        elif [[ -n "$title" ]]; then
            song="♪ $title"
        else
            song="♪ Music Playing"
        fi

        # Truncate with ellipsis if needed
        if (( ${#song} > maxlength )); then
            echo "${song:0:$((maxlength - 3))}..."
        else
            echo "$song"
        fi
    else
        echo ""
    fi
else
    echo ""
fi

