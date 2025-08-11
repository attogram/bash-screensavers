#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# MATRIX - A simple matrix-style screensaver
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Set the colors
GREEN="\e[32m"
BLACK="\e[40m"
RESET="\e[0m"

# The characters to display
CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"

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
    echo -e "${GREEN}${BLACK}"

    # Get terminal dimensions
    local width=$(tput cols)
    local height=$(tput lines)

    # Initialize columns
    local columns=()
    for ((i=0; i<width; i++)); do
        columns[$i]=0
    done

    # Trap Ctrl+C to exit gracefully
    trap cleanup SIGINT

    while true; do
        for ((i=0; i<width; i++)); do
            if [ ${columns[$i]} -eq 0 ]; then
                if [ $((RANDOM % 100)) -lt 5 ]; then
                    columns[$i]=1
                fi
            fi

            if [ ${columns[$i]} -ne 0 ]; then
                # Print a random character
                local rand_char=${CHARS:$((RANDOM % ${#CHARS})):1}
                tput cup ${columns[$i]} $i
                echo -e "$rand_char"

                # Move the column down
                columns[$i]=$((${columns[$i]} + 1))
                if [ ${columns[$i]} -ge $height ]; then
                    columns[$i]=0
                fi
            fi
        done
        sleep 0.05
    done
}

# --- Let's get this digital rain started ---
animate
