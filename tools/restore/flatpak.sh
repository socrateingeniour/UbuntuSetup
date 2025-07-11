#!/bin/bash

# --- Logger ---
LOG_DIR="/home/auluna/Projects/UbuntuSetup/logs"
LOG_FILE="$LOG_DIR/migration_log_$(date +"%Y-%m-%d_%H-%M-%S").log"

setup_logging() {
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
    fi
    if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE"
        echo "Log started at $(date)" >> "$LOG_FILE"
    fi
}

log_action() {
    local message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\033[0;34m[ACTION] $message\033[0m"
    echo "[$timestamp] - $message" >> "$LOG_FILE"
}

setup_logging

# --- Main Logic --- 
log_action "Starting installation of Flatpak packages..."

log_action "Adding Flathub remote repository..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

VERIFIED_APPS=(
    org.wireshark.Wireshark
    com.valvesoftware.Steam
    com.discordapp.Discord
    com.obsproject.Studio
    io.github.flattool.Warehouse
    io.missioncenter.MissionCenter
    com.github.tchx84.Flatseal
)

UNVERIFIED_APPS=(
    com.getpostman.Postman
    io.dbeaver.DBeaverCommunity
)

log_action "Installing VERIFIED apps from Flathub..."
for app in "${VERIFIED_APPS[@]}"; do
    log_action "Installing $app..."
    flatpak install -y flathub "$app"
done

log_action "Installing UNVERIFIED apps from Flathub..."
log_action "WARNING: The following apps are from unverified developers. Use Flatseal to manage their permissions."
for app in "${UNVERIFIED_APPS[@]}"; do
    log_action "Installing $app..."
    flatpak install -y flathub "$app"
done

log_action "Flatpak package installation completed."