#!/usr/bin/env bats

load 'test_libs/bats-support-0.3.0/load.bash'
load 'test_libs/bats-assert-2.2.0/load.bash'

setup() {
    source "$(dirname "$BATS_TEST_FILENAME")/../library/library-of-voices.sh"
}

@test "library-of-voices: can be sourced" {
    run type lov_detect_engine
    assert_output --partial "is a function"
}

@test "library-of-voices: lov_detect_engine function exists" {
    run type lov_detect_engine
    assert_output --partial "is a function"
}

@test "library-of-voices: lov_say function exists" {
    run type lov_say
    assert_output --partial "is a function"
}

@test "library-of-voices: lov_kill_speech function exists" {
    run type lov_kill_speech
    assert_output --partial "is a function"
}

@test "library-of-voices: lov_detect_engine sets a TTS engine" {
    lov_detect_engine
    # This test might fail in a very minimal environment.
    # We will check that the variable is not empty.
    assert [ -n "$LOV_TTS_ENGINE" ]
}
