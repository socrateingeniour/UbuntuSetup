# Migration Instructions

This document provides a detailed, step-by-step guide for migrating your Ubuntu environment using the scripts in this repository.

## How It Works

The process is broken into three main stages:

1.  **Backup (On your OLD machine):** You will run a script to gather all your important configuration files and package them into a single archive file.
2.  **Transfer:** You will move this archive to your new machine (e.g., via a USB drive, cloud storage, or by committing it to this Git repository).
3.  **Restore (On your NEW machine):** You will run a script that installs all the necessary software and then restores all your configurations from the archive.

---

## Step 1: Backup Your Current System

On your **current (old) computer**, follow these steps:

1.  **Open a terminal** in this repository's directory (`/home/auluna/Projects/UbuntuSetup/`).

2.  **Make the migration script executable:**
    ```bash
    chmod +x migrate.sh
    ```

3.  **Run the backup command:**
    ```bash
    ./migrate.sh backup
    ```

This will create a file named `migration_archive.tar.gz` in the current directory. This file contains all your backed-up data.

---

## Step 2: Prepare Your New System

On your **new (freshly installed Ubuntu) computer**, follow these steps:

1.  **Clone this repository** to your new machine.

2.  **Place the `migration_archive.tar.gz` file** you created in Step 1 into the same directory as the scripts.

3.  **Make the migration script executable:**
    ```bash
    chmod +x migrate.sh
    ```

---

## Step 3: Restore Your System

On your **new computer**, run the restore command:

```bash
./migrate.sh restore
```

The script will perform a fully automated installation of the following software:

<details>
<summary><b>Click to view the full software manifest</b></summary>

**1. Base System & Utilities (from Ubuntu APT Repository)**
- `gnome-tweaks`: For advanced GNOME desktop customization.
- `conky`: For the system monitor display.
- `flatpak`: The framework for running sandboxed applications.
- `gnome-shell-extension-manager`: To manage your GNOME extensions.
- `wget`: Utility for downloading files.
- `gpg`: For managing encryption keys.
- `python3-pip`: The package installer for Python.

**2. Third-Party Repositories (Installed via APT)**
- `code`: Visual Studio Code (from the official Microsoft repository).
- `temurin-21-jdk`: Eclipse Temurin JDK 21 (from the official Adoptium repository).

**3. Python Libraries (Installed via Pip)**
- `numpy`
- `scipy`
- `matplotlib`
- `pandas`
- `jupyterlab`
- `scikit-learn`
- `seaborn`

**4. Flatpak Applications (Installed from Flathub)**
- **Verified:**
  - `org.wireshark.Wireshark` (Wireshark)
  - `com.valvesoftware.Steam` (Steam)
  - `com.discordapp.Discord` (Discord)
  - `com.obsproject.Studio` (OBS Studio)
  - `io.github.flattool.Warehouse` (Warehouse)
  - `io.missioncenter.MissionCenter` (Mission Center)
  - `com.github.tchx84.Flatseal` (Flatseal)
- **Unverified:**
  - `com.getpostman.Postman` (Postman)
  - `io.dbeaver.DBeaverCommunity` (DBeaver)

</details>

It will also restore all your themes, icons, fonts, and application configurations, and set up your VS Code and GNOME extensions.

After the script finishes, **log out and log back in** to ensure all changes are applied correctly.

---

## Post-Installation Tasks

### 1. Secure Unverified Flatpak Apps

The script installed **Postman** and **DBeaver** from Flathub, but they are from unverified developers. It is highly recommended that you review and restrict their permissions.

1.  Open the **Flatseal** application.
2.  Select **Postman** from the list on the left.
3.  Review its permissions. A good practice is to disable **All user files** under the `Filesystem` section if you only access projects within your home directory.
4.  Repeat the process for **DBeaver**.

### 2. Configure JetBrains IDEs

This step is only necessary **after** you have installed your JetBrains IDEs (like IntelliJ or PyCharm) using the **JetBrains Toolbox**.

1.  Once your IDEs are installed, open a terminal in this repository's directory.

2.  **Make the setup script executable:**
    ```bash
    chmod +x JetbrainsSetup.sh
    ```

3.  **Run the script:**
    ```bash
    ./JetbrainsSetup.sh
    ```

This will automatically detect your installed IDEs and update their icons to match your system's icon theme.
