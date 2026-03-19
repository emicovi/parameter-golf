#!/usr/bin/env bash
set -euo pipefail

FORK_URL="${FORK_URL:-https://github.com/emicovi/parameter-golf.git}"
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/openai/parameter-golf.git}"
TARGET_DIR="${TARGET_DIR:-/workspace/parameter-golf}"
BRANCH="${BRANCH:-codex/runpod-setup}"

if [ ! -d "${TARGET_DIR}/.git" ]; then
  git clone "${FORK_URL}" "${TARGET_DIR}"
fi

cd "${TARGET_DIR}"

if ! git remote get-url upstream >/dev/null 2>&1; then
  git remote add upstream "${UPSTREAM_URL}"
fi

git fetch origin
git fetch upstream

if git show-ref --verify --quiet "refs/remotes/origin/${BRANCH}"; then
  git checkout -B "${BRANCH}" "origin/${BRANCH}"
else
  git checkout -B "${BRANCH}" upstream/main
fi

git status --short --branch

echo
echo "Repo ready in ${TARGET_DIR}"
echo "Current branch: ${BRANCH}"
