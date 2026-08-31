# linux-server-monitoring-backup
Bash-based Linux server monitoring, process management and backup automation.
# Linux Server Monitoring, Process Management & Backup Automation

## Project Overview

A Bash-based Linux administration project developed to monitor
server health, manage processes, and automate system backups.

## Features

- CPU monitoring
- Memory monitoring
- Disk usage monitoring
- Internet connectivity check
- SSH port monitoring
- SSH service status check
- Process monitoring
- System health report generation
- Memory usage logging
- Home directory backup
- Compressed backup using tar

## Technologies Used

- Linux
- Bash Shell Scripting
- ps
- top
- free
- df
- ss
- systemctl
- tar
- awk

## How to Run

```bash
chmod +x server_monitor.sh
sudo ./server_monitor.sh

Backup

The script creates a compressed backup of the
/home directory using tar.

Monitoring

The script displays CPU, memory, disk, process,
network and SSH information.

Author

Barathraj V L

