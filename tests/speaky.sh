#!/usr/bin/env bats

setup() {
    SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    SCRIPT="$SCRIPT_DIR/../gallery/speaky/speaky.sh"

    BATS_TMPDIR=$(mktemp -d -t bats-speaky-XXXXXX)
    export PATH="$BATS_TMPDIR:$PATH"
    export MOCK_LOG="$BATS_TMPDIR/mock.log"
    touch "$MOCK_LOG"
}

teardown() {
    rm -rf "$BATS_TMPDIR"
}

@test "speaky: tts_get_voices_say populates SAY_VOICES" {
    cat > "$BATS_TMPDIR/say" <<EOF
#!/usr/bin/env bash
if [[ "\$1" == "-v" && "\$2" == "?" ]]; then
    echo "Alex                en_US    # Most people recognize me by my voice."
    echo "Fred                en_US    # I sure like being inside this fancy computer."
fi
EOF
    chmod +x "$BATS_TMPDIR/say"

    # Source the script in a subshell to isolate it
    . "$SCRIPT"

    tts_get_voices_say

    [ "${#SAY_VOICES[@]}" -eq 2 ]
    [ "${SAY_VOICES[0]}" = "Alex" ]
    [ "${SAY_VOICES[1]}" = "Fred" ]
}

@test "speaky: say_txt uses a random voice if available" {
    cat > "$BATS_TMPDIR/say" <<EOF
#!/usr/bin/env bash
echo "say called with: \$@" >> "$MOCK_LOG"
EOF
    chmod +x "$BATS_TMPDIR/say"

    . "$SCRIPT"

    SAY_VOICES=("Alex" "Fred")
    TTS_ENGINE="say"

    say_txt "hello world"

    sleep 0.1

    run cat "$MOCK_LOG"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "say called with: -v (Alex|Fred) hello world" ]]
}

@test "speaky: say_txt works normally if no voices are found" {
    cat > "$BATS_TMPDIR/say" <<EOF
#!/usr/bin/env bash
echo "say called with: \$@" >> "$MOCK_LOG"
EOF
    chmod +x "$BATS_TMPDIR/say"

    . "$SCRIPT"

    SAY_VOICES=()
    TTS_ENGINE="say"

    say_txt "hello world"

    sleep 0.1

    run cat "$MOCK_LOG"
    [ "$status" -eq 0 ]
    [ "$output" = "say called with: hello world" ]
}
