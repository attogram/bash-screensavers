#!/usr/bin/env bash
#
# Bash Screensavers
#
# A collection of screensavers written in bash.
# Because who needs fancy graphics when you have ASCII?
#

BASH_SCREENSAVERS_NAME='Bash Screensavers'
BASH_SCREENSAVERS_VERSION='0.0.24'
BASH_SCREENSAVERS_CODENAME='Mystic Destiny'
BASH_SCREENSAVERS_URL='https://github.com/attogram/bash-screensavers'
BASH_SCREENSAVERS_DISCORD='https://discord.gg/BGQJCbYVBa'
BASH_SCREENSAVERS_LICENSE='MIT'
BASH_SCREENSAVERS_COPYRIGHT='Copyright (c) 2025 Attogram Project <https://github.com/attogram>'

BASH_SCREENSAVERS_GALLERY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)/gallery"

chosen_screensaver='' # the chosen one

# Peak into the gallery
#
# Output: list of screensaver run scripts, 1 per line
peak_into_the_gallery() {
  local screensaver name run
  for screensaver in "$BASH_SCREENSAVERS_GALLERY"/*/; do
    if [[ -d "${screensaver}" ]]; then
      name="$(basename "${screensaver}")"
      run="${screensaver}${name}.sh"
      if [[ -f "${run}" ]]; then
        printf '%s\n' "$run"
      fi
    fi
  done
}

# Enjoy a screensaver
#
# Input: 1 - full path to the screensaver run script
# Output: The visual goodness of the screensaver
enjoy_a_screensaver() {
    local visual_goodness="$1"
    if [[ ! -f "$visual_goodness" ]]; then
        echo "404 Screensaver Not Found: $visual_goodness"
        return 1
    fi
    if [[ ! -x "$visual_goodness" ]]; then
        tput setaf 1 # red foreground
        printf "\nWoah there, partner! This screensaver ain't ready for the big show yet.\n"
        printf "Give it some execute permissions and we'll be in business:\n\n"
        printf "chmod +x %s\n\n" "$visual_goodness"
        printf "(Press ^C to exit and fix, or to ponder the meaning of file permissions)\n"
        tput setaf 2 # back to green
        return 2
    fi
    ( "$visual_goodness" ) # Execute the saver in a sub‑shell – isolates its `exit` from the menu script
    return $?
}

intro() {
    #TODO - smart emptiness, or even a nice box around the menu with pretty colors and stuff
    local emptiness='                                                                      '
    echo "$emptiness"
    echo "$BASH_SCREENSAVERS_NAME v$BASH_SCREENSAVERS_VERSION ($BASH_SCREENSAVERS_CODENAME)" '     '
    echo "$emptiness"
}

choose_screensaver() {
  intro
  local screensavers
  mapfile -t screensavers < <(peak_into_the_gallery)
  if [[ ${#screensavers[@]} -eq 0 ]]; then
    echo "Whoops! No screensavers found. Add some to the '$BASH_SCREENSAVERS_GALLERY' directory."
    echo
    exit 1
  fi

  # Create a list of names for display and for name matching
  local names=()
  local i=1
  for saver in "${screensavers[@]}"; do
    local name
    name="$(basename "$saver" .sh)"
    names+=("$name")
    local tagline
    # Source config in a subshell to prevent it from breaking the main script
    tagline="$( (
        local config_file
        config_file="$(dirname "$saver")/config.sh"
        if [[ -f "$config_file" ]]; then
            # shellcheck source=/dev/null
            source "$config_file"
            echo "$tagline"
        fi
    ) 2>/dev/null )"
    if [[ -z "$tagline" ]]; then
        printf '  %-2s. %s     \n' "$i" "$name"
    else
        printf '  %-2s. %-12s - %s     \n' "$i" "$name" "$tagline"
    fi
    i=$((i+1))
  done

  echo
  echo '(Press ^C to exit)'

  local choice
  echo
  echo -n 'Choose your screensaver: '
  read -r -e choice

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

  #echo
  echo 'Oops, invalid input!  Please enter a number or name from the list.     '
  echo
  return 1
}

create_new_screensaver() {
    local name="$1"
    local dir="$BASH_SCREENSAVERS_GALLERY/$name"

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
#!/usr/bin/env bash

_cleanup_and_exit() {
  tput cnorm # show the cursor again
  tput sgr0  # reset all attributes
  echo
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

    echo
    echo "Successfully created new screensaver '$name' in $dir"
    echo 'To make it runnable, execute:'
    echo "chmod +x $script_path"
    echo
}

_main_menu_cleanup() {
    tput sgr0 # Reset terminal attributes
    echo; echo; echo 'Enjoyed Bash Screensavers? Give the project a star on GitHub! ✨'
    echo; echo "${BASH_SCREENSAVERS_URL}"; echo
}
trap _main_menu_cleanup EXIT

main_menu() {
    while true; do
      tput setab 0 # black background
      tput setaf 2 # green foreground
      echo

      if ! choose_screensaver; then
          continue # Invalid choice, re-show menu
      fi

      enjoy_a_screensaver "$chosen_screensaver" # run until user presses ^C
      screensaver_return=$?
      if (( screensaver_return )); then
            tput setab 0 # black background
            tput setaf 1 # red foreground
            printf '\n\nOh no! Screensaver had trouble! Error code: %d\n\n' "$screensaver_return"
            tput sgr0 # reset
        fi
    done
}

# TODO: better arg handling, add: -version, -help, -verbose and whatever

if [ "$1" == "-n" ] || [ "$1" == "--new" ]; then
    if [ -z "$2" ]; then
        echo "Error: missing screensaver name for $1 option." >&2
        exit 1
    fi
    create_new_screensaver "$2"
else
    main_menu
fi
