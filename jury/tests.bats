#!/usr/bin/env bats

load 'test_libs/bats-support-0.3.0/load.bash'
load 'test_libs/bats-assert-2.2.0/load.bash'

@test "displays usage and lists screensavers" {
  run ./screensaver.sh
  assert_success
  assert_output --partial "Bash Screensavers"
  assert_output --partial "1. alpha"
  assert_output --partial "10. tunnel"
}

@test "handles invalid numeric input by showing error and menu again" {
  run timeout 3s ./screensaver.sh <<< "99"
  assert_failure # It will be killed by timeout, so it's a failure
  assert_output --partial "Oops, invalid input!"
  assert_output --partial "Choose your screensaver:" # Check that menu is shown again
}

@test "handles invalid string input by showing error and menu again" {
  run timeout 3s ./screensaver.sh <<< "invalid_screensaver"
  assert_failure # It will be killed by timeout, so it's a failure
  assert_output --partial "Oops, invalid input!"
  assert_output --partial "Choose your screensaver:" # Check that menu is shown again
}

@test "runs a screensaver by number" {
  run timeout 1s ./screensaver.sh <<< "1"
  assert_failure
}

@test "runs a screensaver by name" {
  run timeout 1s ./screensaver.sh <<< "matrix"
  assert_failure
}

@test "runs a screensaver by number with leading zeros" {
  run timeout 1s ./screensaver.sh <<< "01"
  assert_failure
}

@test "displays help message with -h" {
  run ./screensaver.sh -h
  assert_success
  assert_output --partial "Usage: ./screensaver.sh"
}

@test "displays help message with --help" {
  run ./screensaver.sh --help
  assert_success
  assert_output --partial "Usage: ./screensaver.sh"
}

@test "displays version with -v" {
  run ./screensaver.sh -v
  assert_success
  assert_output --partial "Bash Screensavers v"
}

@test "displays version with --version" {
  run ./screensaver.sh --version
  assert_success
  assert_output --partial "Bash Screensavers v"
}

@test "handles invalid option" {
  run ./screensaver.sh --invalid-option
  assert_failure
  assert_output --partial "Error: invalid screensaver"
}

@test "runs a screensaver directly by name" {
  run timeout 1s ./screensaver.sh matrix
  assert_failure
}

@test "runs a screensaver directly by number" {
  run timeout 1s ./screensaver.sh 1
  assert_failure
}

@test "runs a random screensaver with -r" {
  run timeout 1s ./screensaver.sh -r
  assert_failure
}

@test "runs a random screensaver with --random" {
  run timeout 1s ./screensaver.sh --random
  assert_failure
}

@test "runs a random screensaver with r from menu" {
  run timeout 1s ./screensaver.sh <<< "r"
  assert_failure
}

@test "runs a random screensaver with random from menu" {
  run timeout 1s ./screensaver.sh <<< "random"
  assert_failure
}
