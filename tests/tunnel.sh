#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

SCRIPT="../gallery/tunnel/tunnel.sh"

@test "tunnel: should be executable" {
  assert [ -x "$SCRIPT" ], "$SCRIPT is not executable"
}

@test "tunnel: runs without errors for 1 second" {
  run timeout 1s "$SCRIPT"
  assert_success
}
