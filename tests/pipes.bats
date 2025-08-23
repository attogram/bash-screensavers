#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

SCRIPT="gallery/pipes/pipes.sh"

@test "pipes: should be executable" {
  assert [ -x "$SCRIPT" ]
}

@test "pipes: runs without errors for 1 second" {
  run timeout 1s "$SCRIPT"
  assert_success
}
