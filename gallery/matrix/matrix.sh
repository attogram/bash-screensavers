#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# MATRIX - A simple matrix-style screensaver
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Set the colors
GREEN=$'\e[32m'
BLACK=$'\e[40m'
RESET=$'\e[0m'

# The characters to display
CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"

# The length of the character streams
STREAM_LEN=15

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  printf '\e[0m\n' # reset colours and move to a new line
  exit 1           # exit with error, so main menu knows what happened!
}

trap _cleanup_and_exit SIGINT # Ctrl‑C

#
# Main animation loop
#
animate() {
    clear
    tput civis # Hide cursor
    printf '%s%s' "${GREEN}" "${BLACK}"

    # Get terminal dimensions
    local width=$(tput cols)
    local height=$(tput lines)

    # Initialize columns
    local columns=()
    for ((i=0; i<width; i++)); do
        columns[$i]=0
    done

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
                printf '%s%s' "${GREEN}" "$rand_char"

                # Erase the tail of the stream
                local tail_y=$((${columns[$i]} - STREAM_LEN))
                if [ $tail_y -ge 0 ]; then
                    tput cup $tail_y $i
                    printf ' '
                fi

                # Move the column down
                columns[$i]=$((${columns[$i]} + 1))
                if [ ${columns[$i]} -ge $height ]; then
                    columns[$i]=0
                    # Clear the rest of the tail when the stream resets
                    for ((j=1; j<STREAM_LEN; j++)); do
                        local y_to_clear=$(($height + $j - STREAM_LEN))
                        if [ $y_to_clear -ge 0 ]; then
                            tput cup $y_to_clear $i
                            printf ' '
                        fi
                    done
                fi
            fi
        done
        sleep 0.05
    done
}

# --- Let's get this digital rain started ---
animate
