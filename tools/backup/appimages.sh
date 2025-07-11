#!/bin/bash

# --- Logger ---
log_action() {
    local message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\033[0;34m[ACTION] $message\033[0m"
    echo "[$timestamp] - $message" >> "$MIGRATION_LOG_FILE"
}

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