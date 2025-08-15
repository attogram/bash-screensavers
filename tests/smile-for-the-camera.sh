#!/usr/bin/env bats

setup() {
    SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    SCRIPT="$SCRIPT_DIR/../tools/smile-for-the-camera.sh"
    chmod +x "$SCRIPT"

    BATS_TMPDIR=$(mktemp -d -t bats-smile-XXXXXX)
    export PATH="$BATS_TMPDIR:$PATH"

    # Create dummy gallery
    mkdir -p "$BATS_TMPDIR/gallery/testsaver"
    echo "echo hello" > "$BATS_TMPDIR/gallery/testsaver/testsaver.sh"
    chmod +x "$BATS_TMPDIR/gallery/testsaver/testsaver.sh"

    # Run the script from the temp dir
    cd "$BATS_TMPDIR" || exit 1
}

teardown() {
    cd - > /dev/null || exit 1
    rm -rf "$BATS_TMPDIR"
}

@test "smile-for-the-camera: exits if asciinema is not found" {
    # agg is available, asciinema is not
    touch "$BATS_TMPDIR/agg" && chmod +x "$BATS_TMPDIR/agg"

    run "$SCRIPT"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: asciinema not found"* ]]
}

@test "smile-for-the-camera: exits if agg is not found" {
    # asciinema is available, agg is not
    touch "$BATS_TMPDIR/asciinema" && chmod +x "$BATS_TMPDIR/asciinema"

    run "$SCRIPT"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: agg not found"* ]]
}

@test "smile-for-the-camera: creates cast and gif files" {
    # Mock dependencies
    cat > "$BATS_TMPDIR/asciinema" <<EOF
#!/bin/bash
touch "\$4" # Create the .cast file
EOF
    chmod +x "$BATS_TMPDIR/asciinema"

    cat > "$BATS_TMPDIR/agg" <<EOF
#!/bin/bash
touch "\$2" # Create the .gif file
EOF
    chmod +x "$BATS_TMPDIR/agg"

    run "$SCRIPT"

    [ "$status" -eq 0 ]
    [ -f "gallery/testsaver/testsaver.cast" ]
    [ -f "gallery/testsaver/testsaver.gif" ]
}
