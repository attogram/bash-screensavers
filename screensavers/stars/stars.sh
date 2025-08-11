#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# STARS - A simple starfield screensaver
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Set the colors
WHITE="\e[97m"
YELLOW="\e[93m"
BLACK="\e[40m"
RESET="\e[0m"

# The characters for the stars
STARS=("*" "." "+")

# --- Functions ---

#
# Cleanup function to restore the terminal
#
cleanup() {
    echo -e "$RESET"
    tput cnorm # Restore cursor
    clear
    exit 0
}

#
# Main animation loop
#
animate() {
    clear
    tput civis # Hide cursor
    echo -e "${BLACK}"

    # Get terminal dimensions
    local width=$(tput cols)
    local height=$(tput lines)

    # Trap Ctrl+C to exit gracefully
    trap cleanup SIGINT

    while true; do
        # Add a new star
        local x=$((RANDOM % width))
        local y=$((RANDOM % height))
        tput cup $y $x

        # Choose a random star character and color
        local rand_star=${STARS[$((RANDOM % ${#STARS[@]}))]}
        if [ $((RANDOM % 5)) -eq 0 ]; then
            echo -e "${YELLOW}$rand_star"
        else
            echo -e "${WHITE}$rand_star"
        fi

        # Occasionally clear a random spot to make stars twinkle
        if [ $((RANDOM % 3)) -eq 0 ]; then
            local clear_x=$((RANDOM % width))
            local clear_y=$((RANDOM % height))
            tput cup $clear_y $clear_x
            echo " "
        fi

        sleep 0.02
    done
}

# --- Let's gaze at the stars ---
animate
