#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

#===========================================================
# Linux Server Monitoring & Backup Automation Project
# Author : Your Name
#===========================================================

BACKUP_DIR="/backup"
SOURCE_DIR="/home"
LOG_DIR="/var/log/server_monitor"

mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

DATE=$(date +%F_%H-%M-%S)

echo "========================================="
echo " Linux Server Monitoring Project"
echo "========================================="
echo

###################################################
# Host Information
###################################################

echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo "Uptime   : $(uptime -p)"
echo

###################################################
# CPU Usage
###################################################

echo "========== CPU =========="
top -bn1 | head -5
echo

###################################################
# Memory Usage
###################################################

echo "========== MEMORY =========="
free -h
echo

MEM=$(free | awk '/Mem/ {print int($3/$2*100)}')

if [ "$MEM" -gt 85 ]
then
    echo "$(date) WARNING : Memory Usage = ${MEM}%" >> "$LOG_DIR/memory.log"
fi

###################################################
# Disk Usage
###################################################

echo "========== DISK =========="
df -h
echo

DISK=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

if [ "$DISK" -gt 80 ]
then
    echo "$(date) WARNING : Disk Usage = ${DISK}%" >> "$LOG_DIR/disk.log"
fi

###################################################
# Running Services
###################################################

echo "========== SERVICES =========="

SERVICES=("sshd" "crond")

for SERVICE in "${SERVICES[@]}"
do

if systemctl is-active --quiet "$SERVICE"
then
    echo "$SERVICE : Running"
else
    echo "$SERVICE : Stopped"

    echo "Restarting $SERVICE..."

    systemctl restart "$SERVICE"

    echo "$(date) Restarted $SERVICE" >> "$LOG_DIR/service.log"
fi

done

echo

###################################################
# Network
###################################################

echo "========== NETWORK =========="

ip addr | grep inet

echo

###################################################
# Logged Users
###################################################

echo "========== USERS =========="

who

echo

###################################################
# Top Processes
###################################################

echo "========== TOP PROCESSES =========="

ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head

echo

###################################################
# Backup
###################################################

echo "========== BACKUP =========="

FILE="home_backup_${DATE}.tar.gz"

tar -czf "$BACKUP_DIR/$FILE" "$SOURCE_DIR"

if [ $? -eq 0 ]
then
    echo "Backup Successful"

    echo "$(date) Backup Completed : $FILE" >> "$LOG_DIR/backup.log"

else

    echo "Backup Failed"

    echo "$(date) Backup Failed" >> "$LOG_DIR/backup.log"

fi

echo

###################################################
# Delete Old Backups
###################################################

find "$BACKUP_DIR" -name "*.tar.gz" -mtime +30 -delete

echo "$(date) Old Backups Deleted" >> "$LOG_DIR/cleanup.log"

###################################################
# Internet Check
###################################################

echo
echo "========== INTERNET =========="

if ping -c 2 8.8.8.8 >/dev/null
then
    echo "Internet Connected"
else
    echo "Internet Not Available"
fi

###################################################
# SSH Port Check
###################################################

echo
echo "========== SSH PORT =========="

ss -tulnp | grep :22

###################################################
# Report
###################################################

REPORT="$LOG_DIR/report_$DATE.txt"

{
echo "Linux Daily Health Report"

echo

hostname

date

echo

free -h

echo

df -h

echo

uptime

echo

systemctl status sshd --no-pager

} > "$REPORT"

echo
echo "========================================="
echo " Project Completed Successfully"
echo " Report : $REPORT"
echo " Backup : $BACKUP_DIR/$FILE"
echo "========================================="
