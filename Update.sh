#!/usr/bin/env bash
set -euo pipefail

# Works on Debian/Ubuntu; modify apt commands for other distros.
LOGFILE="/var/log/maintenance_update_$(date +%F).log"

{
  echo "========== System Update Log =========="
  echo "Start time: $(date)"
  sudo apt update
  sudo apt -y upgrade
  sudo apt -y autoremove
  sudo apt -y autoclean
  echo ""
  echo "Disk usage after update:"
  df -h
  echo "======================================="
  echo "End time: $(date)"
} | tee "$LOGFILE"
