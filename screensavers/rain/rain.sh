#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# RAIN - A simple rain-style screensaver
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Set the colors
BLUE="\e[34m"
BLACK="\e[40m"
RESET="\e[0m"

# The characters for the raindrops
DROPS=("|" "." "'")

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
    echo -e "${BLUE}${BLACK}"

    # Get terminal dimensions
    local width=$(tput cols)
    local height=$(tput lines)

    # Initialize drops
    local drops_x=()
    local drops_y=()

    # Trap Ctrl+C to exit gracefully
    trap cleanup SIGINT

    while true; do
        # Create a new drop
        if [ $((RANDOM % 2)) -eq 0 ]; then
            drops_x+=($((RANDOM % width)))
            drops_y+=(0)
        fi

        # Move and draw drops
        for i in "${!drops_x[@]}"; do
            # Clear the old position
            tput cup ${drops_y[$i]} ${drops_x[$i]}
            echo " "

            # Move the drop down
            drops_y[$i]=$((${drops_y[$i]} + 1))

            # If the drop is still on screen, draw it
            if [ ${drops_y[$i]} -lt $height ]; then
                tput cup ${drops_y[$i]} ${drops_x[$i]}
                local rand_drop=${DROPS[$((RANDOM % ${#DROPS[@]}))]}
                echo -e "$rand_drop"
            else
                # Remove drops that have fallen off the screen
                unset drops_x[$i]
                unset drops_y[$i]
            fi
        done

        sleep 0.05
    done
}

# --- Let the rain fall ---
animate
