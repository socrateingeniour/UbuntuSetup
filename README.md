# Ubuntu Migration Toolkit

This project helps you back up and restore your Ubuntu setup.

## Project Structure

- `tools/`: Contains the scripts for backup and restore.
- `backups/`: Stores the backup archives.
- `logs/`: Stores the log files.
- `run.sh`: A script to run the full backup or restore process.
- `instructions.md`: Explains how to use the scripts.

The `backups` and `logs` folders are ignored by Git.

## How to Use

Run the `run.sh` script to start:

```
bash run.sh
```

This will give you a menu to choose what to do. For more details, see `instructions.md`.
