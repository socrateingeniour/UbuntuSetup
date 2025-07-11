#!/bin/bash

# --- Logger ---
log_action() {
    local message="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\033[0;34m[ACTION] $message\033[0m"
    echo "[$timestamp] - $message" >> "$MIGRATION_LOG_FILE"
}

# --- Main Logic --- 
log_action "Starting installation of Python packages via Pip..."

PACKAGES_TO_INSTALL=(
    numpy
    scipy
    matplotlib
    pandas
    jupyterlab
    scikit-learn
    seaborn
)

for pkg in "${PACKAGES_TO_INSTALL[@]}"; do
    log_action "Installing $pkg..."
    pip install "$pkg"
done

log_action "Python package installation completed."
