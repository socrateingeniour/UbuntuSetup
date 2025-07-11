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
BACKUPS_DIR="/home/auluna/Projects/UbuntuSetup/backups"
ARCHIVE_NAME="backup_$(date +"%Y-%m-%d_%H-%M-%S").tar.gz"

log_action "Creating final backup archive..."

tar -czf "$BACKUPS_DIR/$ARCHIVE_NAME" -C "$BACKUP_TEMP_DIR" .

log_action "Archive created: $ARCHIVE_NAME"

mv "$BACKUP_TEMP_DIR/tracker.txt" "$BACKUPS_DIR/tracker_$(date +"%Y-%m-%d_%H-%M-%S").txt"

log_action "Tracker file saved."

log_action "Cleaning up temporary files..."
rm -rf "$BACKUP_TEMP_DIR"

log_action "Backup process complete."