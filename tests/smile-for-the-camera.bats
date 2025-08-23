#!/usr/bin/env bats

setup() {
    SCRIPT="tools/smile-for-the-camera.sh"
    chmod +x "$SCRIPT"

    BATS_TMPDIR=$(mktemp -d -t bats-smile-XXXXXX)
    export PATH="$BATS_TMPDIR:$PATH"

    # Create dummy gallery
    mkdir -p "gallery/testsaver"
    echo "echo hello" > "gallery/testsaver/testsaver.sh"
    chmod +x "gallery/testsaver/testsaver.sh"
}

teardown() {
    rm -rf "$BATS_TMPDIR"
    rm -rf "gallery/testsaver"
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
#!/usr/bin/env bash
touch "\$4" # Create the .cast file
EOF
    chmod +x "$BATS_TMPDIR/asciinema"

    cat > "$BATS_TMPDIR/agg" <<EOF
#!/usr/bin/env bash
touch "\$2" # Create the .gif file
EOF
    chmod +x "$BATS_TMPDIR/agg"

    run "$SCRIPT"

    [ "$status" -eq 0 ]
    [ -f "gallery/testsaver/testsaver.cast" ]
    [ -f "gallery/testsaver/testsaver.gif" ]
}
