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
BACKUP_TEMP_DIR="/home/auluna/Projects/UbuntuSetup/backups/temp_backup"
TRACKER_FILE="$BACKUP_TEMP_DIR/tracker.txt"

log_action "Starting backup of AppImages..."

mkdir -p "$BACKUP_TEMP_DIR/appimages"
echo "
--- AppImages ---" >> "$TRACKER_FILE"

if [ -f "$HOME/Applications/GDLauncher.AppImage" ]; then
    log_action "Backing up GDLauncher.AppImage"
    cp "$HOME/Applications/GDLauncher.AppImage" "$BACKUP_TEMP_DIR/appimages/"
    echo "- Backed up GDLauncher.AppImage" >> "$TRACKER_FILE"
fi

DESKTOP_FILE=$(find "$HOME/.local/share/applications" -name "*GDLauncher*.desktop" 2>/dev/null | head -n 1)
if [ -n "$DESKTOP_FILE" ]; then
    log_action "Backing up GDLauncher .desktop file"
    cp "$DESKTOP_FILE" "$BACKUP_TEMP_DIR/appimages/"
    echo "- Backed up $(basename "$DESKTOP_FILE")" >> "$TRACKER_FILE"
fi

log_action "AppImage backup completed."