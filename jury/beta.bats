#!/usr/bin/env bats

load 'test_libs/bats-support-0.3.0/load.bash'
load 'test_libs/bats-assert-2.2.0/load.bash'

@test "beta: should be executable" {
  assert [ -x "./gallery/beta/beta.sh" ]
}

@test "beta: should have a shebang" {
  run grep -q "#!/usr/bin/env bash" "./gallery/beta/beta.sh"
  assert_success
}
