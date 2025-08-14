#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# RAIN - A simple, faster rain-style screensaver
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Set the colors
BLUE=$'\e[34m'
RESET=$'\e[0m'

# The characters for the raindrops
DROPS=("┃" "│" "|")
# Animation speed (lower is faster)
DELAY=0.03

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  tput sgr0
  echo
  exit 0
}

trap _cleanup_and_exit SIGINT # Ctrl‑C

#
# Main animation loop (Optimized)
#
animate() {
    tput setab 0 # black background
    clear
    tput civis # Hide cursor

    # Get terminal dimensions
    local width=$(tput cols)
    local height=$(tput lines)

    # Initialize drops array
    local -a drops_x
    local -a drops_y

    while true; do
        # Create a new drop
        if [ $((RANDOM % 2)) -eq 0 ]; then
            drops_x+=($((RANDOM % width)))
            drops_y+=(0)
        fi

        local frame_buffer=""
        local next_drops_x=()
        local next_drops_y=()

        # Move and draw drops
        for i in "${!drops_x[@]}"; do
            # Add clear old position to frame buffer
            frame_buffer+="\e[$((${drops_y[$i]} + 1));$((${drops_x[$i]} + 1))H "

            # Move the drop down
            local new_y=$((${drops_y[$i]} + 1))

            # If the drop is still on screen, draw it and keep it for the next frame
            if [ $new_y -lt $height ]; then
                local rand_drop=${DROPS[$((RANDOM % ${#DROPS[@]}))]}
                # Add new position to frame buffer
                frame_buffer+="\e[$((new_y + 1));$((${drops_x[$i]} + 1))H${BLUE}${rand_drop}"
                next_drops_x+=(${drops_x[$i]})
                next_drops_y+=($new_y)
            fi
        done

        # Print the frame
        printf '%b' "$frame_buffer"

        # Update the drops array for the next frame
        drops_x=("${next_drops_x[@]}")
        drops_y=("${next_drops_y[@]}")

        sleep $DELAY
    done
}

# --- Let the rain fall ---
animate
