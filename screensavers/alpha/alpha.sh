#!/usr/bin/env bash
#
# alpha screensaver
#

SLEEPY_TIME="0.30" # Number of seconds of sleepy time between alpha-ness

trap _stop SIGINT # Trap CONTROL-C

_color() {
  printf '\e[38;5;%dm' $((RANDOM % 256))
}

_location() {
  tput cup $(($RANDOM%$(tput lines))) $(($RANDOM%$(tput cols)))
}

_stop() {
  tput cnorm # yes cursor
  echo
  exit 0
}

clear

tput civis # no cursor

while true; do
  _location
  printf '%s█%s' "$(_color)" $'\e[0m'
  sleep "$SLEEPY_TIME"
done
