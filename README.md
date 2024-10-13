# Asterisk Call Cleanup Script Documentation

## Overview
This document outlines the steps taken to implement a cleanup script for the Asterisk PBX server. The script automatically deletes `.wav` files older than a specified number of days from the `/var/spool/asterisk/monitor` directory to manage disk space efficiently.

## Script Location
The cleanup script is located at:
```
/opt/cleanup_calls/cleanup_calls.sh
```

## Script Permissions
To ensure that the script is executable, the following command was run:
```bash
chmod +x /opt/cleanup_calls/cleanup_calls.sh
```

## Cron Job Setup
The following cron jobs were added to automate the execution of the cleanup script:

1. **Run daily at midnight**:
   ```bash
   0 0 * * * /opt/cleanup_calls/cleanup_calls.sh 9 >> /var/log/cleanup_calls.log 2>&1
   ```

2. **Run every hour at 1 minute past the hour**:
   ```bash
   1 * * * * /opt/cleanup_calls/cleanup_calls.sh 9 >> /var/log/cleanup_calls.log 2>&1
   ```

### Explanation of Cron Jobs:
- **`0 0 * * *`**: This cron expression indicates that the job will run every day at midnight.
- **`1 * * * *`**: This cron expression indicates that the job will run every hour, 1 minute past the hour.
- **`/opt/cleanup_calls/cleanup_calls.sh 9`**: This command executes the cleanup script, where `9` is the argument specifying the number of days to keep `.wav` files. Files older than 9 days will be deleted.
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
