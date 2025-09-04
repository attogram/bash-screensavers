#!/usr/bin/env bats

load 'test_libs/bats-support-0.3.0/load.bash'
load 'test_libs/bats-assert-2.2.0/load.bash'

setup() {
    # Get the repo root, which is the current working directory for the test runner
    REPO_ROOT=$(pwd)

    # Backup the original message file if it exists
    [ -f spotlight/message.txt ] && mv spotlight/message.txt spotlight/message.txt.bak

    # Create a consistent message file for testing
    # Pad with enough lines for the test
    cat > spotlight/message.txt <<EOF
Hello {user}! This is {project_name} v{version} in the {repo} repo.
Today is {date}. The latest tag is {tag}.
We have {screensaver_count} screensavers.
This is for the {branch} branch. {random_emoji}
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
This is a test message.
EOF
}

teardown() {
    # Clean up the test message file and restore the original
    rm -f spotlight/message.txt
    [ -f spotlight/message.txt.bak ] && mv spotlight/message.txt.bak spotlight/message.txt
    unset SPREAD_THE_WORD_USER
    unset SPREAD_THE_WORD_REPO
    unset SPREAD_THE_WORD_PROJECT_NAME
    unset SPREAD_THE_WORD_VERSION
}

@test "generates output with variable substitution" {
    export SPREAD_THE_WORD_USER="Test User"
    export SPREAD_THE_WORD_REPO="test-repo"
    export SPREAD_THE_WORD_PROJECT_NAME="Test Project"
    export SPREAD_THE_WORD_VERSION="1.2.3"
    run ./spotlight/spread-the-word.sh
    assert_success
    assert_output --partial "git commit -m \"Hello Test User! This is Test Project v1.2.3 in the test-repo repo.\""
}

@test "generates output with random emoji face" {
    run ./spotlight/spread-the-word.sh
    assert_success
    # Just check that a commit message is generated, not the specific emoji
    assert_output --partial "git commit -m"
}

@test "generates commands for multiple targets" {
    run ./spotlight/spread-the-word.sh
    assert_success
    local count=0
    for line in "${lines[@]}"; do
        if [[ "$line" == *"git commit"* ]]; then
            count=$((count + 1))
        fi
    done
    assert_operator "$count" -gt "1"
}

@test "errors if message file is missing" {
    rm spotlight/message.txt
    run ./spotlight/spread-the-word.sh
    assert_failure
    assert_output --partial "Message file not found"
}

@test "errors if message file has too few lines" {
    # Create a message file with only 1 line, which should be too few.
    echo "this is not enough" > spotlight/message.txt

    run ./spotlight/spread-the-word.sh
    assert_failure
    assert_output --partial "Not enough messages"
}
