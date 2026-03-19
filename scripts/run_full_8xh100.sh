#!/usr/bin/env bash
set -euo pipefail

# Full verification run for an 8xH100 SXM box.
# By default it runs the current strongest merged standalone record script.

RUN_ID="${RUN_ID:-verify_8xh100}"
DATA_PATH="${DATA_PATH:-./data/datasets/fineweb10B_sp1024/}"
TOKENIZER_PATH="${TOKENIZER_PATH:-./data/tokenizers/fineweb_1024_bpe.model}"
VOCAB_SIZE="${VOCAB_SIZE:-1024}"
MAX_WALLCLOCK_SECONDS="${MAX_WALLCLOCK_SECONDS:-600}"
RUN_SCRIPT="${RUN_SCRIPT:-records/track_10min_16mb/2026-03-19_TrainingOptSeq4096/train_gpt.py}"
NPROC_PER_NODE="${NPROC_PER_NODE:-8}"

RUN_ID="${RUN_ID}" \
DATA_PATH="${DATA_PATH}" \
TOKENIZER_PATH="${TOKENIZER_PATH}" \
VOCAB_SIZE="${VOCAB_SIZE}" \
MAX_WALLCLOCK_SECONDS="${MAX_WALLCLOCK_SECONDS}" \
torchrun --standalone --nproc_per_node="${NPROC_PER_NODE}" "${RUN_SCRIPT}"
