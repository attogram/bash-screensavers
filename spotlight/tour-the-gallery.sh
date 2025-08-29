#!/usr/bin/env bash
#
# tour-the-gallery.sh
#
# This script creates an overview of all screensavers.
#

# --- Helper Functions ---

validate_cast() {
    local cast_file="$1"
    if [[ ! -s "$cast_file" ]]; then
        echo "Error: Cast file is empty: $cast_file"
        exit 1
    fi
    if ! head -n 1 "$cast_file" | grep -q '^{.*}$'; then
        echo "Error: Invalid JSON header in cast file: $cast_file"
        cat "$cast_file" >&2
        exit 1
    fi
}

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
#!/usr/bin/env bash
clear
tput cup 5 10
if command -v figlet &>/dev/null; then
    figlet -w \$(tput cols) -c <<< "$text"
else
    echo "$text"
fi
sleep 1
EOF
    chmod +x "$temp_script"

    # Record the script with asciinema
    asciinema rec --command="$temp_script" --idle-time-limit=1 --overwrite "$output_file"
    validate_cast "$output_file"

    rm "$temp_script"
}

# --- Main Logic ---

main() {
    check_deps

    local gallery_dir="gallery"
    local output_dir="."
    local temp_dir
    temp_dir=$(mktemp -d)
    echo "Temp dir: $temp_dir"
    local all_casts=()

    echo "Creating overview cast..."

    # 1. Intro Title Card
    echo "  - Creating intro title card..."
    create_title_card "Bash Screensavers" "$temp_dir/00_intro.cast"
    all_casts+=("$temp_dir/00_intro.cast")

    # 2. Loop through screensavers
    echo "-> Starting to record screensavers..."
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

                # Add the existing cast file
                local cast_file="${screensaver_dir}${name}.cast"
                if [[ -f "$cast_file" ]]; then
                    validate_cast "$cast_file"
                    all_casts+=("$cast_file")
                else
                    echo "Warning: Cast file not found for $name, skipping."
                fi

                i=$((i+1))
            fi
        fi
    done
    echo "<- Finished recording screensavers."

    # 3. Outro Title Card
    echo "  - Creating outro title card..."
    create_title_card "by attogram" "$temp_dir/99_outro.cast"
    all_casts+=("$temp_dir/99_outro.cast")

    # 4. Concatenate all casts
    echo "  - Concatenating all casts..."
    local overview_cast="$output_dir/overview.cast"
    asciinema cat "${all_casts[@]}" > "$overview_cast"
    echo "  - Concatenation complete."

    # 5. Convert to GIF
    echo "  - Converting to GIF..."
    validate_cast "$overview_cast"
    local overview_gif="$output_dir/overview.gif"
    agg "$overview_cast" "$overview_gif"
    echo "  - Conversion to GIF complete."
    # 6. Clean up
    echo "  - Cleaning up..."
    #rm -rf "$temp_dir"

    echo "Done! Overview saved to $overview_cast and $overview_gif"
}

main "$@"
