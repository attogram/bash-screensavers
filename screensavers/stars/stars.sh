#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# STARS - A simple starfield screensaver
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

trap cleanup SIGINT # Trap CONTROL-C

# --- Configuration ---
# Set the colors
WHITE='\e[97m'
YELLOW='\e[93m'
BLACK='\e[40m'
RESET='\e[0m'

# The characters for the stars
STARS=("*" "." "+")

# --- Functions ---

#
# Cleanup function to restore the terminal
#
cleanup() {
    printf '%s' "$RESET"
    tput cnorm # Restore cursor
    echo
    exit 0
}

#
# Main animation loop
#
animate() {
    clear
    tput civis # Hide cursor
    printf '%s' "${BLACK}"

    # Get terminal dimensions
    local width=$(tput cols)
    local height=$(tput lines)

    while true; do
        # Add a new star
        local x=$((RANDOM % width))
        local y=$((RANDOM % height))
        tput cup $y $x

        # Choose a random star character and color
        local rand_star=${STARS[$((RANDOM % ${#STARS[@]}))]}
        if [ $((RANDOM % 5)) -eq 0 ]; then
            printf '%s%s' "${YELLOW}" "$rand_star"
        else
            printf '%s%s' "${WHITE}" "$rand_star"
        fi

        # Occasionally clear a random spot to make stars twinkle
        if [ $((RANDOM % 3)) -eq 0 ]; then
            local clear_x=$((RANDOM % width))
            local clear_y=$((RANDOM % height))
            tput cup $clear_y $clear_x
            printf " "
        fi

        sleep 0.02
    done
}

# --- Let's gaze at the stars ---
animate
