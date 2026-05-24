#!/usr/bin/env bash
# Intake Placement Coach — local launcher
# Serves index.html via a local HTTP server (required for webcam access).

set -e
cd "$(dirname "$0")"
PORT="${PORT:-8765}"
URL="http://localhost:$PORT/"

pick_server() {
  if command -v python3 >/dev/null 2>&1; then
    echo "python3 -m http.server $PORT --bind 127.0.0.1"
  elif command -v python >/dev/null 2>&1; then
    echo "python -m http.server $PORT --bind 127.0.0.1"
  elif command -v npx >/dev/null 2>&1; then
    echo "npx --yes http-server -p $PORT -c-1 -a 127.0.0.1"
  else
    echo ""
  fi
}

CMD="$(pick_server)"
if [ -z "$CMD" ]; then
  echo "❌ No HTTP server found. Install python3 (recommended) or node."
  exit 1
fi

echo "🚀 Intake Placement Coach"
echo "   → $URL"
echo "   (Ctrl+C to stop)"
echo

# Start server in background
eval "$CMD" >/dev/null 2>&1 &
SERVER_PID=$!
trap 'kill $SERVER_PID 2>/dev/null || true' EXIT INT TERM

# Wait briefly for port to bind, then open browser
sleep 0.6
if command -v open >/dev/null 2>&1; then
  open "$URL"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$URL"
fi

wait $SERVER_PID
