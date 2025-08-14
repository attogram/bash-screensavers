#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# BOUNCING - A simple bouncing objects screensaver (optimized for speed)
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
COLORS=($'\e[31m' $'\e[32m' $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m')
OBJECT_CHAR="O"
NUM_OBJECTS=5
SLEEP_TIME=0.03

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

    local width=$(tput cols)
    local height=$(tput lines)

    # Initialize objects
    local -a pos_x
    local -a pos_y
    local -a vel_x
    local -a vel_y
    local -a colors

    for ((i=0; i<NUM_OBJECTS; i++)); do
        pos_x[$i]=$((RANDOM % (width - 2) + 1))
        pos_y[$i]=$((RANDOM % (height - 2) + 1))
        # Random initial direction: 1 or -1
        [ $((RANDOM % 2)) -eq 0 ] && vel_x[$i]=1 || vel_x[$i]=-1
        [ $((RANDOM % 2)) -eq 0 ] && vel_y[$i]=1 || vel_y[$i]=-1
        colors[$i]=${COLORS[$((RANDOM % ${#COLORS[@]}))]}
    done

    while true; do
        local frame_buffer=""
        for ((i=0; i<NUM_OBJECTS; i++)); do
            # 1. Add clear old position to frame buffer
            frame_buffer+="\e[$((${pos_y[$i]} + 1));$((${pos_x[$i]} + 1))H "

            # 2. Update position
            pos_x[$i]=$((${pos_x[$i]} + ${vel_x[$i]}))
            pos_y[$i]=$((${pos_y[$i]} + ${vel_y[$i]}))

            # 3. Check for wall collisions and reverse velocity
            if [ ${pos_x[$i]} -le 0 ] || [ ${pos_x[$i]} -ge $((width - 1)) ]; then
                vel_x[$i]=$((${vel_x[$i]} * -1))
                pos_x[$i]=$((${pos_x[$i]} + ${vel_x[$i]})) # Move back into bounds
            fi
            if [ ${pos_y[$i]} -le 0 ] || [ ${pos_y[$i]} -ge $((height - 1)) ]; then
                vel_y[$i]=$((${vel_y[$i]} * -1))
                pos_y[$i]=$((${pos_y[$i]} + ${vel_y[$i]})) # Move back into bounds
            fi

            # 4. Add draw new position to frame buffer
            frame_buffer+="\e[$((${pos_y[$i]} + 1));$((${pos_x[$i]} + 1))H${colors[$i]}${OBJECT_CHAR}"
        done

        # Print the entire frame at once
        printf '%b' "$frame_buffer"
        sleep $SLEEP_TIME
    done
}

# --- Let's get bouncing ---
animate
