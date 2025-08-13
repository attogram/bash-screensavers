#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# STARS - A simple starfield screensaver (optimized for speed)
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Set the colors
WHITE=$'\e[97m'
YELLOW=$'\e[93m'
DELAY=0.02

# The characters for the stars
STARS=("*" "." "+")

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

    # Get terminal dimensions
    local width=$(tput cols)
    local height=$(tput lines)

    while true; do
        local frame_buffer=""

        # Add a new star
        local x=$((RANDOM % width + 1))
        local y=$((RANDOM % height + 1))

        # Choose a random star character and color
        local rand_star=${STARS[$((RANDOM % ${#STARS[@]}))]}
        local star_color=$WHITE
        if [ $((RANDOM % 5)) -eq 0 ]; then
            star_color=$YELLOW
        fi
        frame_buffer+="\e[${y};${x}H${star_color}${rand_star}"

        # Occasionally clear a random spot to make stars twinkle
        if [ $((RANDOM % 3)) -eq 0 ]; then
            local clear_x=$((RANDOM % width + 1))
            local clear_y=$((RANDOM % height + 1))
            frame_buffer+="\e[${clear_y};${clear_x}H "
        fi

        printf '%b' "$frame_buffer"
        sleep $DELAY
    done
}

# --- Let's gaze at the stars ---
animate
