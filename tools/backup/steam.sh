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

log_action "Starting backup of Steam configs..."

mkdir -p "$BACKUP_TEMP_DIR/configs/steam"
echo "
--- Steam Configs ---" >> "$TRACKER_FILE"

if [ -d "$HOME/.steam" ]; then
    log_action "Backing up Steam configuration (excluding game data)..."
    rsync -a --exclude 'steamapps' "$HOME/.steam/" "$BACKUP_TEMP_DIR/configs/steam/steam_dot"
    echo "- Backed up ~/.steam (excluding steamapps)" >> "$TRACKER_FILE"
fi

if [ -d "$HOME/.local/share/Steam" ]; then
    log_action "Backing up Steam local share data (excluding game data)..."
    rsync -a --exclude 'steamapps' "$HOME/.local/share/Steam/" "$BACKUP_TEMP_DIR/configs/steam/steam_local_share"
    echo "- Backed up ~/.local/share/Steam (excluding steamapps)" >> "$TRACKER_FILE"
fi

log_action "Steam config backup completed."