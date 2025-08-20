#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "displays usage and lists screensavers" {
  run ../screensaver.sh
  assert_success
  assert_output --partial "Bash Screensavers"
  assert_output --partial "1. alpha"
  assert_output --partial "10. tunnel"
}

@test "handles invalid numeric input by showing error and menu again" {
  run timeout 3s ../screensaver.sh <<< "99"
  assert_failure # It will be killed by timeout, so it's a failure
  assert_output --partial "Invalid choice"
  assert_output --partial "Choose your screensaver:" # Check that menu is shown again
}

@test "handles invalid string input by showing error and menu again" {
  run timeout 3s ../screensaver.sh <<< "invalid_screensaver"
  assert_failure # It will be killed by timeout, so it's a failure
  assert_output --partial "Invalid choice"
  assert_output --partial "Choose your screensaver:" # Check that menu is shown again
}

@test "runs a screensaver by number" {
  run timeout 1s ../screensaver.sh <<< "1"
  assert_success
}

@test "runs a screensaver by name" {
  run timeout 1s ../screensaver.sh <<< "matrix"
  assert_success
}

# --- Load and run tests for speaky screensaver ---
load 'speaky.sh'

# --- Load and run tests for other screensavers ---
load 'alpha.sh'
load 'bouncing.sh'
load 'cutesaver.sh'
load 'fireworks.sh'
load 'matrix.sh'
load 'pipes.sh'
load 'rain.sh'
load 'stars.sh'
load 'tunnel.sh'
load 'vibe.sh'
