# How to Use the Migration Toolkit

## Overview

This project uses scripts to back up and restore your Ubuntu environment. You can run the whole process automatically or step-by-step.

## Automatic Mode

To run the full backup or restore process, use the `run.sh` script:

```
bash run.sh
```

Follow the menu options. This script will create one log file for the entire run in the `logs/` directory.

It also has an option to launch the Gemini CLI for AI assistance.

## Manual Mode (For Agents or Advanced Users)

You can run each script individually for more control.

### Backup Process

Run these scripts from the `tools/backup/` folder in this order:

1.  `ui.sh`
2.  `configs.sh`
3.  `steam.sh`
4.  `appimages.sh`
5.  `software_lists.sh`
6.  `archive.sh`

### Restore Process

Run these scripts from the `tools/restore/` folder in this order:

1.  `user_data.sh [path_to_archive]`
2.  `apt.sh`
3.  `third_party_repos.sh`
4.  `pip.sh`
5.  `flatpak.sh`
6.  `finalize.sh`
7.  `jetbrains_icons.sh` (Optional)

### AI Agent Instructions

If you are an AI agent modifying these scripts, you must log your changes in `logs/ai.log`. For each change, record:

- The reason for the change (error or user request).
- The name of the file you modified.
- A description of the problem.
- A description of your solution.
