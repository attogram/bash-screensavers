#!/usr/bin/env bash
#
# Bash Screensavers
#
# A collection of screensavers written in bash.
# Because who needs fancy graphics when you have ASCII?
#

BASH_SCREENSAVERS_NAME="Bash Screensavers"
BASH_SCREENSAVERS_VERSION="0.0.6"
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
    if [[ ! -f "$screensaver_path" ]]; then
        echo "Hmm, something went wrong. Cannot find the screensaver at '$screensaver_path'."
        return 1
    fi
    if [[ ! -x "$screensaver_path" ]]; then # Ensure the file is executable
        echo "Making the screensaver executable..."
        chmod +x "$screensaver_path"
    fi
    ( "$screensaver_path" ) # Execute the saver in a sub‑shell – isolates its `exit` from the menu script.
    return $?
}

choose_screensaver() {
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
    local name
    name=$(basename "$saver" .sh)
    names+=("$name")
    local tagline
    # Source config in a subshell to prevent it from breaking the main script
    tagline=$( (
        local config_file="$(dirname "$saver")/config.sh"
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
    COMPREPLY=($(compgen -W "${names[*]}" -- "${COMP_WORDS[COMP_CWORD]}"))
  fi

  echo
  echo '(Press ^C to exit)'

  local choice
  echo
  read -e -p "Choose your screensaver: " choice

  if [[ "$choice" =~ ^[0-9]+$ ]]; then   # Check if choice is a number
    if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#screensavers[@]}" ]; then
      echo "Invalid choice. Please enter a number from the list."
      exit 1
    fi
    chosen_screensaver="${screensavers[$((choice-1))]}"
    return 0
  fi

  # Check if choice is a name
  local found=false
  local index=0
  for name in "${names[@]}"; do
    if [[ "$name" == "$choice" ]]; then
      found=true
      chosen_screensaver="${screensavers[$index]}"
      return 0
    fi
    index=$((index+1))
  done
  if ! $found; then
      echo "Invalid choice. Please enter a valid screensaver name."
      exit 1
  fi
}

while true; do
  tput setab 0 # black background
  tput setaf 2 # green foreground
  clear
  choose_screensaver
  run_screensaver "$chosen_screensaver" # run until user presses ^C
  screensaver_return=$?
  if (( screensaver_return )); then
    tput setab 0; tput setaf 1 # red foreground
    printf '\nOh no! Screensaver had trouble and returned %d\n' "$screensaver_return"
    tput sgr0
    #exit $screensaver_return # Fun time is really over
  fi
done
