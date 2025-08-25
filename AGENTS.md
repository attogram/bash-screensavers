# 🤖 Agent Instructions

This file contains instructions for AI agents on how to interact with and contribute to this repository.

## 📜 General Agent Guidance

This section outlines the universal rules and expectations for any AI agent working within this repository.

* **Safety and Quality First:** The highest priority is to produce secure, well-documented, and high-quality code. Do not introduce vulnerabilities, hardcoded secrets, or unreadable code.

* **Propose a Plan:** For any new task, first provide a brief plan of action. This plan should clearly outline the intended changes and the rationale behind them.

* **Maintain Context:** Before making any changes, an agent must read and understand the relevant files, including the project's main documentation and existing code structure.

* **Clear Contributions:** All contributions must be submitted via a pull request with a clear, concise commit message and a brief description of the changes.

### Project-Specific Guidelines

* **Bash Compatibility:** The `screensaver.sh` script must be compatible with **Bash v3.2**. Individual screensavers can use newer features, but it's best practice to stick to v3.2 if possible. All scripts should be cross-platform, working on macOS, Linux, WSL, and Cygwin.

* **Screen Handling:** Use `tput` for all screen manipulations (e.g., cursor movement, colors, clearing the screen) to ensure portability. Use `tput setaf` and `tput setab` for colors.

* **Project Structure:**

  * `screensaver.sh`: The main entry point that displays the screensaver menu.

  * `gallery/`: Contains each screensaver as a subdirectory.

  * `spotlight/`: Helper scripts, such as `smile-for-the-camera.sh`.

  * `jury/`: The `bats` test suite.

* **General Tips:**

  * **Cleanup:** Always use `trap` to restore the terminal state upon exit (show cursor, reset colors).

  * **Subshells:** The main `screensaver.sh` script runs each screensaver in a subshell to prevent accidental menu exit.

  * **Tools:** The `asciinema` and `agg` tools are used to generate animated GIFs for the gallery.

### Testing

* **Framework:** The test suite uses the `bats` testing framework.

* **Running Tests:** The tests should be run from the root of the repository using the command `bats tests`.

* **Assertions:** Since screensavers run indefinitely, use `timeout` and check for the expected non-zero exit code with `assert_failure`, not `assert_success`.

* **Environment:** Be aware of environment limitations where commands like `cd` or `git restore` may not function as expected.
