#!/usr/bin/env bash
set -euo pipefail

# プロジェクトルートへ移動（このスクリプトの親=../）
cd "$(dirname "$0")/.."

echo "[info] project: $(pwd)"

# 1) venv 準備＆有効化
if [ ! -d ".venv" ]; then
  echo "[info] creating venv..."
  python3 -m venv .venv
fi
# shellcheck disable=SC1091
source .venv/bin/activate
echo "[info] python: $(which python)"

# 2) requirements.txt 自動化
#    無ければ最小セットを作成（必要に応じて編集してね）
if [ ! -f "requirements.txt" ]; then
  echo "[info] no requirements.txt -> creating minimal one"
  printf "pandas\nmatplotlib\n" > requirements.txt
fi

echo "[info] installing requirements..."
python -m pip install --upgrade pip >/dev/null
pip install -r requirements.txt >/dev/null

# （任意）LOCK=1 で実行した時はピン止めを更新
if [ "${LOCK:-0}" = "1" ]; then
  echo "[info] writing pinned versions to requirements.lock.txt"
  pip freeze > requirements.lock.txt
fi

# 3) 実行
SRC="data/log_sample.csv"
echo "[info] running pipeline..."
python src/read_csv.py "$SRC"
python src/filter_error.py "$SRC"
python src/daily_plot.py "$SRC"
python src/level_timeseries.py "$SRC"

echo "[done] outputs -> ./output/"