#!/usr/bin/env bash
#
# alpha screensaver (optimized for speed)
#

SLEEPY_TIME="0.7" # Number of seconds of sleepy time between alpha-ness

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  tput sgr0
  echo
  exit 0
}

trap _cleanup_and_exit SIGINT # Ctrl‑C

# Get terminal dimensions
width=$(tput cols)
height=$(tput lines)

tput setab 0 # black background
clear
tput civis # no cursor

while true; do
  # Get random location and color
  x=$((RANDOM % width + 1))
  y=$((RANDOM % height + 1))
  color_code=$((RANDOM % 256))

  # Build the string to print
  frame_buffer="\e[${y};${x}H\e[38;5;${color_code}m█"

  # Print the frame
  printf '%b' "$frame_buffer"

  sleep "$SLEEPY_TIME"
done
