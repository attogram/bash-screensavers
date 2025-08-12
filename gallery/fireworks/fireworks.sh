#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# FIREWORKS - A simple fireworks display
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
RESET=$'\e[0m'
COLORS=($'\e[31m' $'\e[32m' $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m' $'\e[91m' $'\e[92m' $'\e[93m' $'\e[94m' $'\e[95m' $'\e[96m')
ROCKET_CHARS=("." "^" "+")
EXPLOSION_CHARS=("*" "+" ".")

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

    local width=$(tput cols)
    local height=$(tput lines)

    while true; do
        # --- Rocket Launch ---
        local rocket_x=$((RANDOM % width))
        local rocket_y=$((height - 1))
        local peak_y=$((RANDOM % (height / 2)))
        local rocket_color=${COLORS[$((RANDOM % ${#COLORS[@]}))]}
        local rocket_char=${ROCKET_CHARS[$((RANDOM % ${#ROCKET_CHARS[@]}))]}

        # Draw rocket ascending
        for ((y=rocket_y; y > peak_y; y--)); do
            tput cup $y $rocket_x
            printf '%s%s' "$rocket_color" "$rocket_char"
            sleep 0.01
            tput cup $y $rocket_x
            printf " "
        done

        # --- Explosion ---
        local explosion_color=${COLORS[$((RANDOM % ${#COLORS[@]}))]}
        local explosion_char=${EXPLOSION_CHARS[$((RANDOM % ${#EXPLOSION_CHARS[@]}))]}
        local explosion_radius=$(( (RANDOM % 5) + 3 )) # Radius of 3 to 7

        # Expanding explosion
        for ((r=1; r <= explosion_radius; r++)); do
            # Simple diamond shape for explosion
            for ((i=0; i<r; i++)); do
                tput cup $((peak_y - r + i)) $((rocket_x + i)); printf '%s%s' "$explosion_color" "$explosion_char"
                tput cup $((peak_y + i)) $((rocket_x + r - i)); printf '%s%s' "$explosion_color" "$explosion_char"
                tput cup $((peak_y + r - i)) $((rocket_x - i)); printf '%s%s' "$explosion_color" "$explosion_char"
                tput cup $((peak_y - i)) $((rocket_x - r + i)); printf '%s%s' "$explosion_color" "$explosion_char"
            done
            sleep 0.05
        done

        # Clear the explosion
        for ((r=1; r <= explosion_radius; r++)); do
            for ((i=0; i<r; i++)); do
                tput cup $((peak_y - r + i)) $((rocket_x + i)); printf " "
                tput cup $((peak_y + i)) $((rocket_x + r - i)); printf " "
                tput cup $((peak_y + r - i)) $((rocket_x - i)); printf " "
                tput cup $((peak_y - i)) $((rocket_x - r + i)); printf " "
            done
        done

        sleep 0.5 # Wait a moment before the next firework
    done
}

# --- Let the show begin ---
animate
