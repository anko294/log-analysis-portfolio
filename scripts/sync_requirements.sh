#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -d ".venv" ]; then
  echo "[error] .venv not found. run: bash scripts/run_all.sh"
  exit 1
fi
# shellcheck disable=SC1091
source .venv/bin/activate

echo "[info] freezing current venv to requirements.txt"
pip freeze > requirements.txt
echo "[done] requirements.txt updated (pinned)"
