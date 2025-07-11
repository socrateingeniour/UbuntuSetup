#!/bin/bash

# --- Logger ---
log_action() {
    local message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\033[0;34m[ACTION] $message\033[0m"
    echo "[$timestamp] - $message" >> "$MIGRATION_LOG_FILE"
}

# --- Main Logic --- 
log_action "Starting installation of base APT packages..."

PACKAGES_TO_INSTALL=(
    gnome-tweaks
    conky
    flatpak
    gnome-shell-extension-manager
    wget
    gpg
    python3-pip
)

log_action "Updating APT cache..."
sudo apt update

for pkg in "${PACKAGES_TO_INSTALL[@]}"; do
    log_action "Installing $pkg..."
    sudo apt install -y "$pkg"
done

log_action "Base APT package installation completed."