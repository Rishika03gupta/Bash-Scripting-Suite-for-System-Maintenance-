#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

while true; do
  echo "=============================="
  echo "🔧  SYSTEM MAINTENANCE MENU"
  echo "=============================="
  echo "1. Backup Home Directory"
  echo "2. Update & Clean System"
  echo "3. Monitor Logs for Errors"
  echo "4. Schedule Daily Tasks (Cron)"
  echo "5. Exit"
  echo "=============================="
  read -p "Enter choice: " choice

  case $choice in
    1)
      read -p "Enter source directory (default /home): " src
      read -p "Enter destination directory (default /var/backups): " dst
      bash "$SCRIPT_DIR/backup.sh" "${src:-/home}" "${dst:-/var/backups}"
      ;;
    2)
      sudo bash "$SCRIPT_DIR/update.sh"
      ;;
    3)
      read -p "Enter log file path (default /var/log/syslog): " lf
      bash "$SCRIPT_DIR/log_monitor.sh" "${lf:-/var/log/syslog}"
      ;;
    4)
      echo "Setting up cron jobs..."
      (crontab -l 2>/dev/null; echo "0 2 * * * bash $SCRIPT_DIR/backup.sh /home /var/backups") | crontab -
      (crontab -l 2>/dev/null; echo "0 3 * * * sudo bash $SCRIPT_DIR/update.sh") | crontab -
      echo "✅ Cron jobs installed for daily backup (2 AM) and system update (3 AM)"
      ;;
    5)
      echo "Goodbye 👋"
      exit 0
      ;;
    *)
      echo "Invalid option, try again."
      ;;
  esac
done
