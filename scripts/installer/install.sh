#!/bin/bash
set -e
echo "install script"
# -----------------------------
# Variables
# -----------------------------
ISAUR="/sbin/paru"
PARU_INST="./paru-inst"

PACMAN_PACKAGES=(
  npm pipewire wireplumber pamixer brightnessctl
  ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono
  ttf-fira-sans ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd
  ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
  sddm mpv steam nwg-displays cava ufw ranger pulseaudio-bluetooth network-manager-applet
  obs-studio plocate man-db libheif loupe qbittorrent uwsm ghostty kitty bat eza leafpad
  tela-circle-icon-theme-dracula nano tar hyprland xdg-desktop-portal-hyprland polkit-kde-agent
  swaync qt5-wayland qt6-wayland waybar tofi cliphist swww hyprpicker hyprlock wlogout
  grimblast hypridle nwg-look qt6ct qt5ct kvantum
  kvantum-qt5 qt6ct dolphin nvidia-dkms
  qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg fastfetch gnome-font-viewer
  cheese vlc vlc-plugins-all nodejs-lts-iron nvim ntfs-3g
)

AUR_PACKAGES=(
  electron29-bin mpvpaper ncmpcpp mpd ytdlp kvantum-theme-catppuccin-git
  xampp brave-bin rar visual-studio-code-bin
  ttf-ms-win11-auto
  zsh-autosuggestions zsh-thefuck-git zsh-theme-powerlevel10k zsh-z-git zen-browser-bin
  zsh-syntax-highlighting zsh-completions
)

DOTFILES_DIR="$HOME/dotfiles"

# -----------------------------
# Functions
# -----------------------------
install_paru() {
  if [ -f "$ISAUR" ]; then
    echo "Paru already installed."
  else
    echo "Installing Paru..."
    if [ -f "$PARU_INST" ]; then
      chmod +x "$PARU_INST"
      ./"$PARU_INST"
    else
      echo "paru-inst script missing. Place it in this folder."
      exit 1
    fi
  fi
}

configure_pacman() {
  echo "Configuring pacman..."
  sudo sed -i "s/^#ParallelDownloads = .*/ParallelDownloads = 15/" /etc/pacman.conf
  grep -q '^ILoveCandy' /etc/pacman.conf || echo 'ILoveCandy' | sudo tee -a /etc/pacman.conf
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
  cp -r "$DOTFILES_DIR/.config/"* "$HOME/.config/"
  cp "$DOTFILES_DIR"/.zshrc "$HOME/"
  cp "$DOTFILES_DIR"/.zshenv "$HOME/"
  cp "$DOTFILES_DIR"/.p10k.zsh "$HOME/"
  cp "$DOTFILES_DIR"/.vimrc "$HOME/"
  chmod -R u+rw "$HOME/.config/"
  chmod u+rw "$HOME"/.zshrc "$HOME"/.zshenv "$HOME"/.p10k.zsh

  # Make scripts executable
  if [ -d "$HOME/.config/scripts" ]; then
    chmod +x "$HOME/.config/scripts/"*
  fi
  if [ -d "$HOME/.config/hypr/scripts" ]; then
    chmod +x "$HOME/.config/hypr/scripts/"*
  fi
  if [ -d "$HOME/.config/waybar/script" ]; then
    chmod +x "$HOME/.config/waybar/script/"*
  fi
}

enable_services() {
  echo "Enabling services..."
  sudo systemctl enable --now sddm
  sudo systemctl enable --now ufw
}

# -----------------------------
# Main
# -----------------------------
install_paru
configure_pacman
install_packages
deploy_dotfiles
enable_services

echo "Hyprland installation and config deployment complete!"
