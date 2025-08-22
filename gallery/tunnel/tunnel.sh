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
    local max_radius=$(( (height > width ? height : width) / 2 + 1 ))

    while true; do
        for ((r=1; r < max_radius; r++)); do
            local frame_buffer=""
            local color=${COLORS[$((r % ${#COLORS[@]}))]}
            local char=${CHARS[$((r % ${#CHARS[@]}))]}

            # Erase the previous shape
            if [ $r -gt 1 ]; then
                local prev_r=$((r-1))
                for ((i=0; i < prev_r; i++)); do
                    x1=$((center_x + i)); y1=$((center_y - prev_r + i))
                    x2=$((center_x + prev_r - i)); y2=$((center_y + i))
                    x3=$((center_x - i)); y3=$((center_y + prev_r - i))
                    x4=$((center_x - prev_r + i)); y4=$((center_y - i))
                    if (( y1 >= 0 && y1 < height && x1 >= 0 && x1 < width )); then frame_buffer+="\e[$((y1 + 1));$((x1 + 1))H "; fi
                    if (( y2 >= 0 && y2 < height && x2 >= 0 && x2 < width )); then frame_buffer+="\e[$((y2 + 1));$((x2 + 1))H "; fi
                    if (( y3 >= 0 && y3 < height && x3 >= 0 && x3 < width )); then frame_buffer+="\e[$((y3 + 1));$((x3 + 1))H "; fi
                    if (( y4 >= 0 && y4 < height && x4 >= 0 && x4 < width )); then frame_buffer+="\e[$((y4 + 1));$((x4 + 1))H "; fi
                done
            fi

            # Draw a square/diamond shape
            for ((i=0; i < r; i++)); do
                x1=$((center_x + i)); y1=$((center_y - r + i))
                x2=$((center_x + r - i)); y2=$((center_y + i))
                x3=$((center_x - i)); y3=$((center_y + r - i))
                x4=$((center_x - r + i)); y4=$((center_y - i))
                if (( y1 >= 0 && y1 < height && x1 >= 0 && x1 < width )); then frame_buffer+="\e[$((y1 + 1));$((x1 + 1))H${color}${char}"; fi
                if (( y2 >= 0 && y2 < height && x2 >= 0 && x2 < width )); then frame_buffer+="\e[$((y2 + 1));$((x2 + 1))H${color}${char}"; fi
                if (( y3 >= 0 && y3 < height && x3 >= 0 && x3 < width )); then frame_buffer+="\e[$((y3 + 1));$((x3 + 1))H${color}${char}"; fi
                if (( y4 >= 0 && y4 < height && x4 >= 0 && x4 < width )); then frame_buffer+="\e[$((y4 + 1));$((x4 + 1))H${color}${char}"; fi
            done

            printf '%b' "$frame_buffer"
            sleep $DELAY
        done
        # Clear the center after a full cycle
        printf "\e[$((center_y + 1));$((center_x + 1))H "
    done
}

# --- Let's fly through the tunnel ---
animate
