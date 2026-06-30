#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/mrodriguezdev/dotfiles.git"

WORKDIR="$(mktemp -d)"
SRC_DIR="$WORKDIR/dotfiles"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

cleanup() {
    rm -rf "$WORKDIR"
}

trap cleanup EXIT

backup() {
    local file="$1"

    [[ ! -e "$file" || -L "$file" ]] && return

    local timestamp
    timestamp="$(date +%Y%m%d_%H%M%S)"

    echo "Backing up $file"
    mv "$file" "${file}.bak.${timestamp}"
}

clone_if_missing() {
    local repo="$1"
    local destination="$2"

    [[ -d "$destination" ]] && return

    git clone --depth=1 "$repo" "$destination"
}

if ! command -v pacman >/dev/null 2>&1; then
    echo "This bootstrap only supports Arch Linux."
    exit 1
fi

echo "Installing dependencies..."

sudo pacman -S --needed --noconfirm \
    git \
    zsh \
    curl \
    rsync \
    eza \
    bat \
    fd \
    ripgrep \
    fzf \
    zoxide \
    fastfetch \
    ttf-hack-nerd

echo "Backing up existing configuration..."

backup "$HOME/.zshrc"
backup "$HOME/.zsh"
backup "$HOME/.p10k.zsh"
backup "$HOME/.oh-my-zsh"

echo "Installing Oh My Zsh..."

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git \
        "$HOME/.oh-my-zsh"
fi

echo "Cloning dotfiles..."

git clone --depth=1 "$REPO_URL" "$SRC_DIR"

if [[ ! -d "$SRC_DIR/home" ]]; then
    echo "The repository does not contain a 'home/' directory."
    exit 1
fi

echo "Installing dotfiles..."

rsync -a "$SRC_DIR/home/" "$HOME/"

echo "Installing Powerlevel10k..."

clone_if_missing \
    https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"

echo "Installing Oh My Zsh plugins..."

clone_if_missing \
    https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_if_missing \
    https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

clone_if_missing \
    https://github.com/zsh-users/zsh-completions \
    "$ZSH_CUSTOM/plugins/zsh-completions"

echo "Configuring Zsh as the default shell..."

ZSH_BIN="$(command -v zsh)"

if [[ "$SHELL" != "$ZSH_BIN" ]]; then
    if chsh -s "$ZSH_BIN"; then
        echo "Default shell changed to Zsh."
    else
        echo
        echo "Unable to change the default shell automatically."
        echo "Run the following command manually:"
        echo
        echo "    chsh -s $ZSH_BIN"
    fi
fi

echo
echo "Installation completed successfully."
echo
echo "Restart your terminal or log out and back in to start using your new configuration."