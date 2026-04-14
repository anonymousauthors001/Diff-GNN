#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PYTHONNOUSERSITE=1
PYTHON="${PYTHON:-python}"
SOLVER_TOOL="${SOLVER_TOOL:-cvxpy}"

cd "$ROOT"

echo "Running MIP sweeps locally"

# for area in 0.1 0.3 0.5 0.7 0.9; do
#   for hw in 0.1 0.3 0.5 0.7 0.9; do
#     for seed in 0 1 2 3; do

for area in 0.1; do
  for hw in 0.1; do
    for seed in 1; do
      config="$ROOT/configs/config_mkspan_area_${area}_hw_${hw}_seed_${seed}.yaml"
      if [[ ! -f "$config" ]]; then
        echo "Config not found: $config (skipping)"
        continue
      fi
      echo "---- area=${area} hw=${hw} seed=${seed} ----"
      echo "Config: $config"
      "$PYTHON" "$ROOT/milp_eval.py" -c "$config" -t "$SOLVER_TOOL"
    done
  done
done

echo "Finished. Outputs:"
echo " - Logs: logs/run_milp_optimizer_area-<area>_hw-<hw>_seed-<seed>.log"
echo " - Partitions: saved in the config 'solution-dir' (e.g., makespan-opt-partitions/ or makespan-mip-opt-partitions/) with filenames like taskgraph-...-assignment-mip.pkl"
