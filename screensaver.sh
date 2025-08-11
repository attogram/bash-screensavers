#!/bin/bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# BASH-SCREENSAVERS
#
# A collection of screensavers written in bash.
# Because who needs fancy graphics when you have ASCII?
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Configuration ---
SCREENSAVERS_DIR="screensavers"

# --- Functions ---

#
# Lists all available screensavers.
#
list_screensavers() {
    echo "Finding screensavers in '$SCREENSAVERS_DIR'..."
    # find all the .sh files in the screensavers subdirectories
    find "$SCREENSAVERS_DIR" -mindepth 2 -maxdepth 2 -type f -name "*.sh"
}

#
# Prompts the user to choose a screensaver from the list.
#
choose_screensaver() {
    local screensavers=("$@")
    if [ ${#screensavers[@]} -eq 0 ]; then
        echo "Whoops! No screensavers found. Add some to the '$SCREENSAVERS_DIR' directory."
        exit 1
    fi

    echo "Available Screensavers:"

    local i=1
    for saver in "${screensavers[@]}"; do
        # strip the path and .sh extension for a cleaner name
        local name=$(basename "$saver" .sh)
        echo "  $i. $name"
        i=$((i+1))
    done

    local choice
    read -p "Enter the number of the screensaver you want to run: " choice

    # Validate the choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#screensavers[@]}" ]; then
        echo "Invalid choice. Please enter a number from the list."
        exit 1
    fi

    echo "${screensavers[$((choice-1))]}"
}

#
# Runs the selected screensaver.
#
run_screensaver() {
    local screensaver_path="$1"
    if [ -f "$screensaver_path" ] && [ -x "$screensaver_path" ]; then
        # Run the screensaver
        "$screensaver_path"
    elif [ -f "$screensaver_path" ]; then
        echo "Making the screensaver executable..."
        chmod +x "$screensaver_path"
        "$screensaver_path"
    else
        echo "Hmm, something went wrong. Cannot find the screensaver at '$screensaver_path'."
        exit 1
    fi
}

#
# Main function to run the script.
#
main() {
    echo "Welcome to the Bash Screensaver Extravaganza!"

    local screensaver_files=($(list_screensavers))
    local chosen_saver=$(choose_screensaver "${screensaver_files[@]}")

    if [ -n "$chosen_saver" ]; then
        echo "Launching $chosen_saver..."
        run_screensaver "$chosen_saver"
    fi

    echo "Thanks for watching!"
}

# --- Let's get this party started! ---
main
