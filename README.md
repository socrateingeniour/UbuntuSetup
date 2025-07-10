# Ubuntu Migration & Setup Project

## Overview

This project provides a semi-automated solution for migrating a personalized Ubuntu desktop environment from one machine to another. It is designed to transfer themes, icons, application settings, and reinstall a specific set of software, ensuring a consistent user experience across different computers.

## Core Features

- **Backup & Restore:** A core script (`migrate.sh`) handles the heavy lifting of packaging user configurations into a single archive and restoring them on a new system.
- **Automated Software Installation:** The restore script installs applications from various sources, including APT, third-party repositories (for VS Code, Java), Pip (for Python libraries), and Flathub.
- **Security-Conscious Installation:** The script prioritizes verified software sources and includes instructions for sandboxing unverified Flatpak applications using Flatseal.
- **Post-Install Configuration:** A separate script (`JetbrainsSetup.sh`) is provided to handle post-installation tasks, such as theming JetBrains IDE icons to match the system look and feel.

## How to Use

For a detailed, step-by-step guide on how to use these scripts, please refer to the **[instructions.md](instructions.md)** file.