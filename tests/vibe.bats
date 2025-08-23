#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

SCRIPT="gallery/vibe/vibe.sh"

@test "vibe: should be executable" {
  assert [ -x "$SCRIPT" ]
}

@test "vibe: runs without errors for 1 second" {
  run timeout 1s "$SCRIPT"
  assert_success
}
