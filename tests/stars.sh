#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

SCRIPT="../gallery/stars/stars.sh"

@test "stars: should be executable" {
  assert [ -x "$SCRIPT" ], "$SCRIPT is not executable"
}

@test "stars: runs without errors for 1 second" {
  run timeout 1s "$SCRIPT"
  assert_success
}
