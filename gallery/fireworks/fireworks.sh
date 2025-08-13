#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# FIREWORKS - A simple fireworks display (optimized for speed)
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
COLORS=($'\e[31m' $'\e[32m' $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m' $'\e[91m' $'\e[92m' $'\e[93m' $'\e[94m' $'\e[95m' $'\e[96m')
ROCKET_CHARS=("." "^" "+")
EXPLOSION_CHARS=("*" "+" ".")
DELAY_ROCKET=0.01
DELAY_EXPLOSION=0.05
DELAY_BETWEEN=0.5

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  tput sgr0
  clear
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

    local width=$(tput cols)
    local height=$(tput lines)

    while true; do
        # --- Rocket Launch ---
        local rocket_x=$((RANDOM % width))
        local rocket_y=$((height - 1))
        local peak_y=$((RANDOM % (height / 2)))
        local rocket_color=${COLORS[$((RANDOM % ${#COLORS[@]}))]}
        local rocket_char=${ROCKET_CHARS[$((RANDOM % ${#ROCKET_CHARS[@]}))]}

        # Draw rocket ascending
        for ((y=rocket_y; y > peak_y; y--)); do
            local frame_buffer="\e[$((y + 1));$((rocket_x + 1))H${rocket_color}${rocket_char}"
            printf '%b' "$frame_buffer"
            sleep $DELAY_ROCKET
            frame_buffer="\e[$((y + 1));$((rocket_x + 1))H "
            printf '%b' "$frame_buffer"
        done

        # --- Explosion ---
        local explosion_color=${COLORS[$((RANDOM % ${#COLORS[@]}))]}
        local explosion_char=${EXPLOSION_CHARS[$((RANDOM % ${#EXPLOSION_CHARS[@]}))]}
        local explosion_radius=$(( (RANDOM % 5) + 3 )) # Radius of 3 to 7

        # Expanding explosion
        for ((r=1; r <= explosion_radius; r++)); do
            local frame_buffer=""
            for ((i=0; i<r; i++)); do
                y1=$((peak_y - r + i)); x1=$((rocket_x + i))
                y2=$((peak_y + i)); x2=$((rocket_x + r - i))
                y3=$((peak_y + r - i)); x3=$((rocket_x - i))
                y4=$((peak_y - i)); x4=$((rocket_x - r + i))

                if (( y1 >= 0 && y1 < height && x1 >= 0 && x1 < width )); then frame_buffer+="\e[$((y1 + 1));$((x1 + 1))H${explosion_color}${explosion_char}"; fi
                if (( y2 >= 0 && y2 < height && x2 >= 0 && x2 < width )); then frame_buffer+="\e[$((y2 + 1));$((x2 + 1))H${explosion_color}${explosion_char}"; fi
                if (( y3 >= 0 && y3 < height && x3 >= 0 && x3 < width )); then frame_buffer+="\e[$((y3 + 1));$((x3 + 1))H${explosion_color}${explosion_char}"; fi
                if (( y4 >= 0 && y4 < height && x4 >= 0 && x4 < width )); then frame_buffer+="\e[$((y4 + 1));$((x4 + 1))H${explosion_color}${explosion_char}"; fi
            done
            printf '%b' "$frame_buffer"
            sleep $DELAY_EXPLOSION
        done

        # Clear the explosion
        local frame_buffer=""
        for ((r=1; r <= explosion_radius; r++)); do
            for ((i=0; i<r; i++)); do
                y1=$((peak_y - r + i)); x1=$((rocket_x + i))
                y2=$((peak_y + i)); x2=$((rocket_x + r - i))
                y3=$((peak_y + r - i)); x3=$((rocket_x - i))
                y4=$((peak_y - i)); x4=$((rocket_x - r + i))

                if (( y1 >= 0 && y1 < height && x1 >= 0 && x1 < width )); then frame_buffer+="\e[$((y1 + 1));$((x1 + 1))H "; fi
                if (( y2 >= 0 && y2 < height && x2 >= 0 && x2 < width )); then frame_buffer+="\e[$((y2 + 1));$((x2 + 1))H "; fi
                if (( y3 >= 0 && y3 < height && x3 >= 0 && x3 < width )); then frame_buffer+="\e[$((y3 + 1));$((x3 + 1))H "; fi
                if (( y4 >= 0 && y4 < height && x4 >= 0 && x4 < width )); then frame_buffer+="\e[$((y4 + 1));$((x4 + 1))H "; fi
            done
        done
        printf '%b' "$frame_buffer"

        sleep $DELAY_BETWEEN # Wait a moment before the next firework
    done
}

# --- Let the show begin ---
animate
