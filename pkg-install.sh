#!/usr/bin/env bash
set -euo pipefail

###############################################
# 0. Root Check + Real User Detection
###############################################
if (( EUID != 0 )); then
  echo "Please run this script as root (e.g. via sudo)." >&2
  exit 1
fi

# the user who called sudo, or $USER if not using sudo
real_user="${SUDO_USER:-$USER}"

###############################################
# 1. System Update
###############################################
echo "=== Enabling multilib & updating system ==="
sed -i '/\[multilib\]/,/Include/ s/^#//' /etc/pacman.conf
pacman -Syu --noconfirm

###############################################
# 2. Install paru (Optional)
###############################################
read -rp "Install paru? [Y/N]: " install_paru
if [[ $install_paru =~ ^[Yy]$ ]]; then
	build_dir=/tmp/paru-build
	rm -rf "$build_dir"
	echo "Cloning paru ..."
	sudo -u "$real_user" git clone https://aur.archlinux.org/paru.git "$build_dir"
	pushd "$build_dir" >/dev/null
		echo "Building & installing paru ..."
		sudo -u "$real_user" makepkg -si --noconfirm
	popd >/dev/null
	rm -rf "$build_dir"
  # double-check
  if ! command -v paru &>/dev/null; then
    echo "paru install failed. Exiting." >&2
    exit 1
  fi
fi

###############################################
# 3. Install Additional Packages (Optional)
###############################################
read -rp "Install additional AUR & community packages? [Y/N]: " install_pkgs
if [[ $install_pkgs =~ ^[Yy]$ ]]; then
  if command -v paru &>/dev/null; then
    echo "Installing additional packages with paru..."
    sudo -u "$real_user" paru -S --needed \
       btop htop atool zip unzip 7zip usbutils ranger \
       usbmuxd libimobiledevice android-tools udiskie udisks2 jmtpfs \
       powertop tlp \
       fcitx5 fcitx5-unikey fcitx5-configtool fcitx5-gtk \
       mpv ani-cli gstreamer-vaapi \
       foot nicotine+ easytag imv visual-studio-code-bin obsidian \
       vesktop-bin steam mangohud ttf-liberation cmatrix-git \
       pavucontrol blueman onlyoffice-bin zen-browser-bin
  else
    echo "paru not found; skipping AUR installs."
  fi

  # Enable some services
  for svc in usbmuxd supergfxd; do
    systemctl enable "$svc"
  done
fi
