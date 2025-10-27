#!/usr/bin/env bash
bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

i=0
while [ $i -lt ${#bar} ]; do
    dict="${dict}s/$i/${bar:$i:1} /g;"
    i=$((i + 1))
done
dict="${dict}s/ $//;"

bars=8
config_file="/tmp/polybar_cava_config_$$"

cat > "$config_file" <<EOF
[general]
bars = $bars

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

cleanup() {
    rm -f "$config_file"
}
trap cleanup EXIT

killall cava
cava -p "$config_file" | while read -r line; do
    echo "$line" | sed "$dict"
done

