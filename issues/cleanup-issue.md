# Issue: Incorrect Terminal State After Screensaver Exit

## Description

The `cleanup` function in several of the existing screensavers does not fully restore the terminal to its original state after the screensaver exits via `Ctrl+C`.

Specifically, scripts like `matrix.sh` and `rain.sh` set a terminal background color at the start of the animation but the `cleanup` function only resets terminal attributes (`tput sgr0` or `printf '\e[0m'`) and restores the cursor. It does not clear the screen or the background color setting.

This results in the user's terminal being left with a modified background color after the screensaver has finished.

## Affected Files

- `screensavers/matrix/matrix.sh`
- `screensavers/rain/rain.sh`
- Potentially other screensavers in the collection.

## Recommended Fix

The `cleanup` function in each affected script should be updated to include a `clear` command. This will ensure the screen is cleared and all terminal attributes, including background color, are reset to the default.

Example of a corrected `cleanup` function:

```bash
cleanup() {
    clear # Clear the screen
    tput cnorm # Restore cursor
    printf '%s' "$RESET" # Reset colors (optional after clear, but good for safety)
    echo
    exit 0
}
```
