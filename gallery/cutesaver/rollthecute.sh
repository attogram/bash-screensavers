#!/bin/bash

# This file reads from 12 art files and then loops.
# Each is displayed for 10 seconds.

trap cleanup SIGINT # Trap CONTROL-C

# --- Functions ---

#
# Cleanup function to restore the terminal
#
cleanup() {
    tput cnorm # Restore cursor
    printf '\e[0m'
    printf '\n'
    exit 0
}

#
# Main animation loop
#
animate() {
    tput civis # Hide cursor

    # List of art files to display
    local art_files=(
        "./art/1.art" "./art/2.art" "./art/3.art" "./art/4.art"
        "./art/5.art" "./art/6.art" "./art/7.art" "./art/8.art"
        "./art/9.art" "./art/10.art" "./art/11.art" "./art/12.art"
    )

    while true; do
        for art_file in "${art_files[@]}"; do
            clear
            if [ -f "$art_file" ]; then
                # Using cat is simpler than a while loop for this
                cat "$art_file"
            else
                # In case an art file is missing, show a message
                tput cup 5 5
                echo "Art file not found: $art_file"
            fi
            sleep 10
        done
    done
}

# --- Let the cuteness roll ---
# Change directory to the script's location to find the art files
cd "$( dirname "${BASH_SOURCE[0]}" )"
animate