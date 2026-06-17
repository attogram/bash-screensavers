#!/usr/bin/env bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# TUNNEL - A digital tunnel/hyperspace effect (optimized for speed)
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
CHARS=("." "o" "O" "*" "0")
COLORS=($'\e[31m' $'\e[32m' $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m')
DELAY=0.02

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
    tput cnorm        # show the cursor again
    tput sgr0
    echo
    exit 0
}

trap _cleanup_and_exit SIGINT # Ctrl‑C

#
# Main animation loop
#
animate() {
    if [[ ! transparent_background -eq 1 ]]; then
        tput setab 0 # black background
    fi
    clear
    tput civis # Hide cursor

    local width
    width=$(tput cols)
    local height
    height=$(tput lines)
    local original_center_x=$((width / 2))
    local original_center_y=$((height / 2))
    local center_x=$original_center_x
    local center_y=$original_center_y
    local center_offset_x=$((width / 4))
    local center_offset_y=$((height / 4))
    local angle=0
    local max_radius=$((width + height))
    local ribbon_spacing=7
    local -a radii=()
    local frame_counter=0
    local frame_buffer=""

    # --- New state variables for movement ---
    local is_moving=0 # Start in a paused state
    local next_state_change_time
    next_state_change_time=$(date +%s)
    local move_duration=10      # seconds
    local min_pause_duration=5  # seconds
    local max_pause_duration=20 # seconds
    local angle_increment=0.005 # Slow down the movement

    # Plot a point, checking for screen boundaries
    plot_point() {
        local x=$1 y=$2 char=$3 color=$4
        if ((x >= 0 && x < width && y >= 0 && y < height)); then
            frame_buffer+="\e[$((y + 1));$((x + 1))H${color}${char}"
        fi
    }

    # Erase a point, checking for screen boundaries
    erase_point() {
        local x=$1 y=$2
        if ((x >= 0 && x < width && y >= 0 && y < height)); then
            frame_buffer+="\e[$((y + 1));$((x + 1))H "
        fi
    }

    while true; do
        # --- State management for movement ---
        local current_time
        current_time=$(date +%s)
        if ((current_time >= next_state_change_time)); then
            if ((is_moving)); then
                # Transition to paused state
                is_moving=0
                local pause_duration=$((RANDOM % (max_pause_duration - min_pause_duration + 1) + min_pause_duration))
                next_state_change_time=$((current_time + pause_duration))
            else
                # Transition to moving state
                is_moving=1
                next_state_change_time=$((current_time + move_duration))
            fi
        fi

        # --- Update center coordinates only when moving ---
        if ((is_moving)); then
            # When moving, the center of the tunnel is continuously recalculated
            # to create the illusion of flying through a turning tunnel.
            read -r angle center_x center_y < <(awk -v angle="$angle" \
                -v center_x="$original_center_x" -v center_y="$original_center_y" \
                -v offset_x="$center_offset_x" -v offset_y="$center_offset_y" \
                -v angle_increment="$angle_increment" \
                'BEGIN {
                    angle += angle_increment;
                    cx = int(center_x + offset_x * cos(angle));
                    cy = int(center_y + offset_y * sin(angle));
                    print angle, cx, cy;
                }')
        fi

        frame_buffer=""
        # Add a new ribbon every few frames
        if ((frame_counter % ribbon_spacing == 0)); then
            radii+=("1 $center_x $center_y")
        fi

        local -a next_radii=()
        for ridge_data in "${radii[@]}"; do
            local r cx cy
            read -r r cx cy <<<"$ridge_data"

            if [ $r -gt 0 ]; then
                local prev_r=$((r - 1))
                # Erase the previous shape
                for ((i = 0; i < prev_r; i++)); do
                    erase_point $((cx + i)) $((cy - prev_r + i))
                    erase_point $((cx + prev_r - i)) $((cy + i))
                    erase_point $((cx - i)) $((cy + prev_r - i))
                    erase_point $((cx - prev_r + i)) $((cy - i))
                done
            fi

            local color=${COLORS[$((r % ${#COLORS[@]}))]}
            local char=${CHARS[$((r % ${#CHARS[@]}))]}
            # Draw a square/diamond shape
            for ((i = 0; i < r; i++)); do
                plot_point $((cx + i)) $((cy - r + i)) "$char" "$color"
                plot_point $((cx + r - i)) $((cy + i)) "$char" "$color"
                plot_point $((cx - i)) $((cy + r - i)) "$char" "$color"
                plot_point $((cx - r + i)) $((cy - i)) "$char" "$color"
            done

            # Increment radius for the next frame, and keep it if it's not too large
            local next_r=$((r + 1))
            if ((next_r < max_radius)); then
                next_radii+=("$next_r $cx $cy")
            fi
        done

        radii=("${next_radii[@]}")
        printf '%b' "$frame_buffer"
        sleep $DELAY
        ((frame_counter++))
    done
}

# --- Let's fly through the tunnel ---
animate
