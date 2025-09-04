#!/usr/bin/env bats

load 'test_libs/bats-support-0.3.0/load.bash'
load 'test_libs/bats-assert-2.2.0/load.bash'

SCRIPT="gallery/fireworks/fireworks.sh"

@test "fireworks: should be executable" {
  assert [ -x "$SCRIPT" ]
}

@test "fireworks: should have a shebang" {
  run grep -q "#!/usr/bin/env bash" "$SCRIPT"
  assert_success
}
