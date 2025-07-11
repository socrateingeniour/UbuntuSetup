# Ubuntu Migration & Setup Toolkit

## Overview

This project provides a powerful and flexible toolkit for migrating a personalized Ubuntu desktop environment. It is built as a collection of modular shell scripts, designed to be executed either manually by a user, orchestrated by the included `run.sh` script, or driven by an AI assistant like the Gemini CLI.

The core philosophy is to break down the complex migration process into a series of small, understandable, and single-purpose tools. This allows for greater control, easier debugging, and clear, transparent logging of every action taken.

## Project Architecture

The project is organized into a simple and intuitive directory structure:

-   `run.sh`: The main entry point for most users. It's an interactive script that provides a simple menu to execute the entire backup or restore process, or to launch an AI assistant session.
-   `tools/`: This directory is the heart of the toolkit and contains all the individual scripts that perform the actual work. It's subdivided into:
    -   `backup/`: Contains scripts for archiving your UI, application configs, and software lists.
    -   `restore/`: Contains scripts for installing software and restoring all your backed-up data on a new machine.
-   `backups/`: When you run the backup process, this directory is where your `backup-YYYY-MM-DD_HH-MM-SS.tar.gz` archive will be saved, along with a corresponding `tracker-....txt` file that details its contents.
-   `logs/`: All operations are logged here.
    -   `migration_log_... .log`: A timestamped log file is created for each run, recording every action taken by the tool scripts.
    -   `ai.log`: A dedicated log file for the AI agent to record its own actions, such as modifying scripts in response to errors or user requests.
-   `instructions.md`: The detailed manual for an AI agent or advanced user who wants to execute the scripts manually and understand the specific requirements for agent-driven modification.

## Workflow

The toolkit is designed around two primary workflows: Backup and Restore.

### 1. Backup Workflow

The backup process is executed by the scripts in the `tools/backup/` directory. They run in a specific sequence to create a temporary directory, copy all the necessary files, generate software lists, and finally, compress everything into a single, timestamped `tar.gz` archive in the `backups/` folder.

### 2. Restore Workflow

The restore process uses the scripts in `tools/restore/`. It starts by extracting a backup archive, then proceeds to install software from various sources (APT, Pip, Flathub), restore all your user configurations, and perform final setup tasks.

## How to Use

There are two main ways to use this toolkit:

### Simple Execution

For most users, the easiest way is to use the interactive `run.sh` script:

```bash
./run.sh
```

This will present you with a menu to run the full backup or restore process automatically.

### Advanced / Agent-Driven Execution

For AI agents and advanced users who want granular control, the tool scripts can be executed one by one. The `instructions.md` file provides a detailed, step-by-step guide for this process, including the correct execution order and special instructions for AI-driven modification and logging.