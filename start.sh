#!/usr/bin/env bash
set -euo pipefail

PORT=8000
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
URL="http://localhost:${PORT}/wake_lock.html"

cd "${SCRIPT_DIR}/src"

case "$(uname -s)" in
  Darwin) (sleep 1 && open "${URL}") & ;;
  Linux)  (sleep 1 && xdg-open "${URL}" >/dev/null 2>&1) & ;;
esac

echo "Serving wake_lock at ${URL}"
exec python3 -m http.server "${PORT}" --bind 127.0.0.1
