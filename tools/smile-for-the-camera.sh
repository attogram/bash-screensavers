#!/usr/bin/env bash
#
# smile-for-the-camera.sh
#
# This script creates animated GIF previews for each screensaver.
#
# Dependencies:
#   - asciinema
#   - agg
#
# Installation:
#
# macOS:
#   brew install asciinema agg
#
# Debian/Ubuntu:
#   sudo apt-get install asciinema
#   # agg needs to be installed from source or a package manager like pip
#   pip install --user agg
#
# Arch Linux:
#   sudo pacman -S asciinema agg
#
# Cygwin:
#   Follow instructions on the websites for asciinema and agg


# --- Helper Functions ---

# Check for dependencies
check_deps() {
    if ! command -v asciinema &> /dev/null; then
        echo "Error: asciinema not found. Please install it."
        exit 1
    fi
}

# --- Main Logic ---

main() {
    check_deps

    local gallery_dir="gallery"
    local output_dir="gallery"

    echo "Creating previews for all screensavers..."

    for screensaver_dir in "$gallery_dir"/*/; do
        if [[ -d "$screensaver_dir" ]]; then
            local name
            name=$(basename "$screensaver_dir")
            local run_script="${screensaver_dir}${name}.sh"
            local output_path_base="$output_dir/$name/$name"

            if [[ -f "$run_script" ]]; then
                echo "  - Creating preview for $name..."

                # Create output directory if it doesn't exist
                mkdir -p "$output_dir/$name"

                # Record with asciinema
                local cast_file="${output_path_base}.cast"
                asciinema rec --command="bash -c 'timeout 10s env SHELL=/bin/bash $run_script'" --overwrite "$cast_file"

                # Process the cast file with awk to remove startup artifacts
                #local cast_file="${output_path_base}.cast"
                #awk 'NR==1{print;next} /^\[/ && substr($1,2)+0 > 0.1' "$raw_cast_file" > "$cast_file"

                # Convert to GIF with agg
                local gif_file="${output_path_base}.gif"
                if command -v agg &> /dev/null; then
                    agg "$cast_file" "$gif_file"
                elif command -v python &> /dev/null; then
                    python -m agg "$cast_file" "$gif_file"
                else
                    echo "Warning: agg or python not found. Skipping GIF generation."
                fi

                # Clean up the raw cast file
                #rm "$raw_cast_file"

                echo "    - Saved to $cast_file and $gif_file"
            fi
        fi
    done

    echo "Done!"
}

main "$@"
