#!/bin/sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (using sudo)."
    exit 1
fi

set -e

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo "yay not found. Installing yay..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
else
    echo "yay is already installed."
fi

# Check if packages.txt exists
if [[ ! -f packages.txt ]]; then
    echo "Error: packages.txt not found!"
    exit 1
fi

# Read packages.txt and install packages
echo "Installing packages from packages.txt..."
yay -S --needed --noconfirm $(grep -vE '^\s*#' packages.txt | xargs)

echo "All packages installed."

# Check if Oh My Zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed."
else
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://install.ohmyz.sh)"
fi

echo "Copying dotfiles to home directory..."
cp -rf ~/dev/dotfiles/home/. ~/

echo "Copying config files to .config directory..."
cp -rf ~/dev/dotfiles/config/. ~/.config/

echo "Setting zsh as the default shell for $USER..."
chsh -s $(which zsh)

echo "Enabling sddm"
sudo systemctl enable sddm

echo "Enabling mako"
systemctl --user add-wants niri.service mako.service

echo "Installation finished! Please restart your terminal or log out and log back in to apply changes."
