#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# BOUNCING - A simple bouncing objects screensaver
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

trap cleanup SIGINT # Trap CONTROL-C

# --- Configuration ---
RESET=$'\e[0m'
COLORS=($'\e[31m' $'\e[32m' $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m')
OBJECT_CHAR="O"
NUM_OBJECTS=5
SLEEP_TIME=0.05

# --- Functions ---

#
# Cleanup function to restore the terminal
#
cleanup() {
    tput cnorm # Restore cursor
    printf '%s' "$RESET"
    printf '\n'
    exit 0
}

#
# Main animation loop
#
animate() {
    clear
    tput civis # Hide cursor

    local width=$(tput cols)
    local height=$(tput lines)

    # Initialize objects
    local pos_x=()
    local pos_y=()
    local vel_x=()
    local vel_y=()
    local colors=()

    for ((i=0; i<NUM_OBJECTS; i++)); do
        pos_x[$i]=$((RANDOM % (width - 2) + 1))
        pos_y[$i]=$((RANDOM % (height - 2) + 1))
        # Random initial direction: 1 or -1
        [ $((RANDOM % 2)) -eq 0 ] && vel_x[$i]=1 || vel_x[$i]=-1
        [ $((RANDOM % 2)) -eq 0 ] && vel_y[$i]=1 || vel_y[$i]=-1
        colors[$i]=${COLORS[$((RANDOM % ${#COLORS[@]}))]}
    done

    while true; do
        for ((i=0; i<NUM_OBJECTS; i++)); do
            # 1. Clear old position
            tput cup ${pos_y[$i]} ${pos_x[$i]}
            printf " "

            # 2. Update position
            pos_x[$i]=$((${pos_x[$i]} + ${vel_x[$i]}))
            pos_y[$i]=$((${pos_y[$i]} + ${vel_y[$i]}))

            # 3. Check for wall collisions and reverse velocity
            if [ ${pos_x[$i]} -le 0 ] || [ ${pos_x[$i]} -ge $((width - 1)) ]; then
                vel_x[$i]=$((${vel_x[$i]} * -1))
                # Move back into bounds immediately to prevent getting stuck
                pos_x[$i]=$((${pos_x[$i]} + ${vel_x[$i]}))
            fi
            if [ ${pos_y[$i]} -le 0 ] || [ ${pos_y[$i]} -ge $((height - 1)) ]; then
                vel_y[$i]=$((${vel_y[$i]} * -1))
                # Move back into bounds immediately
                pos_y[$i]=$((${pos_y[$i]} + ${vel_y[$i]}))
            fi

            # 4. Draw new position
            tput cup ${pos_y[$i]} ${pos_x[$i]}
            printf '%s%s' "${colors[$i]}" "$OBJECT_CHAR"
        done
        sleep $SLEEP_TIME
    done
}

# --- Let's get bouncing ---
animate
