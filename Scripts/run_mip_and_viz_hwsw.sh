#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PYTHONNOUSERSITE=1
PYTHON="${PYTHON:-python}"
cd "$ROOT"

CONFIG="${CONFIG:-$ROOT/configs/config_mkspan_default_gnn.yaml}"
DOT="${DOT:-$ROOT/inputs/task_graph_topology/soda-benchmark-graphs/pytorch-graphs/squeeze_net_tosa.dot}"
OUTDIR="${OUTDIR:-$ROOT/Figs/hwsw}"
mkdir -p "$OUTDIR"

echo "[mip] Running milp_eval with $CONFIG"
"$PYTHON" "$ROOT/milp_eval.py" -c "$CONFIG" -t "${SOLVER_TOOL:-cvxpy}"

echo "[mip] Solve completed."

# Find latest MIP partition pickle produced by milp_eval
PARTITION_PKL=$(ls -t makespan-opt-partitions/*assignment-mip.pkl 2>/dev/null | head -n1)
if [[ -z "$PARTITION_PKL" ]]; then
  echo "Partition pickle not found in makespan-opt-partitions/. Exiting."
  exit 1
fi

OUTPNG="$OUTDIR/partition_overlay.png"
echo "[viz] Drawing partition -> $OUTPNG"
"$PYTHON" "$ROOT/viz_hwsw_partition.py" \
  --dot "$DOT" \
  --partition "$PARTITION_PKL" \
  --out "$OUTPNG"

echo "Done."
