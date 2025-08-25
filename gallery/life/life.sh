#!/usr/bin/env bash

# FROM: https://github.com/Liam-Wirth/Automata.sh/blob/main/life.sh
# LICENSE: unknown

# MODIFIED for attogram/bash-screensavers
# LICENSE: MIT

# --- Configuration ---
INITIAL_DENSITY=20 # Percentage of initially live cells (approx)
SLEEP_DURATION=0.001

# --- Terminal Setup & Globals ---
# Use full terminal size initially
rows=$(tput lines)
cols=$(tput cols)

declare -A front # Current generation grid
declare -A back  # Next generation grid (buffer)

# --- Cell Appearance ---
# Default to ASCII
LIVE_CELL="O"
DEAD_CELL="."

# Attempt to detect UTF-8 locale for nicer characters
check_unicode_support() {
    local charmap
    # Check locale command first
    if command -v locale >/dev/null 2>&1; then
        charmap=$(locale charmap 2>/dev/null)
        if [[ "${charmap^^}" == "UTF-8" ]]; then
            LIVE_CELL="█" # Full Block U+2588
            DEAD_CELL=" " # Space
            return 0 # Indicate success
        fi
    fi
    # Fallback check if locale command missing or not UTF-8
    if [[ "${LC_ALL:-${LC_CTYPE:-$LANG}}" == *.UTF-8 ]]; then
         LIVE_CELL="█"
         DEAD_CELL=" "
         return 0 # Indicate success
    fi
    return 1 # Indicate ASCII fallback
}
check_unicode_support
# Make DEAD_CELL visible if we fell back to ASCII
if [[ $? -ne 0 ]]; then
    DEAD_CELL="."
fi


init() {
   printf '\e[?1049h' # Switches to the alternate screen buffer.
   printf '\e[?25l' # hide cursor
   clear
}

cleanup() {
   while read -r -t 0.001 -N 1; do : ; done # Consumes any pending input bytes
   printf '\e[?25h' # Shows the cursor again
   printf '\e[?1049l' # Leaves the alternate screen
   exit 0
}

trap cleanup EXIT INT TERM QUIT # Set up cleanup on exit/interrupt


init_grid() {
   local r c num_cells target_cells
   front=() # Clear the front grid
   target_cells=$(( rows * cols * INITIAL_DENSITY / 100 ))
   [[ $target_cells -lt 0 ]] && target_cells=0

   for (( num_cells=0; num_cells < target_cells; num_cells++ )); do
      r=$(( RANDOM % rows ))
      c=$(( RANDOM % cols ))
      front["$r,$c"]=1
   done
}

# Calculate the next generation/state of the grid
update_grid() {
   local r c nr nc dr dc neighbors is_alive key
   declare -A cells_to_check

   # 1. Identify cells needing checks
   for key in "${!front[@]}"; do
       IFS=',' read -r r c <<< "$key"
       cells_to_check["$r,$c"]=1
       for dr in -1 0 1; do for dc in -1 0 1; do
          nr=$(( (r + dr + rows) % rows ))
          nc=$(( (c + dc + cols) % cols ))
          cells_to_check["$nr,$nc"]=1
       done done
   done

   back=()

   for key in "${!cells_to_check[@]}"; do
       IFS=',' read -r r c <<< "$key"

       neighbors=0
       for dr in -1 0 1; do
          for dc in -1 0 1; do
             [[ $dr -eq 0 && $dc -eq 0 ]] && continue # Skip self
             nr=$(( (r + dr + rows) % rows ))
             nc=$(( (c + dc + cols) % cols ))
             [[ -v front["$nr,$nc"] ]] && ((neighbors++))
          done
       done
       is_alive=0
       [[ -v front["$key"] ]] && is_alive=1

       if (( is_alive )); then
          # Survive
          if (( neighbors == 2 || neighbors == 3 )); then
             back["$key"]=1
          fi
       else
          # Reproduce
          if (( neighbors == 3 )); then
             back["$key"]=1
          fi
       fi
   done
}


# Draw the changes using ANSI escapes and batched output
draw_grid() {
    local key r c
    local draw_buffer=""

    # Cells that died (in front but not in back)
    for key in "${!front[@]}"; do
        if [[ ! -v back["$key"] ]]; then
            IFS=',' read -r r c <<< "$key"
            draw_buffer+="\e[$((r + 1));$((c + 1))H${DEAD_CELL}"
        fi
    done

    # Cells that were born or survived (in back)
    for key in "${!back[@]}"; do
        # Optimization: Only draw if it wasn't already alive (reduces overdraw)
        if [[ ! -v front["$key"] ]]; then
             IFS=',' read -r r c <<< "$key"
             draw_buffer+="\e[$((r + 1));$((c + 1))H${LIVE_CELL}"
        fi
    done

    draw_buffer+="\e[$((rows));$((cols))H"

    # Print the entire buffer at once
    printf "%b" "$draw_buffer"
}


# Swap grids: copy 'back' content to 'front'
swap() {
    front=()
    for key in "${!back[@]}"; do
        front["$key"]="${back[$key]}"
    done

}

# --- Main Loop ---
main() {
   init
   init_grid

   # Initial draw (draw all live cells from the start using ANSI batching)
   clear # Clear screen once initially
   local initial_draw_buffer=""
   for key in "${!front[@]}"; do
       IFS=',' read -r r c <<< "$key"
       initial_draw_buffer+="\e[$((r + 1));$((c + 1))H${LIVE_CELL}"
   done
   initial_draw_buffer+="\e[$((rows));$((cols))H" # Move cursor away
   printf "%b" "$initial_draw_buffer" # Print initial state

   while true; do
      update_grid
      draw_grid
      swap

      sleep "$SLEEP_DURATION"
   done
}

main
