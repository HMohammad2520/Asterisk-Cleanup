# Asterisk Call Cleanup Script Documentation

## Overview
This document outlines the steps taken to implement a cleanup script for the Asterisk PBX server. The script automatically deletes `.wav` files older than a specified number of days from the `/var/spool/asterisk/monitor` directory to manage disk space efficiently.

## Installation
You can install the cleanup script using one of the following methods:

### Method 1: Download and Move the File
1. Download the script to your desired location:
   ```bash
   wget https://github.com/radin-system/Asterisk-Cleanup/raw/main/cleanup_calls.sh -O /tmp/cleanup_calls.sh
   ```
2. Move the downloaded script to the appropriate directory:
   ```bash
   mv /tmp/cleanup_calls.sh /opt/cleanup_calls/cleanup_calls.sh
   ```
3. Set the script permissions to make it executable:
   ```bash
   chmod +x /opt/cleanup_calls/cleanup_calls.sh
   ```

### Method 2: Using Git
1. Make the Directory and move there
   ```bash
   mkdir /opt/cleanup_calls/
   cd /opt/cleanup_calls/
   ```
2. Clone the repository containing the cleanup script:
   ```bash
   git clone https://github.com/radin-system/Asterisk-Cleanup.git
   ```
3. Set the script permissions to make it executable:
   ```bash
   chmod +x /opt/cleanup_calls/cleanup_calls.sh
   ```

## Cron Job Setup
The following cron jobs were added to automate the execution of the cleanup script:


1. **Add script to crontab**:
   ```bash
   crontab -e
   ```

2.1. **Run daily at midnight**:
   ```bash
   0 0 * * * /opt/cleanup_calls/cleanup_calls.sh 365 >> /var/log/cleanup_calls.log 2>&1 
   ```

2.2. **Run every hour at 1 minute past the hour**:
   ```bash
   1 * * * * /opt/cleanup_calls/cleanup_calls.sh 365 >> /var/log/cleanup_calls.log 2>&1
   ```

### Explanation of Cron Jobs:
- **`0 0 * * *`**: This cron expression indicates that the job will run every day at midnight.
- **`1 * * * *`**: This cron expression indicates that the job will run every hour, 1 minute past the hour.
- **`/opt/cleanup_calls/cleanup_calls.sh 365`**: This command executes the cleanup script, where `365` is the argument specifying the number of days to keep `.wav` files. Files older than 365 days will be deleted.
- **`>> /var/log/cleanup_calls.log 2>&1`**: This part of the command appends both standard output and standard error to the log file located at `/var/log/cleanup_calls.log`. This allows for monitoring and troubleshooting of the script's execution.

## Logging
The script's output is logged to `/var/log/cleanup_calls.log`, which captures:
- Successful deletions of old `.wav` files.
- Any error messages encountered during execution.
  
### Example Logging Entry:
```
Deleted: /var/spool/asterisk/monitor/recording_2023-01-01.wav
```

## Conclusion
By implementing this cleanup script and scheduling it with cron, we can ensure that the Asterisk PBX server maintains adequate disk space by removing outdated call recordings automatically. This setup helps prevent storage issues that could disrupt service.

## Attachments
- [cleanup_calls.sh](path_to_your_script/cleanup_calls.sh)
