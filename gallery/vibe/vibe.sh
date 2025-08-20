#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# VIBE - a simulation of vibe coding
#
# Based on the MATRIX screensaver.
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Color palette for the "dark -> bright -> dark" cycle.
PALETTE=(
    $'\e[38;5;22m'   # Dark Green
    $'\e[38;5;28m'
    $'\e[38;5;34m'
    $'\e[38;5;40m'
    $'\e[38;5;46m'   # Bright Green
    $'\e[38;5;82m'
    $'\e[38;5;118m'
    $'\e[38;5;45m'   # Bright Blue
    $'\e[38;5;39m'
    $'\e[38;5;33m'
    $'\e[38;5;27m'
    $'\e[38;5;21m'   # Dark Blue
    $'\e[38;5;52m'   # Dark Purple
    $'\e[38;5;93m'
    $'\e[38;5;129m'
  $'\e[38;5;165m' # Bright Purple
)
RESET=$'\e[0m'

# The characters to display
CONTENT=(
    "npm install --save-dev left-pad"
    "git commit -m 'fix: off-by-one error'"
    "console.log('Hello, world!');"
    "[INFO] Compiling module..."
    "Segmentation fault (core dumped)"
    "Error: Cannot find module 'react'"
    "0xDEADBEEF"
    "while (true) { ... }"
    "// TODO: fix this later"
    "It's not a bug, it's a feature."
    "Have you tried turning it off and on again?"
    "rm -rf / --no-preserve-root"
    "sudo make me a sandwich"
    "E_FATAL: Core meltdown in progress."
    "Tuning flux capacitor..."
    "Reticulating splines..."
)

GLITCHES=(
"
   _  _
  ( \/ )
   \  /
    )(
   (__)
"
"
  ____
 (____)
 (____)
 (____)
"
"SYNTAX ERROR"
"DECOMPILING..."
)


# The maximum length of the character streams
MAX_STREAM_LEN=20
# Animation speed (lower is faster)
DELAY=0.04

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  tput sgr0        # reset all attributes
  clear
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
    local -a stream_content

    for ((i=0; i<width; i++)); do
        active_cols[$i]=0
    done

    # Main loop
    while true; do
        # This string will hold all the updates for the current frame
        local frame_buffer=""

        # Occasionally show a glitch
        if [ $((RANDOM % 200)) -lt 1 ]; then
            local glitch_content=${GLITCHES[$((RANDOM % ${#GLITCHES[@]}))]}
            local glitch_x=$((RANDOM % (width - ${#glitch_content})))
            local glitch_y=$((RANDOM % height))
            frame_buffer+="\e[${glitch_y};${glitch_x}H\e[38;5;231m\e[48;5;52m${glitch_content}${RESET}"
        fi


        for ((i=0; i<width; i++)); do
            # If a column is inactive, randomly decide to activate it
            if [ ${active_cols[$i]} -eq 0 ]; then
                if [ $((RANDOM % 100)) -lt 5 ]; then
                    active_cols[$i]=1
                    heads[$i]=1 # Start at row 1
                    stream_lengths[$i]=$((MAX_STREAM_LEN / 2 + RANDOM % MAX_STREAM_LEN))
                    stream_content[$i]=${CONTENT[$((RANDOM % ${#CONTENT[@]}))]}
                fi
                continue # Skip to the next column if it's not active
            fi

            local y_head=${heads[$i]}
            local stream_len=${stream_lengths[$i]}
            local content=${stream_content[$i]}
            local content_len=${#content}

            # --- Draw the full stream with the color cycle gradient ---
            for ((j=0; j < stream_len; j++)); do
                local y=$((y_head - j))
                if [ $y -lt 1 ]; then break; fi

                local color_index=$((j % ${#PALETTE[@]}))
                local color=${PALETTE[$color_index]}
                local char_index=$(( (y_head - y) % content_len ))
                local char=${content:$char_index:1}
                frame_buffer+="\e[${y};$((i + 1))H${color}${char}"
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

        # Vary the speed slightly
        local random_delay
        random_delay=$(printf "0.0%d" $((RANDOM % 3 + 2)) )
        sleep $random_delay
    done
}

# --- Let's get this digital rain started ---
animate
