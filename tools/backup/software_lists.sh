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

log_action "Starting backup of software lists..."

echo "
--- Software Lists ---" >> "$TRACKER_FILE"

log_action "Generating VS Code extension list..."
code --list-extensions > "$BACKUP_TEMP_DIR/vscode_extensions.txt"
echo "- Generated vscode_extensions.txt" >> "$TRACKER_FILE"

log_action "Generating GNOME Shell extension list..."
gsettings get org.gnome.shell enabled-extensions > "$BACKUP_TEMP_DIR/gnome_extensions_list.txt"
echo "- Generated gnome_extensions_list.txt" >> "$TRACKER_FILE"

log_action "Backing up GNOME Shell extension settings..."
dconf dump /org/gnome/shell/extensions/ > "$BACKUP_TEMP_DIR/gnome_extensions_backup.dconf"
echo "- Backed up GNOME extension dconf settings" >> "$TRACKER_FILE"

log_action "Software list backup completed."