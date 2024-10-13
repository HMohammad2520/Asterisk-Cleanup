#!/bin/bash

# Directory where call recordings are stored
DIR="/var/spool/asterisk/monitor"

# Directory for storing log files
LOG_DIR="/var/log/asterisk/cleanup_logs"

# Ensure the log directory exists, if not, create it
if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR"
fi

# Generate a log file with a unique timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/cleanup_calls_$TIMESTAMP.log"

# Check if an argument (days) is provided
if [ -z "$1" ]; then
  echo "[$(date)] No argument supplied. Please provide the number of days." | tee -a "$LOG_FILE"
  echo "Usage: $0 <days>"
  exit 1
fi

# Number of days is passed as the first argument
DAYS=$1

# Log the start of the script
echo "[$(date)] Cleanup script started. Deleting .wav files older than $DAYS days." | tee -a "$LOG_FILE"

# Find .wav files older than the specified number of days
OLD_FILES=$(find "$DIR" -type f -name "*.wav" -mtime +$DAYS)

# Check if any files were found
if [ -z "$OLD_FILES" ]; then
  echo "[$(date)] No .wav files older than $DAYS days found." | tee -a "$LOG_FILE"
else
  # Loop through each file found and delete it, logging each action
  echo "[$(date)] Files to be deleted:" | tee -a "$LOG_FILE"
  FILE_COUNT=0

  while IFS= read -r file; do
    echo "[$(date)] Deleting: $file" | tee -a "$LOG_FILE"
    rm -f "$file"
    ((FILE_COUNT++))
  done <<< "$OLD_FILES"

  echo "[$(date)] Deleted $FILE_COUNT .wav files older than $DAYS days." | tee -a "$LOG_FILE"
fi

# Log the completion of the script
echo "[$(date)] Cleanup script completed." | tee -a "$LOG_FILE"
