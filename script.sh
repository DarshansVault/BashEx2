#!usr/bin/env bash
set -euo pipefail
log() {
	echo -e "\033[0;36m[$(date '+%Y-%m-%d %H:%M:%S')]\033[0m $*"
}
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <target-directory>"
  exit 1
fi

TARGET="$1"

if [[ ! -d "$TARGET" ]]; then
  echo "Error: '$TARGET' is not a directory or doesn't exist."
  exit 1
fi
log "Backup started. Target: $TARGET"
html_count=0
css_count=0
js_count=0

while IFS= read -r -d '' file; do
  html_count=$(( html_count + 1 ))
  has_doctype=$(grep -i '<!DOCTYPE html>' "$file" || true)
  has_html=$(grep -i '<html' "$file" || true)
  if [[ -n "$has_doctype" && -n "$has_html" ]]; then
    log "PASS: $file"
  else
    log "FAIL: $file — missing <!DOCTYPE html> or <html> tag"
  fi

done < <(find "$TARGET" -type f -name "*.html" -print0)
