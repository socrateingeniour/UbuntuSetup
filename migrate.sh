#!/bin/bash
#
# Ubuntu Migration & Setup Script
#
# This script automates the backup of user configurations from an old Ubuntu machine
# and restores them, along with installing specified applications, on a new machine.
#

# --- Color Codes for Output ---
C_RESET='\033[0m'
C_RED='\033[0;31m'
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

error() {
    echo -e "${C_RED}[ERROR] $1${C_RESET}"
}

# --- Backup Function (Run on OLD machine) ---
backup() {
    info "Starting backup process..."
    
    BACKUP_DIR="migration_backup"
    ARCHIVE_NAME="migration_archive.tar.gz"

    if [ -d "$BACKUP_DIR" ]; then
        warn "Existing backup directory found. Removing it."
        rm -rf "$BACKUP_DIR"
    fi
    mkdir -p "$BACKUP_DIR"
    
    # 1. Copy UI Files (Themes, Icons, Fonts)
    info "Backing up themes, icons, and fonts..."
    mkdir -p "$BACKUP_DIR/ui"
    cp -r ~/.themes "$BACKUP_DIR/ui/" 2>/dev/null || warn "No ~/.themes directory found."
    cp -r ~/.icons "$BACKUP_DIR/ui/" 2>/dev/null || warn "No ~/.icons directory found."
    cp -r ~/.local/share/themes "$BACKUP_DIR/ui/" 2>/dev/null || warn "No ~/.local/share/themes directory found."
    cp -r ~/.local/share/icons "$BACKUP_DIR/ui/" 2>/dev/null || warn "No ~/.local/share/icons directory found."
    cp -r ~/.fonts "$BACKUP_DIR/ui/" 2>/dev/null || warn "No ~/.fonts directory found."

    # 2. Copy Application Configurations
    info "Backing up application configurations..."
    mkdir -p "$BACKUP_DIR/configs"
    cp -r ~/.config/dconf "$BACKUP_DIR/configs/" 2>/dev/null || warn "No dconf config found."
    cp -r ~/.config/conky "$BACKUP_DIR/configs/" 2>/dev/null || warn "No conky config found."
    cp -r ~/.conky "$BACKUP_DIR/configs/" 2>/dev/null || warn "No .conky directory found."
    cp -r ~/.config/Code "$BACKUP_DIR/configs/" 2>/dev/null || warn "No VS Code config found."
    cp -r ~/.config/wireshark "$BACKUP_DIR/configs/" 2>/dev/null || warn "No Wireshark config found."
    cp -r ~/.config/Postman "$BACKUP_DIR/configs/" 2>/dev/null || warn "No Postman config found."
    cp -r ~/.config/discord "$BACKUP_DIR/configs/" 2>/dev/null || warn "No Discord config found."
    cp -r ~/.config/obs-studio "$BACKUP_DIR/configs/" 2>/dev/null || warn "No OBS Studio config found."
    cp -r ~/.config/gdlauncher_next "$BACKUP_DIR/configs/" 2>/dev/null || warn "No GDLauncher config found."

    # 3. Backup Steam (excluding game data)
    info "Backing up Steam configuration (excluding game data)..."
    mkdir -p "$BACKUP_DIR/configs/steam"
    rsync -a --exclude 'steamapps' ~/.steam/ "$BACKUP_DIR/configs/steam/steam_dot"
    rsync -a --exclude 'steamapps' ~/.local/share/Steam/ "$BACKUP_DIR/configs/steam/steam_local_share"


    # 4. Backup GDLauncher AppImage
    info "Backing up GDLauncher AppImage..."
    mkdir -p "$BACKUP_DIR/appimages"
    cp ~/Applications/GDLauncher.AppImage "$BACKUP_DIR/appimages/" 2>/dev/null || warn "GDLauncher.AppImage not found in ~/Applications."
    find ~/.local/share/applications -name "*GDLauncher*.desktop" -exec cp {} "$BACKUP_DIR/appimages/" \;

    # 5. Generate Software Lists
    info "Generating software lists..."
    code --list-extensions > "$BACKUP_DIR/vscode_extensions.txt"
    gsettings get org.gnome.shell enabled-extensions > "$BACKUP_DIR/gnome_extensions_list.txt"
    dconf dump /org/gnome/shell/extensions/ > "$BACKUP_DIR/gnome_extensions_backup.dconf"

    # 6. Create Final Archive
    info "Creating final backup archive: $ARCHIVE_NAME"
    tar -czf "$ARCHIVE_NAME" "$BACKUP_DIR"
    rm -rf "$BACKUP_DIR"
    
    success "Backup complete! Transfer $ARCHIVE_NAME to your new machine."
}

# --- Restore Function (Run on NEW machine) ---
restore() {
    info "Starting restore process..."
    ARCHIVE_NAME="migration_archive.tar.gz"

    if [ ! -f "$ARCHIVE_NAME" ]; then
        error "Backup archive '$ARCHIVE_NAME' not found! Aborting."
        exit 1
    fi

    # 1. Install Base Software & System Tools (APT)
    info "Installing base software from APT..."
    sudo apt update
    sudo apt install -y gnome-tweaks conky flatpak gnome-shell-extension-manager wget gpg python3-pip

    # 2. Install from Third-Party Repositories
    info "Setting up third-party repositories (VS Code, Java)..."
    # VS Code
    sudo apt-get install -y apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    # Java (Adoptium)
    wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
    echo "deb https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/adoptium.list

    info "Installing applications from new repositories..."
    sudo apt update
    sudo apt install -y code temurin-21-jdk

    # 3. Install Python Libraries (Pip)
    info "Installing Python libraries..."
    pip install numpy scipy matplotlib pandas jupyterlab scikit-learn seaborn

    # 4. Install Applications from Flathub
    info "Setting up Flathub and installing applications..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    info "Installing VERIFIED apps from Flathub..."
    flatpak install -y flathub org.wireshark.Wireshark com.valvesoftware.Steam com.discordapp.Discord com.obsproject.Studio io.github.flattool.Warehouse io.missioncenter.MissionCenter com.github.tchx84.Flatseal

    info "Installing UNVERIFIED apps from Flathub..."
    warn "The following apps are from unverified developers. Use Flatseal to manage their permissions."
    flatpak install -y flathub com.getpostman.Postman io.dbeaver.DBeaverCommunity

    # 5. Restore All User Data
    info "Extracting backup archive and restoring data..."
    tar -xzf "$ARCHIVE_NAME"
    
    info "Restoring UI files..."
    cp -r migration_backup/ui/* ~/ 2>/dev/null
    
    info "Restoring application configs..."
    cp -r migration_backup/configs/* ~/.config/ 2>/dev/null
    mkdir -p ~/.steam && cp -r migration_backup/configs/steam/steam_dot/* ~/.steam/
    mkdir -p ~/.local/share/Steam && cp -r migration_backup/configs/steam/steam_local_share/* ~/.local/share/Steam/

    # 6. Finalize Application Setups
    info "Finalizing application setups..."
    # GDLauncher
    mkdir -p ~/Applications
    cp migration_backup/appimages/GDLauncher.AppImage ~/Applications/
    chmod +x ~/Applications/GDLauncher.AppImage
    mkdir -p ~/.local/share/applications
    cp migration_backup/appimages/*.desktop ~/.local/share/applications/

    # VS Code Extensions
    info "Restoring VS Code extensions..."
    while read -r extension; do
        code --install-extension "$extension"
    done < migration_backup/vscode_extensions.txt

    # GNOME Shell Extensions
    info "Restoring GNOME Shell extensions..."
    dconf load /org/gnome/shell/extensions/ < migration_backup/gnome_extensions_backup.dconf
    warn "GNOME extensions have been configured. You may need to enable them manually via the Extension Manager."

    # Clean up
    rm -rf "migration_backup"
    
    success "Restore complete!"
    info "Please log out and log back in for all changes to take effect."
    warn "Remember to use Flatseal to check permissions for Postman and DBeaver."
    warn "For JetBrains IDEs, install them via the Toolbox, then run 'fix_jetbrains_icons.sh'."
}


# --- Main Script Logic ---
case "$1" in
    backup)
        backup
        ;;
    restore)
        restore
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
        ;;
esac
