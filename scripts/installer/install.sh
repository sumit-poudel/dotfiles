#!/bin/bash
set -e
echo "install script for cachyos"
# -----------------------------
# Variables
# -----------------------------
ISAUR="/sbin/paru"

PACMAN_PACKAGES=(niri xwayland-satellite noctalia-shell kitty nautilus)

AUR_PACKAGES=()

DOTFILES_DIR="$HOME/dotfiles"

# -----------------------------
# Functions
# -----------------------------
install_paru() {
  if [ -f "$ISAUR" ]; then
    echo "Paru already installed."
  else
    echo "Installing Paru..."
    sudo pacman -S paru
  fi
}

install_packages() {
  echo "Updating system..."
  sudo pacman -Syyu --noconfirm

  echo "Installing pacman packages..."
  sudo pacman -S --noconfirm "${PACMAN_PACKAGES[@]}"

  echo "Installing AUR packages..."
  paru -S --noconfirm "${AUR_PACKAGES[@]}"
}

deploy_dotfiles() {
  echo "Deploying dotfiles..."
}

enable_services() {
  echo "Enabling services..."
  sudo systemctl enable --now ufw

}

system_reboot() {
  echo "niri installation and config deployment complete!"
  echo "Rebooting the system....."
  echo "Press Enter to Continue...."
  /usr/sbin/reboot
}

# -----------------------------
# Main
# -----------------------------
install_paru
install_packages
deploy_dotfiles
enable_services
system_reboot
