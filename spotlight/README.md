# Tools

This directory contains scripts for managing and maintaining the screensaver gallery.

## `install-all-the-stuff.sh`

This script installs the necessary dependencies for the other tools. It can install `asciinema` and `agg` on macOS, Debian/Ubuntu, Arch Linux, and other Linux distributions.

**Usage:**
```bash
./tools/install-all-the-stuff.sh
```

## `smile-for-the-camera.sh`

This script generates an animated GIF preview for each screensaver in the `gallery`. It uses `asciinema` to record a short session of each screensaver and `agg` to convert the recording into a GIF.

**Usage:**
```bash
./tools/smile-for-the-camera.sh
```
The generated GIFs will be saved in the respective screensaver's directory (e.g., `gallery/alpha/alpha.gif`).

## `tour-the-gallery.sh`

This script creates an overview of all the screensavers in the gallery. It records a short snippet of each screensaver and then concatenates them into a single `overview.cast` file and a corresponding `overview.gif` file in the root directory.

**Usage:**
```bash
./tools/tour-the-gallery.sh
```

## `spread-the-word.sh`

This script generates a series of shell commands to create a "spotlight" message on the main GitHub repository page. It does this by generating commands that make trivial changes to a dynamic list of prominent files and then commits those changes with custom messages.

**Usage:**

1.  **Customize the message:** Edit the `spotlight/message.txt` file. The script will use one line from this file for each commit message. Emojis and UTF-8 characters are welcome!

    You can use the following template variables in your messages:
    - `{user}`: Your Git user name.
    - `{repo}`: The name of the repository.
    - `{project_name}`: The project name (`Bash Screensavers`).
    - `{version}`: The current version of the project.
    - `{tag}`: The latest Git tag.
    - `{date}`: The current date (YYYY-MM-DD).
    - `{branch}`: The current Git branch.
    - `{screensaver_count}`: The total number of screensavers.
    - `{random_emoji}`: A random emoji from a predefined list.
    - `{random_emoji_face}`: A random emoji face.

2.  **Generate the commands:** Run the script from the root of the repository:
    ```bash
    ./spotlight/spread-the-word.sh
    ```
3.  **Run the commands:** The script will output a series of shell commands. These commands will first modify the files, and then use `git add` and `git commit` to commit the changes. Review them, and if they look correct, copy and paste them into your terminal to execute them.
 
 
 
 
 
 
 
 
 
 
 
 
