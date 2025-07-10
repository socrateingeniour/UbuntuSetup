#!/bin/bash
#
# JetBrains IDE Setup & Icon Fixer
#
# This script should be run AFTER you have installed your JetBrains IDEs
# using the JetBrains Toolbox. It finds the .desktop files created by the
# Toolbox, checks for installed IDEs, and changes their icon to match your
# currently active system icon theme.
#

# --- Color Codes for Output ---
C_RESET='\033[0m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'

# --- Helper Functions for Logging ---
info() {
    echo -e "${C_BLUE}[INFO] $1${C_RESET}"
}

success() {
    echo -e "${C_GREEN}[SUCCESS] $1${C_RESET}"
}

warn() {
    echo -e "${C_YELLOW}[WARNING] $1${C_RESET}"
}

# --- Main Logic ---

# 1. Detect the current icon theme
ICON_THEME=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")

if [ -z "$ICON_THEME" ]; then
    warn "Could not automatically detect the current icon theme."
    info "Falling back to default: 'candy-icons'"
    ICON_THEME="candy-icons"
else
    info "Detected icon theme: $ICON_THEME"
fi

DESKTOP_FILES_PATH="$HOME/.local/share/applications/"

if [ ! -d "$DESKTOP_FILES_PATH" ]; then
    warn "Applications directory not found ($DESKTOP_FILES_PATH). No IDEs to configure."
    exit 0
fi

info "Searching for installed JetBrains IDEs in $DESKTOP_FILES_PATH..."

# 2. Find all .desktop files created by JetBrains Toolbox
JETBRAINS_DESKTOP_FILES=$(find "$DESKTOP_FILES_PATH" -name "jetbrains-*.desktop")

if [ -z "$JETBRAINS_DESKTOP_FILES" ]; then
    warn "No JetBrains IDEs found. Make sure you have installed them via the Toolbox."
    exit 0
fi

for file in $JETBRAINS_DESKTOP_FILES; do
    if [ -f "$file" ]; then
        info "Configuring: $(basename "$file")"
        
        # Extract the IDE name from the filename, which is usually the icon name.
        # e.g., jetbrains-idea.desktop -> idea
        # e.g., jetbrains-pycharm-community.desktop -> pycharm-community
        ICON_NAME=$(basename "$file" .desktop | sed 's/^jetbrains-//g')
        
        info "Setting icon to '$ICON_NAME' to integrate with your theme ($ICON_THEME)..."
        
        # Use sed to replace the full path Icon line with just the icon name
        # This allows the system to pick the icon from the current theme
        sed -i "s|^Icon=.*|Icon=$ICON_NAME|" "$file"
        
        success "Icon for $(basename "$file") has been updated."
    fi
done

success "JetBrains setup complete. Icons have been configured to match your system theme."
info "You may need to refresh your desktop/dock for changes to appear."