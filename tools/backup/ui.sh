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

log_action "Initializing UI backup..."

mkdir -p "$BACKUP_TEMP_DIR/ui"

echo "--- UI Backup Details ---" > "$TRACKER_FILE"

if [ -d "$HOME/.themes" ]; then
    log_action "Backing up ~/.themes"
    cp -r "$HOME/.themes" "$BACKUP_TEMP_DIR/ui/"
    echo "- Backed up ~/.themes" >> "$TRACKER_FILE"
fi

if [ -d "$HOME/.icons" ]; then
    log_action "Backing up ~/.icons"
    cp -r "$HOME/.icons" "$BACKUP_TEMP_DIR/ui/"
    echo "- Backed up ~/.icons" >> "$TRACKER_FILE"
fi

if [ -d "$HOME/.local/share/themes" ]; then
    log_action "Backing up ~/.local/share/themes"
    cp -r "$HOME/.local/share/themes" "$BACKUP_TEMP_DIR/ui/"
    echo "- Backed up ~/.local/share/themes" >> "$TRACKER_FILE"
fi

if [ -d "$HOME/.local/share/icons" ]; then
    log_action "Backing up ~/.local/share/icons"
    cp -r "$HOME/.local/share/icons" "$BACKUP_TEMP_DIR/ui/"
    echo "- Backed up ~/.local/share/icons" >> "$TRACKER_FILE"
fi

if [ -d "$HOME/.fonts" ]; then
    log_action "Backing up ~/.fonts"
    cp -r "$HOME/.fonts" "$BACKUP_TEMP_DIR/ui/"
    echo "- Backed up ~/.fonts" >> "$TRACKER_FILE"
fi

log_action "UI backup completed."