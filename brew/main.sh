#!/usr/bin/env bash

# Check brew installations
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    echo "Installing Hombrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homebrew"
    brew update
fi

