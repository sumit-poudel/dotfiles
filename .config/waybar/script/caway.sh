#!/usr/bin/env bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# Build sed dictionary
i=0
while [ $i -lt ${#bar} ]; do
    dict="${dict}s/$i/${bar:$i:1} /g;"
    i=$((i + 1))
done
dict="${dict}s/ $//;"

bars=8
config_file="/tmp/polybar_cava_config_$$"  # Unique per run

# Create config
cat > "$config_file" <<EOF
[general]
bars = $bars

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Cleanup on exit
cleanup() {
    rm -f "$config_file"
    pkill -P $$ cava 2>/dev/null  # Kill child cava if still alive
}
trap cleanup EXIT

# Run cava and output bars
cava -p "$config_file" | while read -r line; do
    echo "$line" | sed "$dict"
done

