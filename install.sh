#!/bin/bash

# exit when any command fails
set -e

# Chech commands exists
command -v stow > /dev/null || { echo "You must install stow before executing this script."; exit 1; }

# Create shared directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/autostart"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.ssh"

# Stow packages
st () {
	stow --target "$HOME" "$@"
}

st --stow stow git nvim rofi

echo "Command executed succesfuly"
