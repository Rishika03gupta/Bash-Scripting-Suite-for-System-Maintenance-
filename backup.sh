#!/usr/bin/env bash
set -euo pipefail

# Configuration
SRC_DIR=${1:-/home}
DEST_DIR=${2:-/var/backups}
TIMESTAMP=$(date +"%F_%H-%M-%S")
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
LOGFILE="${DEST_DIR}/backup_${TIMESTAMP}.log"

mkdir -p "$DEST_DIR"

# Create compressed backup
if tar -czf "$DEST_DIR/$BACKUP_NAME" -C "$SRC_DIR" . >"$LOGFILE" 2>&1; then
  echo "✅ Backup successful: $DEST_DIR/$BACKUP_NAME" | tee -a "$LOGFILE"
  echo "Completed at $(date)" >> "$LOGFILE"
  exit 0
else
  echo "❌ Backup failed. See $LOGFILE" >&2
  exit 2
fi
