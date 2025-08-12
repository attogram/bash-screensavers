#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

@test "displays usage and lists screensavers" {
  run ../screensaver.sh
  assert_success
  assert_output --partial "Bash Screensavers v0.0.2"
  assert_output --partial "1. alpha"
  assert_output --partial "9. tunnel"
}

@test "handles invalid numeric input" {
  run ../screensaver.sh <<< "99"
  assert_failure
  assert_output --partial "Invalid choice"
}

@test "handles invalid string input" {
  run ../screensaver.sh <<< "invalid_screensaver"
  assert_failure
  assert_output --partial "Invalid choice"
}

@test "runs a screensaver by number" {
  run timeout 1s ../screensaver.sh <<< "1"
  assert_success
}

@test "runs a screensaver by name" {
  run timeout 1s ../screensaver.sh <<< "matrix"
  assert_success
}
