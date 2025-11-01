#!/usr/bin/env bats

load "$BATS_TEST_DIRNAME/test_libs/bats-support-0.3.0/load.bash"
load "$BATS_TEST_DIRNAME/test_libs/bats-assert-2.2.0/load.bash"

SCRIPT="$BATS_TEST_DIRNAME/../gallery/stars/stars.sh"

@test "stars: should be executable" {
  assert [ -x "$SCRIPT" ]
}

@test "stars: runs without errors for 1 second" {
  run timeout 1s "$SCRIPT"
  assert_success
}
