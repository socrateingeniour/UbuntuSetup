#!/bin/bash

# --- Logger ---
log_action() {
    local message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\033[0;34m[ACTION] $message\033[0m"
    echo "[$timestamp] - $message" >> "$MIGRATION_LOG_FILE"
}

# --- Main Logic --- 
RESTORE_TEMP_DIR="/home/auluna/Projects/UbuntuSetup/backups/temp_restore"

log_action "Starting final application setups..."

if [ -f "$RESTORE_TEMP_DIR/appimages/GDLauncher.AppImage" ]; then
    log_action "Setting up GDLauncher..."
    mkdir -p "$HOME/Applications"
    cp "$RESTORE_TEMP_DIR/appimages/GDLauncher.AppImage" "$HOME/Applications/"
    chmod +x "$HOME/Applications/GDLauncher.AppImage"
    mkdir -p "$HOME/.local/share/applications"
    cp "$RESTORE_TEMP_DIR/appimages/"*.desktop "$HOME/.local/share/applications/"
fi

if [ -f "$RESTORE_TEMP_DIR/vscode_extensions.txt" ]; then
    log_action "Restoring VS Code extensions..."
    while read -r extension; do
        log_action "Installing VS Code extension: $extension"
        code --install-extension "$extension"
    done < "$RESTORE_TEMP_DIR/vscode_extensions.txt"
fi

if [ -f "$RESTORE_TEMP_DIR/gnome_extensions_backup.dconf" ]; then
    log_action "Restoring GNOME Shell extensions..."
    dconf load /org/gnome/shell/extensions/ < "$RESTORE_TEMP_DIR/gnome_extensions_backup.dconf"
    log_action "GNOME extensions configured. Enable them manually via the Extension Manager."
fi

log_action "Cleaning up temporary restore files..."
rm -rf "$RESTORE_TEMP_DIR"

log_action "Final setup completed."