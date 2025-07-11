 Definitive Migration Plan (v4)

  The process will be managed by a GitHub repository containing the migrate.sh and fix_jetbrains_icons.sh scripts, plus a comprehensive README.md.

  Part 1: The `migrate.sh` Script

  ##### A) `backup` function (On your CURRENT PC)

  This stage is unchanged. It will securely package all your specified user files into a single migration_archive.tar.gz.

   * Files to be backed up:
       * UI: ~/.themes/, ~/.icons/, ~/.local/share/themes/, ~/.local/share/icons/, ~/.fonts/.
       * Configs: ~/.config/dconf/, ~/.config/conky/, ~/.conky/, ~/.config/Code/ (for safety, though settings sync is preferred), ~/.config/wireshark/, ~/.steam/ (excluding
         game data), ~/.local/share/Steam/ (excluding game data), ~/.config/Postman/, ~/.config/discord/, ~/.config/obs-studio/, ~/.config/gdlauncher_next/.
       * AppImage: /home/auluna/Applications/GDLauncher.AppImage and its .desktop file.
       * Software Lists: vscode_extensions.txt, gnome_extensions_list.txt, gnome_extensions_backup.dconf.

  ##### B) `restore` function (On your NEW Laptop)

  This function is now structured according to your new installation hierarchy.

   1. Install Base Software & System Tools (via APT):
       * What: Core utilities and applications sourced directly from Ubuntu's repositories.
       * Apps to be installed: gnome-tweaks, conky, flatpak, gnome-shell-extension-manager, wget, gpg, python3-pip.

   2. Install Software from Third-Party Repositories (via APT):
       * What: Trusted applications that provide their own official repositories for Debian/Ubuntu.
       * Visual Studio Code: The script will add the official Microsoft GPG key and repository, then install code.
       * Java 21: The script will add the official Adoptium/Temurin GPG key and repository, then install temurin-21-jdk.

   3. Install Python Libraries (via Pip):
       * What: The comprehensive list of recommended Python libraries.
       * Libraries to be installed: numpy, scipy, matplotlib, pandas, jupyterlab, scikit-learn, seaborn.

   4. Install Applications (via Flathub):
       * What: The remainder of your graphical applications, installed from Flathub. The script will clearly distinguish between verified and unverified apps.
       * Action: The script will add the Flathub remote repository.
       * Verified Apps to be installed:
           * org.wireshark.Wireshark (Wireshark)
           * com.valvesoftware.Steam (Steam)
           * com.discordapp.Discord (Discord)
           * com.obsproject.Studio (OBS Studio)
           * io.github.flattool.Warehouse (Warehouse)
           * io.missioncenter.MissionCenter (Mission Center)
           * com.github.tchx84.Flatseal (Flatseal)
       * Unverified Apps to be installed:
           * com.getpostman.Postman (Postman)
           * io.dbeaver.DBeaverCommunity (DBeaver)
       * Instruction: The README.md will contain a prominent section explaining why these apps are unverified and provide explicit, step-by-step instructions on how to use
         Flatseal to review and restrict their permissions (e.g., limit filesystem access, disable network access if not needed).

   5. Restore All User Data:
       * Action: The migration_archive.tar.gz will be extracted, copying all your themes, icons, fonts, and application configurations to their correct locations.

   6. Finalize Application Setups:
       * GDLauncher: The AppImage will be moved to ~/Applications/, made executable, and its .desktop file restored.
       * VS Code & GNOME Shell: Extensions will be reinstalled and configured using the backed-up files.

  Part 2: The `fix_jetbrains_icons.sh` Script

  This script remains unchanged. It is a separate tool for you to run after you have manually installed your IDEs using the JetBrains Toolbox. It will find the .desktop files
  and apply your "candy-icons" theme to them.
