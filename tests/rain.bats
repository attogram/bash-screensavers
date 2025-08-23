#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

SCRIPT="gallery/rain/rain.sh"

@test "rain: should be executable" {
  assert [ -x "$SCRIPT" ]
}

@test "rain: runs without errors for 1 second" {
  run timeout 1s "$SCRIPT"
  assert_success
}
