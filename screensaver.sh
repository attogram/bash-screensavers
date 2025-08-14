#!/usr/bin/env bash
#
# Bash Screensavers
#
# A collection of screensavers written in bash.
# Because who needs fancy graphics when you have ASCII?
#

BASH_SCREENSAVERS_NAME="Bash Screensavers"
BASH_SCREENSAVERS_VERSION="0.0.9"
BASH_SCREENSAVERS_URL="https://github.com/attogram/bash-screensavers"
BASH_SCREENSAVERS_DISCORD="https://discord.gg/BGQJCbYVBa"
BASH_SCREENSAVERS_LICENSE="MIT"
BASH_SCREENSAVERS_COPYRIGHT="Copyright (c) 2025 Attogram Project <https://github.com/attogram>"

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
BASH_SCREENSAVERS_DIR="$SCRIPT_DIR/gallery"

chosen_screensaver='' # global variable

# Lists all available screensavers.
list_screensavers() {
  local screensaver name run list
  for screensaver in "$BASH_SCREENSAVERS_DIR"/*/; do
    if [[ -d "${screensaver}" ]]; then
      name=$(basename "${screensaver}")
      run="${screensaver}${name}.sh"
      if [[ -f "${run}" ]]; then
        printf '%s\n' "$run"
      fi
    fi
  done
}

# Runs the selected screensaver.
run_screensaver() {
    local screensaver_path="$1"
    if [[ ! -f "$screensaver_path" ]]; then
        echo "Hmm, something went wrong. Cannot find the screensaver at '$screensaver_path'."
        return 1
    fi
    if [[ ! -x "$screensaver_path" ]]; then
        tput setaf 1 # red foreground
        printf "\nWoah there, partner! This screensaver ain't ready for the big show yet.\n"
        printf "Give it some execute permissions and we'll be in business:\n\n"
        printf "    chmod +x %s\n\n" "$screensaver_path"
        printf "(Press ^C to go back to the menu, or to ponder the meaning of file permissions.)\n"
        tput setaf 2 # back to green
        return 2
    fi
    ( "$screensaver_path" ) # Execute the saver in a sub‑shell – isolates its `exit` from the menu script.
    return $?
}

choose_screensaver() {
  echo
  echo "$BASH_SCREENSAVERS_NAME v$BASH_SCREENSAVERS_VERSION"
  echo

  local screensavers
  mapfile -t screensavers < <(list_screensavers)
  if [[ ${#screensavers[@]} -eq 0 ]]; then
    echo "Whoops! No screensavers found. Add some to the '$BASH_SCREENSAVERS_DIR' directory."
    echo
    exit 1
  fi

  # Create a list of names for display and for name matching
  local names=()
  local i=1
  for saver in "${screensavers[@]}"; do
    local name
    name=$(basename "$saver" .sh)
    names+=("$name")
    local tagline
    # Source config in a subshell to prevent it from breaking the main script
    tagline=$( (
        local config_file
        config_file="$(dirname "$saver")/config.sh"
        if [[ -f "$config_file" ]]; then
            # shellcheck source=/dev/null
            source "$config_file"
            echo "$tagline"
        fi
    ) 2>/dev/null )
    if [[ -z "$tagline" ]]; then
        printf "  %-2s. %s\n" "$i" "$name"
    else
        printf "  %-2s. %-12s - %s\n" "$i" "$name" "$tagline"
    fi
    i=$((i+1))
  done

  # Set up tab completion for screensaver names
  if command -v compgen &> /dev/null; then
    local IFS=$'\n'
    # TODO - use mapfile or read -r
    COMPREPLY=($(compgen -W "${names[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
  fi

  echo
  echo '(Press ^C to exit)'

  local choice
  echo
  read -e -p "Choose your screensaver: " choice

  if [[ "$choice" =~ ^[0-9]+$ ]]; then   # Check if choice is a number
    if [ "$choice" -ge 1 ] && [ "$choice" -le "${#screensavers[@]}" ]; then
      chosen_screensaver="${screensavers[$((choice-1))]}"
      return 0
    fi
  else # Check if choice is a name
      local index=0
      for name in "${names[@]}"; do
          if [[ "$name" == "$choice" ]]; then
              chosen_screensaver="${screensavers[$index]}"
              return 0
          fi
          index=$((index+1))
      done
  fi

  # If we get here, the choice was invalid
  echo
  echo "Invalid choice. Please enter a number or name from the list."
  echo
  return 1
}

create_new_screensaver() {
    local name="$1"
    local dir="$BASH_SCREENSAVERS_DIR/$name"

    if [ -d "$dir" ]; then
        echo "Error: screensaver '$name' already exists at $dir" >&2
        exit 1
    fi

    mkdir -p "$dir"
    if [ $? -ne 0 ]; then
        echo "Error: failed to create directory $dir" >&2
        exit 1
    fi

    local script_path="$dir/$name.sh"
    cat > "$script_path" << EOL
#!/bin/bash

_cleanup_and_exit() {
  tput cnorm # show the cursor again
  tput sgr0  # reset all attributes
  clear
  exit 0
}
trap _cleanup_and_exit SIGINT # Catch Ctrl-C

animate() {
    tput civis # Hide cursor
    clear
    local width=\$(tput cols)
    local height=\$(tput lines)
    while true; do
        local x=\$((RANDOM % width))
        local y=\$((RANDOM % height))
        tput cup \$y \$x
        echo "*"
        sleep 0.1
    done
}

animate
EOL

    local config_path="$dir/config.sh"
    cat > "$config_path" << EOL
# Config for the '$name' screensaver

# Name of the screensaver (12 chars max)
name="$name"

# Tagline for the screensaver (40 chars max)
tagline=""
EOL

    echo "Successfully created new screensaver '$name' in $dir"
    echo "To make it runnable, execute: chmod +x $script_path"
}

main_menu() {
    while true; do
      tput setab 0 # black background
      tput setaf 2 # green foreground
      echo
      choose_screensaver
      if [ $? -ne 0 ]; then
          continue # Invalid choice, re-show menu
      fi
      run_screensaver "$chosen_screensaver" # run until user presses ^C
      screensaver_return=$?
      if [ $screensaver_return -ne 0 ]; then
        if [ $screensaver_return -eq 2 ]; then
            # Specific error for non-executable file, message already printed
            sleep 0.1
        else
            # Generic error for other return codes
            tput setab 0; tput setaf 1 # red foreground
            printf '\n\nOh no! Screensaver had trouble and returned %d\n\n' "$screensaver_return"
            tput sgr0
            sleep 0.1
        fi
      fi
    done
}

# Main script execution
if [ "$1" == "-n" ] || [ "$1" == "--new" ]; then
    if [ -z "$2" ]; then
        echo "Error: missing screensaver name for $1 option." >&2
        exit 1
    fi
    create_new_screensaver "$2"
else
    main_menu
fi
