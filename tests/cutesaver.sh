#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

SCRIPT="../gallery/cutesaver/cutesaver.sh"

@test "cutesaver: main script should be executable" {
  assert [ -x "$SCRIPT" ], "$SCRIPT is not executable"
}

@test "cutesaver: runs without errors for 1 second" {
  run timeout 1s "$SCRIPT"
  assert_success
}
