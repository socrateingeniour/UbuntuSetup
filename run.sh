#!/bin/bash

# --- Main Orchestrator Script ---

# Define a single log file for this entire run
export MIGRATION_LOG_FILE="/home/auluna/Projects/UbuntuSetup/logs/migration_log_$(date +"%Y-%m-%d_%H-%M-%S").log"
mkdir -p "$(dirname "$MIGRATION_LOG_FILE")"
touch "$MIGRATION_LOG_FILE"

# --- Color Codes for Output ---
C_RESET='\033[0m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_RED='\033[0;31m'

# --- Helper Functions ---
show_menu() {
    echo -e "${C_YELLOW}--- Ubuntu Migration Manager ---"
    echo "1. Run FULL Backup Process"
    echo "2. Run FULL Restore Process"
    echo "3. Use AI Assistant (Gemini CLI)"
    echo "4. Exit"
    echo -e "--------------------------------${C_RESET}"
}

run_backup() {
    echo -e "${C_GREEN}Starting Backup...${C_RESET}"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/backup/ui.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/backup/configs.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/backup/steam.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/backup/appimages.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/backup/software_lists.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/backup/archive.sh"
    echo -e "${C_GREEN}Backup process finished.${C_RESET}"
}

run_restore() {
    echo -e "${C_GREEN}Starting Restore...${C_RESET}"
    read -p "Enter the full path to the backup archive to restore: " archive_path

    if [ ! -f "$archive_path" ]; then
        echo -e "${C_RED}Archive not found! Aborting.${C_RESET}"
        return
    fi

    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/restore/user_data.sh" "$archive_path"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/restore/apt.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/restore/third_party_repos.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/restore/pip.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/restore/flatpak.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/restore/finalize.sh"
    /bin/bash "/home/auluna/Projects/UbuntuSetup/tools/restore/jetbrains_icons.sh"
    echo -e "${C_GREEN}Restore process finished.${C_RESET}"
}

run_ai_assistant() {
    if command -v gemini &> /dev/null; then
        echo -e "${C_GREEN}Launching Gemini CLI...${C_RESET}"
        gemini
    else
        echo -e "${C_RED} No Gemini CLI installation was found. Falling back to NPX install.${C_RESET}"
        npx https://github.com/google-gemini/gemini-cli
    fi
}

# --- Main Loop ---
while true; do
    show_menu
    read -p "Select an option [1-4]: " choice
    case "$choice" in
        1)
            run_backup
            ;;
        2)
            run_restore
            ;;
        3)
            run_ai_assistant
            ;;
        4)
            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done