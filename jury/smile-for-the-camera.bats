#!/usr/bin/env bats

setup() {
    SCRIPT="spotlight/smile-for-the-camera.sh"
    chmod +x "$SCRIPT"

    # Add jury directory to PATH to use mock scripts
    export PATH="$(pwd)/jury:$PATH"

    # Create dummy gallery
    mkdir -p "gallery/testsaver"
    echo "echo hello" > "gallery/testsaver/testsaver.sh"
    chmod +x "gallery/testsaver/testsaver.sh"

    # Ensure the real cast/gif files don't exist
    rm -f "gallery/testsaver/testsaver.cast"
    rm -f "gallery/testsaver/testsaver.gif"
}

teardown() {
    rm -rf "gallery/testsaver"
}

@test "smile-for-the-camera: (all) creates cast and gif files" {
    run "$SCRIPT"

    [ "$status" -eq 0 ]
    [ -f "gallery/testsaver/testsaver.cast" ]
    [ -f "gallery/testsaver/testsaver.gif" ]

    # Check content of mock files
    [[ "$(cat gallery/testsaver/testsaver.cast)" == *'mock asciinema recording'* ]]
    [[ "$(cat gallery/testsaver/testsaver.gif)" == "mock gif" ]]
}

@test "smile-for-the-camera: (single) creates cast and gif files" {
    run "$SCRIPT" "gallery/testsaver"

    [ "$status" -eq 0 ]
    [ -f "gallery/testsaver/testsaver.cast" ]
    [ -f "gallery/testsaver/testsaver.gif" ]

    # Check content of mock files
    [[ "$(cat gallery/testsaver/testsaver.cast)" == *'mock asciinema recording'* ]]
    [[ "$(cat gallery/testsaver/testsaver.gif)" == "mock gif" ]]
}

@test "smile-for-the-camera: (single) errors on invalid directory" {
    run "$SCRIPT" "gallery/nonexistent"

    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: Directory not found"* ]]
}
