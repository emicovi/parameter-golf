#!/usr/bin/env bash
set -euo pipefail

# Proxy full-budget run for the best currently available large box on Runpod.
# Keeps per-GPU train tokens aligned with the 8xH100 recipe.

NPROC_PER_NODE="${NPROC_PER_NODE:-7}" \
GRAD_ACCUM_STEPS="${GRAD_ACCUM_STEPS:-1}" \
TRAIN_BATCH_TOKENS="${TRAIN_BATCH_TOKENS:-688128}" \
VAL_BATCH_SIZE="${VAL_BATCH_SIZE:-516096}" \
QTAIL_START_FRAC="${QTAIL_START_FRAC:-0.75}" \
bash "$(dirname "$0")/run_qtail_8xh100.sh"
