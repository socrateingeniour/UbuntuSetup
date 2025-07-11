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

log_action "Starting backup of application configs..."

mkdir -p "$BACKUP_TEMP_DIR/configs"
echo "
--- Application Configs ---" >> "$TRACKER_FILE"

CONFIGS_TO_BACKUP=(
    "$HOME/.config/dconf"
    "$HOME/.config/conky"
    "$HOME/.conky"
    "$HOME/.config/Code"
    "$HOME/.config/wireshark"
    "$HOME/.config/Postman"
    "$HOME/.config/discord"
    "$HOME/.config/obs-studio"
    "$HOME/.config/gdlauncher_next"
)

for config_path in "${CONFIGS_TO_BACKUP[@]}"; do
    if [ -d "$config_path" ]; then
        log_action "Backing up $(basename "$config_path")"
        cp -r "$config_path" "$BACKUP_TEMP_DIR/configs/"
        echo "- Backed up $(basename "$config_path")" >> "$TRACKER_FILE"
    fi
done

log_action "Application config backup completed."