#!/usr/bin/env bash
set -euo pipefail

LOG_FILE=${1:-/var/log/syslog}
OUT_DIR=${2:-/var/log/maintenance_reports}
mkdir -p "$OUT_DIR"

REPORT="$OUT_DIR/log_alert_$(date +%F_%H-%M-%S).txt"

# Extract critical log lines
if [ -f "$LOG_FILE" ]; then
  echo "===== Log Alert Report =====" > "$REPORT"
  echo "Generated at: $(date)" >> "$REPORT"
  echo "Source file: $LOG_FILE" >> "$REPORT"
  echo "-----------------------------" >> "$REPORT"

  grep -iE "error|fail|critical|panic" "$LOG_FILE" | tail -n 200 >> "$REPORT" || true

  if [ "$(wc -l < "$REPORT")" -gt 5 ]; then
    echo "⚠️  Found suspicious entries. Report saved at $REPORT"
    # Optional: send via mail
    # mail -s "System Log Alert - $(hostname)" admin@example.com < "$REPORT"
  else
    echo "No critical entries found."
  fi
else
  echo "❌ Log file not found: $LOG_FILE" >&2
  exit 1
fi
