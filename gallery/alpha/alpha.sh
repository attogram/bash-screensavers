#!/usr/bin/env bash
#
# alpha screensaver
#

SLEEPY_TIME="0.30" # Number of seconds of sleepy time between alpha-ness

_cleanup_and_exit() { # handler for SIGINT (Ctrl‑C)
  tput cnorm       # show the cursor again
  printf '\e[0m\n' # reset colours and move to a new line
  exit 0
}

trap _cleanup_and_exit SIGINT # Ctrl‑C

_color() {
  printf '\e[38;5;%dm' $((RANDOM % 256))
}

_location() {
  tput cup $(($RANDOM%$(tput lines))) $(($RANDOM%$(tput cols)))
}

clear
tput civis # no cursor

while true; do
  _location
  printf '%s█%s' "$(_color)" $'\e[0m'
  sleep "$SLEEPY_TIME"
done
