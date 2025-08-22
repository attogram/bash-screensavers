#!/usr/bin/env bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# STARS - A simple starfield screensaver (optimized for speed)
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
# Set the colors
C_WHITE=$'\e[97m'
C_YELLOW=$'\e[93m'
C_BLUE=$'\e[94m'
C_CYAN=$'\e[96m'
COLORS=("$C_WHITE" "$C_YELLOW" "$C_BLUE" "$C_CYAN")
DELAY=0.02

# The characters for the stars
STARS=("*" "." "+" "'" "O")

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  tput sgr0
  echo
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
    local width
    width=$(tput cols)
    local height
    height=$(tput lines)

    while true; do
        local frame_buffer=""

        # Add a few new stars
        for i in {1..3}; do
            local x=$((RANDOM % width + 1))
            local y=$((RANDOM % height + 1))
            local rand_star=${STARS[$((RANDOM % ${#STARS[@]}))]}
            local rand_color=${COLORS[$((RANDOM % ${#COLORS[@]}))]}
            frame_buffer+="\e[${y};${x}H${rand_color}${rand_star}"
        done

        # Clear a few random spots to make stars twinkle and prevent over-filling
        for i in {1..2}; do
            local clear_x=$((RANDOM % width + 1))
            local clear_y=$((RANDOM % height + 1))
            frame_buffer+="\e[${clear_y};${clear_x}H "
        done

        printf '%b' "$frame_buffer"
        sleep $DELAY
    done
}

# --- Let's gaze at the stars ---
animate
