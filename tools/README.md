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
