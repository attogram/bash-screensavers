#!/usr/bin/env bats

load 'test_libs/bats-support-0.3.0/load.bash'
load 'test_libs/bats-assert-2.2.0/load.bash'

setup() {
    # Get the repo root, which is the current working directory for the test runner
    REPO_ROOT=$(pwd)

    # Backup the original message file if it exists
    [ -f spotlight/message.txt ] && mv spotlight/message.txt spotlight/message.txt.bak

    # Create a consistent message file for testing
    cat > spotlight/message.txt <<EOF
LINE 1
LINE 2
LINE 3
LINE 4
LINE 5
LINE 6
LINE 7
LINE 8
LINE 9
LINE 10
LINE 11
LINE 12
LINE 13
LINE 14
EOF
}

teardown() {
    # Clean up the test message file and restore the original
    rm -f spotlight/message.txt
    [ -f spotlight/message.txt.bak ] && mv spotlight/message.txt.bak spotlight/message.txt
}

@test "generates output" {
    run ./spotlight/spread-the-word.sh
    assert_success
    assert_output --partial "git commit"
}

@test "generates commands for all 14 targets" {
    run ./spotlight/spread-the-word.sh
    assert_success
    local count=0
    for line in "${lines[@]}"; do
        if [[ "$line" == *"git commit"* ]]; then
            count=$((count + 1))
        fi
    done
    assert_equal "$count" "14"
}

@test "generates expected first command with absolute paths" {
    run ./spotlight/spread-the-word.sh
    assert_success
    assert_output --partial "# Trivial commit logic for '/app/.github/workflows/create.release.for.tag.yml'"
    assert_output --partial "trailing_lines=\$(awk 'BEGIN{c=0} {if (\$0 ~ /[^[:space:]]/) {c=0} else {c++}} END{print c}'"
    assert_output --partial "git add \"/app/.github/workflows/create.release.for.tag.yml\""
    assert_output --partial "git commit -m \"LINE 1\""
}

@test "errors if message file is missing" {
    rm spotlight/message.txt
    run ./spotlight/spread-the-word.sh
    assert_failure
    assert_output --partial "Message file not found"
}

@test "errors if message file has too few lines" {
    # Create a message file with only 11 lines
    head -n 11 spotlight/message.txt > spotlight/message.txt.short
    mv spotlight/message.txt.short spotlight/message.txt
    run ./spotlight/spread-the-word.sh
    assert_failure
    assert_output --partial "Not enough messages"
}
