# Ubuntu Migration Toolkit - Agent Execution Manual

## 1. Overview

This document provides instructions for an AI agent or a human operator on how to use the modular toolkit to perform a backup or restore of a personalized Ubuntu environment. The system is designed for granular, step-by-step execution.

**Core Components:**
- **`tools/`**: Contains all executable scripts, categorized into `backup` and `restore`.
- **`backups/`**: The designated storage for all created backup archives (`.tar.gz`) and their corresponding tracker files (`.txt`).
- **`logs/`**: Contains detailed, timestamped logs of every operation performed by the scripts.
- **`run_migration.sh`**: An optional, interactive script for running the full backup or restore process automatically.

## 2. Agent-Specific Instructions

As an AI agent, you are expected to not only execute the migration tasks but also to be able to modify and adapt the tool scripts in response to errors or user requests. All such actions must be logged.

**Logging Requirements:**
- You must maintain a log file at `logs/ai.log`.
- For every modification you make to a script, you must log the following:
    - **Timestamp**: The date and time of the action.
    - **Trigger**: The reason for the change (e.g., "User Request", "Error Encountered").
    - **File Modified**: The full path to the script you changed.
    - **Problem Description**: A clear explanation of the error or the user's request.
    - **Solution Description**: A detailed explanation of the changes you made to solve the problem.

**Example Log Entry:**
```
[2025-07-12 14:30:00] - AGENT ACTION
- Trigger: Error Encountered
- File Modified: /home/auluna/Projects/UbuntuSetup/tools/restore/pip.sh
- Problem: The script failed because the 'scipy' package was not found.
- Solution: Removed 'scipy' from the list of packages to install and added a comment explaining that it needs to be installed from a different source.
```

## 3. Backup Process

To perform a full backup, execute the following scripts from the `tools/backup/` directory. The order is important.

**Execution Order:**
1.  `ui.sh`
2.  `configs.sh`
3.  `steam.sh`
4.  `appimages.sh`
5.  `software_lists.sh`
6.  `archive.sh`

## 4. Restore Process

To perform a full restore, you will need a backup archive. Execute the following scripts from the `tools/restore/` directory in order.

**Execution Order:**
1.  `user_data.sh [archive_path]`
2.  `apt.sh`
3.  `third_party_repos.sh`
4.  `pip.sh`
5.  `flatpak.sh`
6.  `finalize.sh`
7.  `jetbrains_icons.sh` (Optional)