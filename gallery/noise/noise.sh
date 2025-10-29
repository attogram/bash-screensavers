#!/usr/bin/env bash
# Replicate old-school CRT static noise

# Handler for SIGINT (Ctrl‑C)
_handle_cleanup_and_exit() {
  # show the cursor again
  tput cnorm       
  tput sgr0
  echo
  clear
  exit 0
}

# Handler for SIGWINCH (window resize)
_handle_window_resize() {
  width="$(tput cols)"
  height="$(tput lines)"
  clear
}

# Capture Ctrl‑C
trap _handle_cleanup_and_exit SIGINT 
# Capture SIGWINCH
trap _handle_window_resize SIGWINCH

# Get terminal dimensions
width="${COLUMNS:-$(tput cols)}"
height="${LINES:-$(tput lines)}"

# For portability, we use these UTF codes
block100="\xe2\x96\x88"  # u2588\0xe2 0x96 0x88 Solid Block 100%
block75="\xe2\x96\x93"   # u2593\0xe2 0x96 0x93 Dark shade 75%
block50="\xe2\x96\x92"   # u2592\0xe2 0x96 0x92 Half shade 50%
block25="\xe2\x96\x91"   # u2591\0xe2 0x96 0x91 Light shade 25%
block00=' '              # Literal space

blocks=( "${block100}" "${block75}" "${block50}" "${block25}" "${block00}" )

# Randomly select one of the color sets
# This could be moved to an arg in the future
# or split to a separate screensaver
# This would allow desired behaviour to be selectable
while true; do
  rand="${RANDOM}"

  # Require range [0, 32766] to evenly divide by 2
  # Reject 32767 to avoid modulo bias
  if (( rand < 32767 )); then
    result=$(( rand % 2 ))
    if (( result == 0 )); then
      # Black, white, greys from 256 ANSI set
      color_set=( 0 7 8 15 16 145 188 {231..255} )  
    else
      # Black, white, greys from 256 ANSI set, with RGBY thrown in
      color_set=( 0 7 8 15 16 145 188 {231..255} 196 46 21 226 )
    fi
    break
  fi
  # If we're at this line, RANDOM hit 32767!
done

tput setab 0 # black background
clear
tput civis # no cursor

# Initialise vars for batching
buffer=""
count=0
batch_size=100

while true; do
  # Get random location and color
  x=$(( ${SRANDOM:-$RANDOM} % width + 1 ))
  y=$(( ${SRANDOM:-$RANDOM} % height + 1 ))
  color_element=$(( ${SRANDOM:-$RANDOM} % ${#color_set[@]} ))
  color_code="${color_set[color_element]}"
  block_element=$(( ${SRANDOM:-$RANDOM} % ${#blocks[@]} ))
  block=${blocks[block_element]}

  # Build a buffer of changes to emit
  buffer+="\e[${y};${x}H\e[38;5;${color_code}m${block}"
  ((count++))

  # Once the buffer size meets the threshold, dump it and start again
  if (( count >= batch_size )); then
    printf -- '%b' "${buffer}"
    buffer=""
    count=0
  fi
done

