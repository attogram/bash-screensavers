#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

SCRIPT_UNDER_TEST="../gallery/speaky/speaky.sh"
ORIGINAL_SCRIPT=""

setup() {
    # Make sure the script is executable
    chmod +x "$SCRIPT_UNDER_TEST"
    # Save a copy of the original script
    ORIGINAL_SCRIPT=$(cat "$SCRIPT_UNDER_TEST")
}

teardown() {
    # Restore the original script from the saved content
    if [ -n "$ORIGINAL_SCRIPT" ]; then
        echo "$ORIGINAL_SCRIPT" > "$SCRIPT_UNDER_TEST"
    fi
}

@test "speaky: displays witty error when no TTS engine is found" {
    # Override the detect function to simulate no engine found
    # and make the error message predictable for the test
    perl -i -p0e 's/(tts_detect_engine\(\) \{)(.*?)(\n\})/$1\n    TTS_ENGINE=""\n    return\n$3/s' "$SCRIPT_UNDER_TEST"
    perl -i -pe "s/local phrase=\\\$\\{error_phrases\\[\\\$RANDOM % \\\$\\{#error_phrases\\[@\\]\\}\\]\\}/local phrase=\\\$\\{error_phrases[0]\\}/g" "$SCRIPT_UNDER_TEST"

    run "$SCRIPT_UNDER_TEST"
    assert_success
    assert_output --partial "I can't find any speaky speaky app"
}

@test "speaky: runs successfully with a simulated TTS engine" {
    # Override the detect function to simulate finding the 'say' engine
    perl -i -p0e 's/(tts_detect_engine\(\) \{)(.*?)(\n\})/$1\n    TTS_ENGINE="say"\n    return\n$3/s' "$SCRIPT_UNDER_TEST"
    # Override the say_txt function to just echo a marker instead of speaking
    perl -i -p0e 's/(say_txt\(\) \{)(.*?)(\n\})/$1\n    echo "[BATS_SUCCESS_MARKER]"\n    SPEAK_PID=$$ # Set a dummy PID\n$3/s' "$SCRIPT_UNDER_TEST"

    # Run the script but time it out to prevent it from running forever
    run timeout 1s "$SCRIPT_UNDER_TEST"

    # It might exit with a timeout status, which is fine for this test.
    # We just want to see if it started correctly.
    assert_output --partial "[BATS_SUCCESS_MARKER]"
}
