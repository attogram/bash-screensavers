#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# TUNNEL - A digital tunnel/hyperspace effect
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

trap cleanup SIGINT # Trap CONTROL-C

# --- Configuration ---
RESET=$'\e[0m'
CHARS=("." "o" "O" "*" "0")
COLORS=($'\e[31m' $'\e[32m' $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m')

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
    local center_x=$((width / 2))
    local center_y=$((height / 2))
    local max_radius=$((height < width ? height / 2 : width / 2))

    while true; do
        for ((r=1; r < max_radius; r++)); do
            local color=${COLORS[$((r % ${#COLORS[@]}))]}
            local char=${CHARS[$((r % ${#CHARS[@]}))]}

            # Draw a square/diamond shape
            for ((i=0; i < r; i++)); do
                local x1=$((center_x + i))
                local y1=$((center_y - r + i))
                local x2=$((center_x + r - i))
                local y2=$((center_y + i))
                local x3=$((center_x - i))
                local y3=$((center_y + r - i))
                local x4=$((center_x - r + i))
                local y4=$((center_y - i))

                # Draw the four corners of the expanding diamond
                tput cup $y1 $x1; printf '%s%s' "$color" "$char"
                tput cup $y2 $x2; printf '%s%s' "$color" "$char"
                tput cup $y3 $x3; printf '%s%s' "$color" "$char"
                tput cup $y4 $x4; printf '%s%s' "$color" "$char"
            done

            sleep 0.02

            # Erase the previous shape
            if [ $r -gt 1 ]; then
                local prev_r=$((r-1))
                for ((i=0; i < prev_r; i++)); do
                    local x1=$((center_x + i))
                    local y1=$((center_y - prev_r + i))
                    local x2=$((center_x + prev_r - i))
                    local y2=$((center_y + i))
                    local x3=$((center_x - i))
                    local y3=$((center_y + prev_r - i))
                    local x4=$((center_x - prev_r + i))
                    local y4=$((center_y - i))
                    tput cup $y1 $x1; printf " "
                    tput cup $y2 $x2; printf " "
                    tput cup $y3 $x3; printf " "
                    tput cup $y4 $x4; printf " "
                done
            fi
        done
        # Clear the center after a full cycle
        tput cup $center_y $center_x; printf " "
    done
}

# --- Let's fly through the tunnel ---
animate
