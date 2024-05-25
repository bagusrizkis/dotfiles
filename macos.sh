#!/usr/bin/env bash

# Run: curl -o- https://raw.githubusercontent.com/bagusrizkis/dotfiles/main/macos.sh | bash

DOTFILES_DIR=~/dotfiles
REPO_URL="https://github.com/bagusrizkis/dotfiles.git"

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `macos.sh` has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

## Homebrew ##

which -s brew
if [[ $? != 0 ]]; then
    echo "Installing Hombrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homebrew"
    brew update
fi

brew_install() {
    echo "Installing $1"
    if brew list $1 &>/dev/null; then
        echo "${1} is already installed"
    else
        brew install $1 && echo "$1 is installed"
    fi
}

# - Install nvm and latest version node
brew_install nvm
nvm install --lts

# - Install Apps
brew_install neovim
brew_install ripgrep
brew_install fd
brew_install tree
brew_install git
# brew install tmux

# - Install GUI Apps
# brew_install --cask iterm2
# brew_install --cask visual-studio-code
# brew_install --cask another-redis-desktop-manager
# brew_install --cask docker
# brew_install --cask google-chrome
# brew_install --cask github-desktop

brew cleanup

## ZSH ##

which -s zsh
if [[ $? != 0 ]]; then
    echo "Installing zsh"
    # - Install ohmyzsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # - Plugin zsh-autosuggestion for zsh
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

## dotfiles ##
pushd .

if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles directory exists. Pulling the latest changes..."
    cd "$DOTFILES_DIR" && git pull
else
    echo "Dotfiles directory does not exist. Cloning the repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

popd

## NVIM ##
NVIM_DIR=~/.config/nvim
TARGET_LINK=~/dotfiles/.config/nvim

if [ -L "$NVIM_DIR" ]; then
    if [ "$(readlink "$NVIM_DIR")" != "$TARGET_LINK" ]; then
        echo "nvim directory is a symlink but points to a different target. Replacing the symlink..."
        rm "$NVIM_DIR"
        ln -s "$TARGET_LINK" "$NVIM_DIR"
    else
        echo "nvim directory is already correctly symlinked to dotfiles."
    fi
else
    if [ -d "$NVIM_DIR" ]; then
        echo "nvim directory exists and is not a symlink. Removing the directory..."
        rm -rf "$NVIM_DIR"
    fi
    echo "Creating symlink for nvim directory..."
    ln -s "$TARGET_LINK" "$NVIM_DIR"
fi

echo "Setup complete."
