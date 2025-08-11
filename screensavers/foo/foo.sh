#!/usr/bin/env bash
#
# foo screensaver
#

SLEEPY_TIME="0.30" # Number of seconds of sleepy time between foo-ness

trap foo_stop SIGINT # Trap CONTROL-C

foo_color() {
  printf '\e[38;5;%dm' $((RANDOM % 256))
}

foo_location() {
  tput cup $(($RANDOM%$(tput lines))) $(($RANDOM%$(tput cols)))
}

foo_stop() {
  tput cnorm # yes cursor
  echo
  exit 0
}

clear

tput civis # no cursor

while true; do
  foo_location
  printf '%s█%s' "$(foo_color)" $'\e[0m'
  sleep "$SLEEPY_TIME"
done
