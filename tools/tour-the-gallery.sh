#!/usr/bin/env bash
#
# tour-the-gallery.sh
#
# This script creates an overview of all screensavers.
#

# --- Helper Functions ---

check_deps() {
    if ! command -v asciinema &> /dev/null; then
        echo "Error: asciinema not found. Please install it."
        exit 1
    fi
    if ! command -v agg &> /dev/null; then
        echo "Error: agg not found. Please install it."
        exit 1
    fi
}

run_with_timeout() {
    local timeout_duration=$1
    shift
    local command_to_run=("$@")

    # Run the command in the background
    "${command_to_run[@]}" &
    local cmd_pid=$!

    # Sleep for the duration and then kill the command
    (sleep "$timeout_duration" && kill "$cmd_pid" 2>/dev/null) &
    local sleeper_pid=$!

    # Wait for the command to finish, suppressing job termination message
    wait "$cmd_pid" 2>/dev/null

    # Kill the sleeper process if it's still running
    kill "$sleeper_pid" 2>/dev/null
}


# Create a title card as a .cast file
# $1: text to display
# $2: output .cast file
create_title_card() {
    local text="$1"
    local output_file="$2"
    local temp_script
    temp_script=$(mktemp)

    # Create a script to display the title card
    cat > "$temp_script" <<EOF
#!/bin/bash
clear
tput cup 5 10
if command -v figlet &>/dev/null; then
    figlet -w \$(tput cols) -c <<< "$text"
else
    echo "$text"
fi
sleep 2
EOF
    chmod +x "$temp_script"

    # Record the script with asciinema
    asciinema rec --command="$temp_script" --overwrite "$output_file"

    rm "$temp_script"
}

# --- Main Logic ---

main() {
    check_deps

    local gallery_dir="gallery"
    local output_dir="."
    local temp_dir
    temp_dir=$(mktemp -d)
    local all_casts=()

    echo "Creating overview cast..."

    # 1. Intro Title Card
    echo "  - Creating intro title card..."
    create_title_card "Bash Screensavers" "$temp_dir/00_intro.cast"
    all_casts+=("$temp_dir/00_intro.cast")

    # 2. Loop through screensavers
    export -f run_with_timeout
    local i=1
    for screensaver_dir in "$gallery_dir"/*/; do
        if [[ -d "$screensaver_dir" ]]; then
            local name
            name=$(basename "$screensaver_dir")
            local run_script="${screensaver_dir}${name}.sh"

            if [[ -f "$run_script" ]]; then
                echo "  - Recording snippet for $name..."

                # Title card for the screensaver
                create_title_card "$name" "$temp_dir/$(printf "%02d" $i)_${name}_title.cast"
                all_casts+=("$temp_dir/$(printf "%02d" $i)_${name}_title.cast")

                # Record a longer snippet
                local temp_cast="$temp_dir/$(printf "%02d" $i)_${name}_temp.cast"
                asciinema rec --command="bash -c 'run_with_timeout 6s env SHELL=/bin/bash $run_script'" --overwrite "$temp_cast"

                # Cut a snippet from the middle
                local snippet_cast="$temp_dir/$(printf "%02d" $i)_${name}_snippet.cast"
                asciinema cut -s 3 -e 6 "$temp_cast" > "$snippet_cast"
                all_casts+=("$snippet_cast")

                i=$((i+1))
            fi
        fi
    done

    # 3. Outro Title Card
    echo "  - Creating outro title card..."
    create_title_card "by attogram" "$temp_dir/99_outro.cast"
    all_casts+=("$temp_dir/99_outro.cast")

    # 4. Concatenate all casts
    echo "  - Concatenating all casts..."
    local overview_cast="$output_dir/overview.cast"
    asciinema cat "${all_casts[@]}" > "$overview_cast"

    # 5. Convert to GIF
    echo "  - Converting to GIF..."
    local overview_gif="$output_dir/overview.gif"
    agg "$overview_cast" "$overview_gif"

    # 6. Clean up
    echo "  - Cleaning up..."
    rm -rf "$temp_dir"

    echo "Done! Overview saved to $overview_cast and $overview_gif"
}

main "$@"
