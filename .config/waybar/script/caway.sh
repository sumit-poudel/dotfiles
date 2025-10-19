#!/usr/bin/bash

# Nuke all internal spawns when script dies
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM

BARS=8
FRAMERATE=60
EQUILIZER=1

# Get script options
while getopts 'b:f:m:eh' flag; do
    case "${flag}" in
        b) BARS="${OPTARG}" ;;
        f) FRAMERATE="${OPTARG}" ;;
        e) EQUILIZER=0 ;;
        h)
            echo "caway usage: caway [ options ... ]"
            echo "where options include:"
            echo
            echo "  -b <integer>  (Number of bars to display. Default 8)"
            echo "  -f <integer>  (Framerate of the equalizer. Default 60)"
            echo "  -e            (Disable equalizer. Default enabled)"
            echo "  -h            (Show help message)"
            exit 0
            ;;
    esac
done

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar + thin space " "
i=0
while [ $i -lt ${#bar} ]; do
    dict="${dict}s/$i/${bar:$i:1} /g;"
    i=$((i+1))
done

# Remove last extra thin space
dict="${dict}s/.$//;"

clean_create_pipe() {
    if [ -p "$1" ]; then
        unlink "$1"
    fi
    mkfifo "$1"
}

kill_pid_file() {
    if [[ -f "$1" ]]; then
        while read -r pid; do
            { kill "$pid" && wait "$pid"; } 2>/dev/null
        done < "$1"
    fi
}

cava_waybar_pid="/tmp/cava_waybar_pid"
cava_waybar_pipe="/tmp/cava_waybar.fifo"
clean_create_pipe "$cava_waybar_pipe"

cava_waybar_config="/tmp/cava_waybar_config"
echo "
[general]
mode = normal
framerate = $FRAMERATE
bars = $BARS

[output]
method = raw
raw_target = $cava_waybar_pipe
data_format = ascii
ascii_max_range = 7
" > "$cava_waybar_config"

playerctl_waybar_pipe="/tmp/playerctl_waybar.fifo"
clean_create_pipe "$playerctl_waybar_pipe"

# playerctl output (monitors players)
playerctl -a metadata --format '{"text": "{{artist}} - {{title}}", "tooltip": "{{playerName}} : {{markup_escape(artist)}} - {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F 2>/dev/null > "$playerctl_waybar_pipe" &

# Read playerctl output
while read -r line; do
    kill_pid_file "$cava_waybar_pid"

    # Check if line is empty (no player running)
    if [[ -z "$line" || "$line" == "null" ]]; then
        continue  # Output nothing → Waybar hides module
    fi

    player_status=$(echo "$line" | jq -r '.class')

    if [[ "$player_status" == "Playing" && $EQUILIZER == 1 ]]; then
        # Wait briefly before starting visualizer
        sleep 1

        cava -p "$cava_waybar_config" > "$cava_waybar_pipe" &

        echo $! > "$cava_waybar_pid"

        while read -r visual_line; do
            bars=$(echo "$visual_line" | sed "$dict")
            echo "$line" | jq --arg a "$bars" '.text = $a' --unbuffered --compact-output
        done < "$cava_waybar_pipe" &

        echo $! >> "$cava_waybar_pid"

    else
        # Show flat bars when paused/stopped
        echo '{"text": "▁ ▁ ▁ ▁ ▁ ▁ ▁ ▁", "tooltip": "Paused", "alt": "Paused", "class": "Paused"}'
    fi
done < "$playerctl_waybar_pipe"

