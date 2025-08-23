#!/usr/bin/env bash
#
# install-all-the-stuff.sh
#
# This script installs asciinema and agg on various platforms.
# It may require sudo privileges to install software.

set -e

# -----------------
# --- Functions ---
# -----------------

install_macos() {
    echo "macOS detected. Using Homebrew."
    if ! command -v brew &> /dev/null; then
        echo "Error: Homebrew is not installed. Please install it from https://brew.sh/"
        exit 1
    fi

    if ! command -v asciinema &> /dev/null; then
        echo "Installing asciinema..."
        brew install asciinema
    else
        echo "asciinema is already installed."
    fi

    if ! command -v agg &> /dev/null; then
        echo "Installing agg..."
        brew install agg
    else
        echo "agg is already installed."
    fi
}

install_debian_ubuntu() {
    echo "Debian/Ubuntu detected. Using apt-get."
    if ! command -v asciinema &> /dev/null; then
        echo "Installing asciinema..."
        sudo apt-get update
        sudo apt-get install -y asciinema
    else
        echo "asciinema is already installed."
    fi

    if ! command -v agg &> /dev/null; then
        echo "Installing agg from prebuilt binary..."
        install_agg_binary "unknown-linux-gnu"
    else
        echo "agg is already installed."
    fi
}

install_arch() {
    echo "Arch Linux detected. Using pacman."
    if ! command -v asciinema &> /dev/null || ! command -v agg &> /dev/null; then
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm asciinema agg
    else
        echo "asciinema and agg are already installed."
    fi
}

install_generic_linux() {
    echo "Generic Linux detected."
    if ! command -v asciinema &> /dev/null; then
        echo "Installing asciinema via pip..."
        if ! command -v pip &> /dev/null; then
            echo "Error: pip is not installed. Please install it."
            exit 1
        fi
        pip install --user asciinema
        echo "Please ensure ~/.local/bin is in your PATH."
    else
        echo "asciinema is already installed."
    fi

    if ! command -v agg &> /dev/null; then
        echo "Installing agg from prebuilt binary..."
        install_agg_binary "unknown-linux-gnu"
    else
        echo "agg is already installed."
    fi
}

install_linux() {
    echo "Linux detected."
    if [ ! -f /etc/os-release ]; then
        echo "Warning: Cannot determine Linux distribution (no /etc/os-release)."
        echo "Attempting generic installation."
        install_generic_linux
        return
    fi

    . /etc/os-release
    local distro
    distro=$ID

    if [[ "$distro" == "ubuntu" || "$distro" == "debian" ]]; then
        install_debian_ubuntu
    elif [[ "$distro" == "arch" ]]; then
        install_arch
    else
        echo "Unsupported Linux distribution: $distro"
        echo "Attempting generic installation."
        install_generic_linux
    fi
}

install_agg_binary() {
    local os_target_triple_part=$1
    local arch
    arch=$(uname -m)
    local agg_arch

    if [[ "$arch" == "x86_64" ]]; then
        agg_arch="x86_64"
    elif [[ "$arch" == "aarch64" ]]; then
        agg_arch="aarch64"
    else
        echo "Error: Unsupported architecture for agg binary: $arch"
        exit 1
    fi

    local agg_target_triple="${agg_arch}-${os_target_triple_part}"
    echo "Looking for agg binary for ${agg_target_triple}..."

    if ! command -v curl &> /dev/null; then
        echo "Error: curl is required to download the agg binary."
        exit 1
    fi

    local latest_release_url="https://api.github.com/repos/asciinema/agg/releases/latest"
    local agg_url
    agg_url=$(curl -s "$latest_release_url" | grep "browser_download_url" | grep "${agg_target_triple}" | cut -d '"' -f 4 | head -n 1)

    if [ -z "$agg_url" ]; then
        echo "Error: Could not find a prebuilt binary for your system."
        echo "Please install it manually from https://github.com/asciinema/agg/releases"
        exit 1
    fi

    echo "Downloading from $agg_url"
    local temp_dir
    temp_dir=$(mktemp -d)
    trap 'rm -rf "$temp_dir"' EXIT

    curl -L "$agg_url" -o "$temp_dir/agg_archive"

    local agg_executable
    if [[ "$agg_url" == *.tar.gz ]]; then
        if ! command -v tar &> /dev/null; then
            echo "Error: tar is required to extract the agg binary."
            exit 1
        fi
        tar -xzf "$temp_dir/agg_archive" -C "$temp_dir"
        agg_executable=$(find "$temp_dir" -type f -name "agg")
    elif [[ "$agg_url" == *.zip ]]; then
        if ! command -v unzip &> /dev/null; then
            echo "Error: unzip is required to extract the agg binary."
            exit 1
        fi
        unzip "$temp_dir/agg_archive" -d "$temp_dir"
        agg_executable=$(find "$temp_dir" -type f -name "agg.exe")
    else
        echo "Error: Unknown archive format for agg binary."
        exit 1
    fi

    if [ -z "$agg_executable" ]; then
        echo "Error: Could not find agg executable in the downloaded archive."
        exit 1
    fi

    chmod +x "$agg_executable"
    echo "Installing agg to /usr/local/bin/agg"
    if [[ $EUID -ne 0 ]]; then
      sudo mv "$agg_executable" "/usr/local/bin/agg"
    else
      mv "$agg_executable" "/usr/local/bin/agg"
    fi
}

install_cygwin() {
    echo "Cygwin detected."
    if ! command -v asciinema &> /dev/null; then
        echo "Installing asciinema via pip..."
        if ! command -v pip &> /dev/null; then
            echo "Error: pip is not installed. Please install it for your Cygwin Python environment."
            exit 1
        fi
        pip install asciinema
    else
        echo "asciinema is already installed."
    fi

    if ! command -v agg &> /dev/null; then
        echo "Installing agg from prebuilt binary for Windows..."
        install_agg_binary "pc-windows-msvc"
    else
        echo "agg is already installed."
    fi
}


# --------------
# --- Main ---
# --------------

main() {
    echo "Starting dependency installation..."

    local os
    os=$(uname)

    if [[ "$os" == "Darwin" ]]; then
        install_macos
    elif [[ "$os" == "Linux" ]]; then
        install_linux
    elif [[ "$os" == *"CYGWIN"* ]]; then
        install_cygwin
    else
        echo "Unsupported OS: $os"
        echo "Please install asciinema and agg manually."
        exit 1
    fi

    echo ""
    echo "All dependencies installed successfully!"
}

main "$@"
