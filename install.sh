#!/usr/bin/env bash
# Install CachyOS packages, keep this repo in ~/.local/share/dotfiles,
# and symlink configs into place. Later changes are just git pull.
set -euo pipefail

share="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles"
config="${XDG_CONFIG_HOME:-$HOME/.config}"
repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)

# Apps only. CachyOS already picks the hardware drivers.
packages=(
	noctalia
	git
	tmux
	niri
	paru
	fish
	fisher
	eza
	zoxide
	thefuck
	xwayland-satellite
	loupe
	nautilus
	yazi
	trash-cli
	snapshot
	flatpak
	wireplumber
	pipewire
	xdg-desktop-portal-gnome
	pavucontrol
	nwg-look
	qt6ct
	adw-gtk-theme
	ffmpeg
	gst-plugins-base
	gst-plugins-good
	gst-plugins-bad
	gst-plugins-ugly
	x264
	x265
	libvpx
	libdvdcss
)

aur_packages=(
	ttf-ioskeley-mono
	notwaita-cursor-theme
)

root_dots=(
	.zshrc
	.zshenv
	.vimrc
	.tmux.conf
	.zsh_plugins.txt
)

cachyos() {
	[[ -r /etc/os-release ]] || return 1
	local id
	id=$(sed -n 's/^ID=//p' /etc/os-release | head -n 1)
	id=${id//\"/}
	[[ "$id" == "cachyos" ]]
}

install_packages() {
	if ! cachyos; then
		local id
		id=$(sed -n 's/^ID=//p' /etc/os-release 2>/dev/null | head -n 1 || true)
		id=${id//\"/}
		echo "skipping packages: CachyOS only (this one is ${id:-unknown})" >&2
		return 0
	fi
	echo "installing packages"
	sudo pacman -S --needed "${noconfirm[@]}" "${packages[@]}"
	echo "installing drivers"
	sudo chwd -a
	echo "installing aur packages"
	paru -S --needed "${noconfirm[@]}" "${aur_packages[@]}"
}

set_fish() {
	local fish_bin current candidate
	fish_bin=""
	# chsh matches the path text in /etc/shells. command -v can print
	# /usr/sbin/fish, which is the same binary and is not listed.
	local -a candidates=(/usr/bin/fish /bin/fish)
	if command -v fish >/dev/null 2>&1; then
		candidates+=("$(command -v fish)")
	fi
	for candidate in "${candidates[@]}"; do
		[[ -n "$candidate" && -x "$candidate" ]] || continue
		if grep -qxF "$candidate" /etc/shells; then
			fish_bin=$candidate
			break
		fi
	done
	[[ -n "$fish_bin" ]] || return 0
	current=$(getent passwd "$USER" | cut -d: -f7 || true)
	if [[ -n "$current" && "$(readlink -f "$current")" == "$(readlink -f "$fish_bin")" ]]; then
		return 0
	fi
	echo "setting login shell to $fish_bin"
	chsh -s "$fish_bin" || echo "login shell was not changed" >&2
}

install_fisher() {
	command -v fish >/dev/null || return 0
	fish -c 'functions -q fisher' || return 0
	local list="$share/.config/fish/fisher.list"
	[[ -f "$list" ]] || return 0
	local plugins=()
	mapfile -t plugins < <(grep -v '^[[:space:]]*$' "$list" || true)
	((${#plugins[@]})) || return 0
	echo "installing fish plugins"
	fish -c "fisher install ${plugins[*]}"
}

install_yazi() {
	command -v ya >/dev/null || return 0
	local spec="uhs-robert/recycle-bin"
	local manifest="$config/yazi/package.toml"
	echo "installing yazi plugins"
	if [[ -f "$manifest" ]] && grep -qF "$spec" "$manifest"; then
		ya pkg install
	else
		ya pkg add "$spec"
	fi
}

install_tpm() {
	local tpm="$HOME/.tmux/plugins/tpm"
	if [[ ! -d "$tpm/.git" ]]; then
		echo "installing tmux plugin manager"
		mkdir -p "$(dirname "$tpm")"
		GIT_TERMINAL_PROMPT=0 git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
	fi
	if [[ -x "$tpm/bin/install_plugins" ]]; then
		if ! command -v tmux >/dev/null; then
			echo "skipping tmux plugins: tmux is not installed" >&2
			return 0
		fi
		echo "installing tmux plugins"
		"$tpm/bin/install_plugins"
	fi
}

install_nvim() {
	local dest="$config/nvim"
	local url="https://github.com/sumit-poudel/nvim.git"
	if [[ -d "$dest/.git" ]]; then
		echo "updating nvim"
		GIT_TERMINAL_PROMPT=0 git -C "$dest" pull --ff-only
		return
	fi
	if [[ -e "$dest" || -L "$dest" ]]; then
		stash "$dest"
	fi
	echo "cloning nvim"
	GIT_TERMINAL_PROMPT=0 git clone "$url" "$dest"
}

stash() {
	local dest=$1
	if [[ -e "$dest.bck" || -L "$dest.bck" ]]; then
		rm -rf -- "$dest.bck"
	fi
	mv -T "$dest" "$dest.bck"
	echo "backed up $dest.bck"
}

link_one() {
	local src=$1 dest=$2
	if [[ -L "$dest" && "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
		return 0
	fi
	if [[ -e "$dest" || -L "$dest" ]]; then
		stash "$dest"
	fi
	mkdir -p "$(dirname "$dest")"
	ln -s "$src" "$dest"
	echo "linked $dest"
}

link_configs() {
	local path name dot
	shopt -s nullglob
	for path in "$share"/.config/*; do
		name=$(basename "$path")
		link_one "$path" "$config/$name"
	done
	shopt -u nullglob
	for dot in "${root_dots[@]}"; do
		[[ -e "$share/$dot" ]] || continue
		link_one "$share/$dot" "$HOME/$dot"
	done
}

# Noctalia reads these paths from .config/noctalia/shell.toml.
link_pictures() {
	local pictures="$HOME/Pictures"
	if [[ -d "$share/wallpapers" ]]; then
		link_one "$share/wallpapers" "$pictures/Wallpapers"
	fi
	if [[ -e "$share/avtar.jpg" ]]; then
		link_one "$share/avtar.jpg" "$pictures/avtar.jpg"
	fi
}

noconfirm=()
for arg in "$@"; do
	case "$arg" in
	--noconfirm) noconfirm=(--noconfirm) ;;
	*)
		echo "unknown option: $arg" >&2
		exit 1
		;;
	esac
done

if [[ "$repo" != "$share" ]]; then
	if [[ -e "$share" || -L "$share" ]]; then
		echo "refusing to move: $share already exists" >&2
		exit 1
	fi
	mkdir -p "$(dirname "$share")"
	mv "$repo" "$share"
	ln -s "$share" "$repo"
	echo "moved repo to $share"
	exec "$share/install.sh" "$@"
fi

install_packages
set_fish
link_configs
link_pictures
install_fisher
install_yazi
install_tpm
install_nvim
echo "configs follow $share — git pull updates them"
