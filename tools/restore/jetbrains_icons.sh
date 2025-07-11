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
log_action "Starting JetBrains IDE icon fix..."

ICON_THEME=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")

if [ -z "$ICON_THEME" ]; then
    log_action "Could not automatically detect the current icon theme. Falling back to 'candy-icons'."
    ICON_THEME="candy-icons"
else
    log_action "Detected icon theme: $ICON_THEME"
fi

DESKTOP_FILES_PATH="$HOME/.local/share/applications/"

if [ ! -d "$DESKTOP_FILES_PATH" ]; then
    log_action "Applications directory not found ($DESKTOP_FILES_PATH). No IDEs to configure."
    exit 0
fi

log_action "Searching for installed JetBrains IDEs in $DESKTOP_FILES_PATH..."

JETBRAINS_DESKTOP_FILES=$(find "$DESKTOP_FILES_PATH" -name "jetbrains-*.desktop")

if [ -z "$JETBRAINS_DESKTOP_FILES" ]; then
    log_action "No JetBrains IDEs found. Make sure you have installed them via the Toolbox."
    exit 0
fi

for file in $JETBRAINS_DESKTOP_FILES; do
    if [ -f "$file" ]; then
        ICON_NAME=$(basename "$file" .desktop | sed 's/^jetbrains-//g')
        log_action "Setting icon for $(basename "$file") to '$ICON_NAME'"
        sed -i "s|^Icon=.*|Icon=$ICON_NAME|" "$file"
    fi
done

log_action "JetBrains icon fix complete."