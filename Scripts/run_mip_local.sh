#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON="${PYTHON:-python}"
SOLVER_TOOL="${SOLVER_TOOL:-cvxpy}"
CONFIG_PATH="${1:-$ROOT/configs/config_mkspan_default_gnn.yaml}"

if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "Config not found: $CONFIG_PATH"
  exit 1
fi

export PYTHONNOUSERSITE=1
cd "$ROOT"

echo "Running a single local MIP solve"
echo "Config: $CONFIG_PATH"
echo "Solver: $SOLVER_TOOL"

"$PYTHON" "$ROOT/milp_eval.py" -c "$CONFIG_PATH" -t "$SOLVER_TOOL"
