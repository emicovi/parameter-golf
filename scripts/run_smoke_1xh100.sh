#!/usr/bin/env bash
set -euo pipefail

# Cheap sanity-check run for 1xH100 iteration. This is not meant to match
# leaderboard conditions exactly; it is only for fast feedback before using
# more expensive hardware.

RUN_ID="${RUN_ID:-smoke_1xh100}"
DATA_PATH="${DATA_PATH:-./data/datasets/fineweb10B_sp1024/}"
TOKENIZER_PATH="${TOKENIZER_PATH:-./data/tokenizers/fineweb_1024_bpe.model}"
VOCAB_SIZE="${VOCAB_SIZE:-1024}"
MAX_WALLCLOCK_SECONDS="${MAX_WALLCLOCK_SECONDS:-300}"
TRAIN_BATCH_TOKENS="${TRAIN_BATCH_TOKENS:-131072}"
TRAIN_LOG_EVERY="${TRAIN_LOG_EVERY:-100}"
VAL_LOSS_EVERY="${VAL_LOSS_EVERY:-0}"

RUN_ID="${RUN_ID}" \
DATA_PATH="${DATA_PATH}" \
TOKENIZER_PATH="${TOKENIZER_PATH}" \
VOCAB_SIZE="${VOCAB_SIZE}" \
MAX_WALLCLOCK_SECONDS="${MAX_WALLCLOCK_SECONDS}" \
TRAIN_BATCH_TOKENS="${TRAIN_BATCH_TOKENS}" \
TRAIN_LOG_EVERY="${TRAIN_LOG_EVERY}" \
VAL_LOSS_EVERY="${VAL_LOSS_EVERY}" \
torchrun --standalone --nproc_per_node=1 train_gpt.py
