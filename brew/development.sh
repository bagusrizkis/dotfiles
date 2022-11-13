#!/usr/bin/env bash

# install nvm and latest version node
brew install nvm
nvm install --lts

# TUI Apps
brew install 
brew install neovim
brew install tmux
brew install gh
brew install tree-sitter
brew install rg
brew install fd
brew install tree

# GUI Apps
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask another-redis-desktop-manager
brew install --cask docker
brew install --cask google-chrome
brew install --cask github-desktop



brew cleanup
