#!/usr/bin/env bash
# Play frames/ once beside the modules in config.jsonc.
# Usage: fastfetch-anim.sh [frame-delay-seconds]
# Any key skips the rest of the animation and leaves the current frame up.

delay="${1:-0.05}"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
frames_dir="$dir/frames"
logo_width=35
gap=4
text_col=$((logo_width + gap))

if [[ ! -t 1 ]]; then
  exec fastfetch --config "$dir/config.jsonc"
fi

shopt -s nullglob
frames=("$frames_dir"/frame*.txt)
if ((${#frames[@]} == 0)); then
  exec fastfetch --config "$dir/config.jsonc"
fi

cols=$(tput cols 2>/dev/null || echo 0)
if (( cols > 0 && cols < text_col + 24 )); then
  exec fastfetch --config "$dir/config.jsonc"
fi

mapfile -t info < <(fastfetch --logo none --config "$dir/config.jsonc" --pipe false)
filtered=()
for line in "${info[@]}"; do
  [[ -n "$line" ]] && filtered+=("$line")
done
info=("${filtered[@]}")

frame_height=$(wc -l < "${frames[0]}")
info_count=${#info[@]}
if (( info_count >= frame_height )); then
  info_offset=0
else
  info_offset=$(( (frame_height - info_count) / 2 ))
fi

reset=$'\e[0m'
cursor_in_block=0

cleanup() {
  if ((cursor_in_block)); then
    tput cud "$frame_height" 2>/dev/null || true
    cursor_in_block=0
  fi
  printf '%s' "$reset"
  tput cnorm 2>/dev/null || true
}
trap cleanup EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

tput civis
printf '\n%.0s' $(seq 1 "$frame_height")
tput cuu "$frame_height"
cursor_in_block=1

draw() {
  local frame="$1"
  local -a lines=()
  local i line
  mapfile -t lines < "$frame"
  for ((i = 0; i < frame_height; i++)); do
    line="${lines[i]:-}"
    # Source frames are clipped mid-sequence; drop a dangling escape so it
    # is not printed as literal "[0m" beside the info.
    if [[ "$line" != *m ]]; then
      line="${line%$'\e'*}"
    fi
    printf '%s%s' "$line" "$reset"
    tput hpa "$text_col"
    if (( i >= info_offset && i < info_offset + info_count )); then
      printf '%s%s' "${info[i - info_offset]}" "$reset"
    fi
    tput el
    printf '\n'
  done
}

for frame in "${frames[@]}"; do
  draw "$frame"
  tput cuu "$frame_height"
  if IFS= read -r -s -t "$delay" -n 1; then
    break
  fi
done
