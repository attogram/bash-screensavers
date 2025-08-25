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

ROWS=20
COLS=80

# --- Helper Functions ---

# Check for dependencies
check_deps() {
    if ! command -v asciinema &> /dev/null; then
        echo "Error: asciinema not found. Please install it."
        exit 1
    fi

    if ! command -v agg &> /dev/null; then
        echo "Warning: agg not found. GIF generation will be skipped."
        echo "  To install agg, follow the instructions at https://docs.asciinema.org/manual/agg/installation/"
    fi
}

# --- Main Logic ---

main() {
    check_deps

    local gallery_dir="gallery"
    local output_dir="gallery"
    local temp_dir
    temp_dir=$(mktemp -d)

    # a trap to clean up the temporary directory
    trap 'rm -rf "$temp_dir"' EXIT

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

                tput setab 0 # black background
                clear
                tput civis # no cursor

                # Tell the kernel what the size *should* be
                stty rows "$ROWS" cols "$COLS"

                # Ask the emulator to change its real size (works only in emulators that support CSI 8)
                printf '\e[8;%d;%dt' "$ROWS" "$COLS"

                # Record with asciinema
                local raw_cast_file="$temp_dir/$name.raw.cast"
                rm -f "$raw_cast_file"
                asciinema rec --command="bash -c 'timeout 10s env SHELL=/bin/bash $run_script'" "$raw_cast_file"

                # Process the cast file with awk to remove startup artifacts
                local cast_file="${output_path_base}.cast"
                awk 'NR==1{print;next} /^\[/ && substr($1,2)+0 > 0.5' "$raw_cast_file" > "$cast_file"

                # Convert to GIF with agg
                local gif_file="${output_path_base}.gif"
                if command -v agg &> /dev/null; then
                    agg "$cast_file" "$gif_file"
                    echo "    - Saved to $cast_file and $gif_file"
                else
                    echo "    - Saved to $cast_file"
                fi
            fi
        fi
    done

    tput cnorm       # show the cursor again
    tput sgr0

    echo "Done!"
}

main "$@"
