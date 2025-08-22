#!/usr/bin/env bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# MATRIX - A simple, FAST matrix-style screensaver
#
# This version is optimized for speed by:
# 1. Using direct ANSI escape codes instead of forking `tput` for every update.
# 2. Building a "frame buffer" string with all screen changes for a frame.
# 3. Printing the entire frame buffer with a single `printf` call.
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Color palette for the "dark -> bright -> dark" cycle.
PALETTE=(
    $'\e[38;5;22m'  # Darkest
    $'\e[38;5;28m'
    $'\e[38;5;34m'
    $'\e[38;5;40m'
    $'\e[38;5;46m'  # Brightest
    $'\e[38;5;40m'
    $'\e[38;5;34m'
    $'\e[38;5;28m'
)
RESET=$'\e[0m'

# The characters to display
CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"

# The maximum length of the character streams
MAX_STREAM_LEN=15
# Animation speed (lower is faster)
DELAY=0.04

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  tput sgr0        # reset all attributes
  echo
  exit 0
}

trap _cleanup_and_exit SIGINT # Catch Ctrl‑C

#
# Main animation loop (Optimized)
#
animate() {
    tput setab 0 # black background
    clear
    tput civis # Hide cursor

    # Get terminal dimensions
    local width
    width=$(tput cols)
    local height
    height=$(tput lines)

    # Initialize column arrays
    local -a heads           # y-position of the head of the stream
    local -a stream_lengths  # length of the stream
    local -a active_cols     # 1 if column is active, 0 if not

    for ((i=0; i<width; i++)); do
        active_cols[$i]=0
    done

    # Main loop
    while true; do
        # This string will hold all the updates for the current frame
        local frame_buffer=""

        for ((i=0; i<width; i++)); do
            # If a column is inactive, randomly decide to activate it
            if [ ${active_cols[$i]} -eq 0 ]; then
                if [ $((RANDOM % 100)) -lt 5 ]; then
                    active_cols[$i]=1
                    heads[$i]=1 # Start at row 1
                    # Give each new stream a random length
                    stream_lengths[$i]=$((MAX_STREAM_LEN / 2 + RANDOM % MAX_STREAM_LEN))
                fi
                continue # Skip to the next column if it's not active
            fi

            local y_head=${heads[$i]}
            local stream_len=${stream_lengths[$i]}

            # --- Draw the full stream with the color cycle gradient ---
            # NOTE: This is less performant than the previous version as it redraws
            # the entire stream in every frame, but it matches the requested effect.
            for ((j=0; j < stream_len; j++)); do
                local y=$((y_head - j))
                if [ $y -lt 1 ]; then break; fi

                local color_index=$((j % ${#PALETTE[@]}))
                local color=${PALETTE[$color_index]}
                local rand_char=${CHARS:$((RANDOM % ${#CHARS})):1}
                frame_buffer+="\e[${y};$((i + 1))H${color}${rand_char}"
            done

            # --- Erase the stream tail ---
            local y_tail=$((y_head - stream_len))
            if [ $y_tail -ge 1 ]; then
                frame_buffer+="\e[${y_tail};$((i + 1))H "
            fi

            # --- Update stream position for the next frame ---
            heads[$i]=$((y_head + 1))

            # If the tail has gone off-screen, deactivate the column so it can restart
            if [ $y_tail -ge $height ]; then
                active_cols[$i]=0
            fi
        done

        # Print the entire frame at once. `printf %b` interprets the escape codes.
        printf '%b' "$frame_buffer"
        sleep $DELAY
    done
}

# --- Let's get this digital rain started ---
animate
