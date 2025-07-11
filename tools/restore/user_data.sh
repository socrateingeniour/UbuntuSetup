#!/bin/bash

# --- Logger ---
log_action() {
    local message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\033[0;34m[ACTION] $message\033[0m"
    echo "[$timestamp] - $message" >> "$MIGRATION_LOG_FILE"
}

# --- Main Logic --- 
ARCHIVE_PATH="$1"
RESTORE_TEMP_DIR="/home/auluna/Projects/UbuntuSetup/backups/temp_restore"

if [ -z "$ARCHIVE_PATH" ] || [ ! -f "$ARCHIVE_PATH" ]; then
    log_action "ERROR: Backup archive not found at '$ARCHIVE_PATH'"
    exit 1
fi

log_action "Starting restore of user data from $ARCHIVE_PATH..."

mkdir -p "$RESTORE_TEMP_DIR"

log_action "Extracting archive..."
tar -xzf "$ARCHIVE_PATH" -C "$RESTORE_TEMP_DIR"

if [ -d "$RESTORE_TEMP_DIR/ui" ]; then
    log_action "Restoring UI files..."
    cp -r "$RESTORE_TEMP_DIR/ui/." "$HOME/"
fi

if [ -d "$RESTORE_TEMP_DIR/configs" ]; then
    log_action "Restoring application configs..."
    cp -r "$RESTORE_TEMP_DIR/configs/." "$HOME/.config/"
fi

if [ -d "$RESTORE_TEMP_DIR/configs/steam" ]; then
    log_action "Restoring Steam configs..."
    mkdir -p "$HOME/.steam"
    cp -r "$RESTORE_TEMP_DIR/configs/steam/steam_dot/." "$HOME/.steam/"
    mkdir -p "$HOME/.local/share/Steam"
    cp -r "$RESTORE_TEMP_DIR/configs/steam/steam_local_share/." "$HOME/.local/share/Steam/"
fi

log_action "User data restore completed."