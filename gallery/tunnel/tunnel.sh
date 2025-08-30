#!/usr/bin/env bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# TUNNEL - A digital tunnel/hyperspace effect (optimized for speed)
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
CHARS=("." "o" "O" "*" "0")
COLORS=($'\e[31m' $'\e[32m' $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m')
DELAY=0.02

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  tput sgr0
  echo
  exit 0
}

trap _cleanup_and_exit SIGINT # Ctrl‑C

#
# Main animation loop
#
animate() {
    tput setab 0 # black background
    clear
    tput civis # Hide cursor

    local width
    width=$(tput cols)
    local height
    height=$(tput lines)
    local center_x=$((width / 2))
    local center_y=$((height / 2))
    local max_radius=$(( (height > width ? height : width) / 2 + 2 ))
    local ribbon_spacing=7
    local -a radii=()
    local frame_counter=0

    while true; do
        local frame_buffer=""
        # Add a new ribbon every few frames
        if (( frame_counter % ribbon_spacing == 0 )); then
            radii+=(1)
        fi

        local -a next_radii=()
        for r in "${radii[@]}"; do
            if [ $r -gt 0 ]; then
                local prev_r=$((r-1))
                # Erase the previous shape
                for ((i=0; i < prev_r; i++)); do
                    x1=$((center_x + i)); y1=$((center_y - prev_r + i))
                    x2=$((center_x + prev_r - i)); y2=$((center_y + i))
                    x3=$((center_x - i)); y3=$((center_y + prev_r - i))
                    x4=$((center_x - prev_r + i)); y4=$((center_y - i))
                    frame_buffer+="\e[$((y1 + 1));$((x1 + 1))H "
                    frame_buffer+="\e[$((y2 + 1));$((x2 + 1))H "
                    frame_buffer+="\e[$((y3 + 1));$((x3 + 1))H "
                    frame_buffer+="\e[$((y4 + 1));$((x4 + 1))H "
                done
            fi

            local color=${COLORS[$((r % ${#COLORS[@]}))]}
            local char=${CHARS[$((r % ${#CHARS[@]}))]}
            # Draw a square/diamond shape
            for ((i=0; i < r; i++)); do
                x1=$((center_x + i)); y1=$((center_y - r + i))
                x2=$((center_x + r - i)); y2=$((center_y + i))
                x3=$((center_x - i)); y3=$((center_y + r - i))
                x4=$((center_x - r + i)); y4=$((center_y - i))
                frame_buffer+="\e[$((y1 + 1));$((x1 + 1))H${color}${char}"
                frame_buffer+="\e[$((y2 + 1));$((x2 + 1))H${color}${char}"
                frame_buffer+="\e[$((y3 + 1));$((x3 + 1))H${color}${char}"
                frame_buffer+="\e[$((y4 + 1));$((x4 + 1))H${color}${char}"
            done

            # Increment radius for the next frame, and keep it if it's not too large
            local next_r=$((r + 1))
            if (( next_r < max_radius )); then
                next_radii+=($next_r)
            fi
        done

        radii=("${next_radii[@]}")
        printf '%b' "$frame_buffer"
        sleep $DELAY
        ((frame_counter++))
    done
}

# --- Let's fly through the tunnel ---
animate
