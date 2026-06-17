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

tput setab 0 # black background
clear
tput civis # no cursor

# Initialise vars for batching
# This eliminates "one pixel change per loop iteration"
# Benchmarking led to a batch_size selection of 100
buffer=""
count=0
batch_size=100

emit_with_color() {
  local color_set x y color_element color_code
  local block_element block buffer count batch_size
  color_set=( 0 7 8 15 16 145 188 {231..255} 196 46 21 226 )
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
}

# Uses direct color calculation instead of array lookup
# Benchmarking shows ~11% improvement over emit_with_color()
# Generates grey shades from ANSI 231-255 (25 shades)
emit_with_simple_color() {
  local x y color_code
  local block_element block buffer count batch_size
  while true; do
    # Get random location
    x=$(( ${SRANDOM:-$RANDOM} % width + 1 ))
    y=$(( ${SRANDOM:-$RANDOM} % height + 1 ))

    # Direct color calculation - no array needed
    color_code=$(( 231 + ${SRANDOM:-$RANDOM} % 25 ))

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
}

# In benchmarking, this performs 25-30% faster than emit_with_color()
# Eliminating the rand calls for color selection clearly has an impact
# Implicit trust of the terminal color state may have unpredictable results
# At the end of the day, we're constrained by a shell loop
# More performance could potentially be gleaned with parallelism (see: forkrun)
emit_without_color() {
  local x y color_code
  local block_element block buffer count batch_size
  color_code=15
  while true; do
    # Get random location and color
    x=$(( ${SRANDOM:-$RANDOM} % width + 1 ))
    y=$(( ${SRANDOM:-$RANDOM} % height + 1 ))
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
}

# Randomly select one of the color modes
# This could be moved to an arg in the future or split to separate screensavers
# This would allow desired behaviour to be selectable
while true; do
  rand="${RANDOM}"
  # Require range [0, 32765] to evenly divide by 3
  # Reject 32766 and 32767 to avoid modulo bias
  if (( rand < 32766 )); then
    color_mode=$(( rand % 3 ))
    case "${color_mode}" in
      (0)
        # Greys only - use simple direct calculation (fastest with color)
        emit_with_simple_color
      ;;
      (1)
        # Greys + accent colors - needs array lookup for RGBY
        emit_with_color
      ;;
      (2)
        # White only - uses emit_without_color (fastest overall)
        emit_without_color
      ;;
    esac
  fi
  # If we're at this line, RANDOM hit 32766 or 32767!
done
