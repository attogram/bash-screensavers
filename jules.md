# Jules's Guide to the Bash Screensavers Galaxy

This document provides some specific knowledge required for working on this screensavers repository.

## Bash Compatibility

- **Bash v3.2 is the target**: The main `screensaver.sh` script must be compatible with Bash v3.2. This is to ensure it runs on a wide variety of systems, including older macOS versions.
- **Individual screensavers**: Individual screensavers can use newer bash features, but it's good practice to stick to v3.2 if possible.
- **Cross-platform**: All scripts should be written to be cross-platform, working on macOS, Linux, WSL, Cygwin, etc. Avoid using platform-specific commands without fallbacks.

## Screen Handling

- **`tput` is your friend**: Use `tput` for all screen manipulations, such as moving the cursor, changing colors, and clearing the screen. This ensures that the scripts are portable across different terminal types.
- **Colors**: Use `tput setaf` (foreground) and `tput setab` (background) for colors. The standard 8-color palette is the most portable.
- **Animations**: Animations are created by a loop of clearing the screen (or parts of it), drawing the next frame, and then sleeping for a short period. `sleep 0.1` is a common choice.

## `asciinema` and `agg`

- **`asciinema`**: This tool is used to record terminal sessions as `.cast` files. These are JSON files that store the timing and data of the terminal output.
- **`agg`**: This tool is used to convert `.cast` files into animated GIFs.
- **`tools/smile-for-the-camera.sh`**: This script uses `asciinema` and `agg` to generate the GIFs for each screensaver in the `gallery`.

## Project Structure

- **`screensaver.sh`**: The main entry point. It displays a menu of screensavers and runs the chosen one.
- **`gallery/`**: Each subdirectory in `gallery/` is a screensaver.
  - `<name>/<name>.sh`: The main script for the screensaver.
  - `<name>/config.sh`: Metadata for the screensaver (name, tagline, etc.).
- **`tools/`**: Contains helper scripts, like `smile-for-the-camera.sh`.
- **`tests/`**: Contains the `bats` test suite.

## General Tips

- **Cleanup is crucial**: Always use `trap` to ensure that the terminal is restored to a usable state when the user presses `Ctrl+C`. This includes showing the cursor again (`tput cnorm`), resetting colors (`tput sgr0`), and clearing the screen.
- **Subshells for safety**: The main `screensaver.sh` script runs each screensaver in a subshell. This is to prevent the screensaver from accidentally exiting the main menu.
- **Have fun**: The goal of this project is to create fun and interesting screensavers. Don't be afraid to get creative!

## Testing

The tests for this project are written using the `bats` testing framework. Here are some key things to know about the test suite:

- **Dependencies**: The tests require `bats`, `bats-support`, and `bats-assert`. These are not checked in to the repository and need to be installed. I have found that cloning them with `git` can be unreliable in this environment. It is better to download the release tarballs and extract them.
- **Test Structure**: The main test file is `tests/tests.bats`. It is responsible for testing the main `screensaver.sh` script. There are also individual test files for each screensaver in the `tests` directory.
- **Running Tests**: The tests should be run from the root of the repository using the command `bats tests`. This will execute all the `.bats` files in the `tests` directory.
- **Paths**: The test scripts are written with the assumption that they are being run from the root of the repository. All paths in the test files should be relative to the root.
- **`timeout` and Assertions**: Many of the tests use `timeout` to run the screensavers for a short period. Since the screensavers are designed to run indefinitely, `timeout` will kill them, resulting in a non-zero exit code. Therefore, the tests should use `assert_failure` to check for this expected failure, not `assert_success`.
- **Environment Limitations**: The testing environment can be restrictive. Commands like `cd`, `pwd`, and `git restore` may not work as expected. It's important to be aware of these limitations and find workarounds when necessary.

---

# Jules's Learnings on `tour-the-gallery.sh`

This document summarizes the issues I encountered and the solutions I implemented while debugging the `tools/tour-the-gallery.sh` script.

## Key Issues and Resolutions

1.  **Non-Standard Timeout Function:**
    *   **Issue:** The script initially used a custom `run_with_timeout` function which was not accessible within the subshell created by `asciinema rec`, causing recording failures.
    *   **Resolution:** I replaced the custom function with the standard Linux `timeout` command for better portability and reliability.

2.  **Hidden Dependency (`bc`):**
    *   **Issue:** The `speaky.sh` screensaver failed because it depends on the `bc` command-line calculator, which was not installed in the environment.
    *   **Resolution:** I identified and installed the `bc` package to satisfy the dependency.

3.  **Unsupported `asciinema` Subcommand:**
    *   **Issue:** The script used the `asciinema cut` subcommand, which is not available in the version of `asciinema` present in the execution environment.
    *   **Resolution:** I refactored the recording logic. Instead of recording a long 10-second clip and cutting a 3-second snippet, the script now directly records a 3-second snippet after a 3-second pause (`sleep 3; timeout 3s ...`), eliminating the need for the `cut` command.

4.  **Interactive Scripts in Non-Interactive Environment:**
    *   **Issue:** Several screensavers (e.g., `cutesaver.sh`, `life.sh`) used interactive `read` commands to pause between frames or wait for user input. This caused the main script to hang indefinitely.
    *   **Resolution:** I replaced the interactive `read` commands in the affected screensavers with non-interactive `sleep` commands.

## Unresolved Issues & Final State

*   **Persistent Timeouts:** Despite the fixes above, the `tour-the-gallery.sh` script continues to time out during the final step of converting the concatenated `.cast` file into a `.gif` using the `agg` command.
*   **Hypothesis:** The timeout is likely caused by one of two things:
    1.  The `agg` command is extremely slow when processing the large, concatenated `overview.cast` file.
    2.  One of the screensavers is still producing a subtly malformed `.cast` file that isn't caught by the validation logic, causing `agg` to hang or fail silently (by creating an empty GIF).
*   **Final Actions:** As requested, I have stopped further debugging. The codebase contains all the fixes I've implemented. I have also added extensive logging to `tour-the-gallery.sh` and disabled the cleanup of temporary files to aid in future debugging efforts.
