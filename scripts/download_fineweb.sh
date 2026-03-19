#!/usr/bin/env bash
set -euo pipefail

SHARDS="${1:-1}"
VARIANT="${VARIANT:-sp1024}"

python3 data/cached_challenge_fineweb.py --variant "${VARIANT}" --train-shards "${SHARDS}"
