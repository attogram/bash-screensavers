#!/usr/bin/env bash
#
# Bash Screensaver Chooser
#
# A collection of screensavers written in bash.
# Because who needs fancy graphics when you have ASCII?
#

BASH_SCREENSAVERS_NAME="Bash Screensavers"
BASH_SCREENSAVERS_VERSION="0.0.2"
BASH_SCREENSAVERS_URL="https://github.com/attogram/bash-screensavers"
BASH_SCREENSAVERS_DISCORD="https://discord.gg/BGQJCbYVBa"
BASH_SCREENSAVERS_LICENSE="MIT"
BASH_SCREENSAVERS_COPYRIGHT="Copyright (c) 2025 Attogram Project <https://github.com/attogram>"

# Get the directory of this script
# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

BASH_SCREENSAVERS_DIR="$SCRIPT_DIR/gallery"

# Lists all available screensavers.
list_screensavers() {
  local screensaver name run list
  for screensaver in $BASH_SCREENSAVERS_DIR/*/; do
    if [[ -d "${screensaver}" ]]; then
      name=$(basename "${screensaver}")
      run="${screensaver}${name}.sh"
      if [[ -f "${run}" ]]; then
        list+="$run "
      fi
    fi
  done
  printf '%s\n' "$list"
}

# Runs the selected screensaver.
run_screensaver() {
    local screensaver_path="$1"
    if [[ -f "$screensaver_path" ]] && [[ -x "$screensaver_path" ]]; then
        # Run the screensaver
        "$screensaver_path"
    elif [[ -f "$screensaver_path" ]]; then
        echo "Making the screensaver executable..."
        chmod +x "$screensaver_path"
        "$screensaver_path"
    else
        echo "Hmm, something went wrong. Cannot find the screensaver at '$screensaver_path'."
        exit 1
    fi
}

# Main screensaver goodness
main() {
    echo
    echo "$BASH_SCREENSAVERS_NAME v$BASH_SCREENSAVERS_VERSION"
    echo

    local screensavers
    screensavers=($(list_screensavers))
    if [[ ${#screensavers[@]} -eq 0 ]]; then
        echo "Whoops! No screensavers found. Add some to the '$BASH_SCREENSAVERS_DIR' directory."
        echo
        exit 1
    fi

    # Create a list of names for display and for name matching
    local names=()
    local i=1
    for saver in "${screensavers[@]}"; do
        local name=$(basename "$saver" .sh)
        names+=("$name")
        echo "  $i. $name"
        i=$((i+1))
    done

    # Set up tab completion for screensaver names
    local IFS=$'\n'
    COMPREPLY=($(compgen -W "${names[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))

    local choice
    echo
    read -e -p "Enter the number or name of the screensaver to run: " choice

    # Check if choice is a number
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
        if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#screensavers[@]}" ]; then
            echo "Invalid choice. Please enter a number from the list."
            exit 1
        fi
        run_screensaver "${screensavers[$((choice-1))]}"
    else
        # Check if choice is a name
        local found=false
        local index=0
        for name in "${names[@]}"; do
            if [[ "$name" == "$choice" ]]; then
                found=true
                run_screensaver "${screensavers[$index]}"
                break
            fi
            index=$((index+1))
        done

        if ! $found; then
            echo "Invalid choice. Please enter a valid screensaver name."
            exit 1
        fi
    fi
}

main "$@"
