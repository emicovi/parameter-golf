# Runpod Workflow

This repo is set up for a local-edit, remote-compute workflow:

- Edit code and manage git locally.
- Push branches to your fork.
- Clone the same branch on Runpod for dataset download, training, and evaluation.

## Remotes

Your local clone should have:

- `origin`: `https://github.com/emicovi/parameter-golf.git`
- `upstream`: `https://github.com/openai/parameter-golf.git`

Keep `main` close to upstream and do experiments on `codex/*` or `emicovi/*` branches.

## Local Flow

Create or update a working branch:

```bash
git fetch upstream
git checkout main
git merge --ff-only upstream/main
git push origin main
git checkout -b codex/exp-01
```

After changes:

```bash
git status
git add .
git commit -m "Describe the experiment"
git push -u origin codex/exp-01
```

## Runpod Flow

Use cheaper GPUs for iteration first. Use `8xH100 SXM` only for final verification or submission-quality runs.

Suggested order:

1. Run `scripts/runpod_setup.sh` on the pod.
2. Download only `1` training shard while iterating.
3. Use `scripts/run_smoke_1xh100.sh` for a short sanity check.
4. When the config is stable, download the full dataset.
5. Use `scripts/run_full_8xh100.sh` on an `8xH100 SXM` box.

## Pod Commands

Quick setup on Runpod:

```bash
cd /workspace
git clone --branch codex/runpod-setup https://github.com/emicovi/parameter-golf.git parameter-golf
cd /workspace/parameter-golf
bash scripts/runpod_setup.sh
bash scripts/download_fineweb.sh 1
bash scripts/run_smoke_1xh100.sh
```

Full dataset download:

```bash
cd /workspace/parameter-golf
bash scripts/download_fineweb.sh 80
```

Final verification on `8xH100 SXM`:

```bash
cd /workspace/parameter-golf
RUN_SCRIPT=records/track_10min_16mb/2026-03-19_TrainingOptSeq4096/train_gpt.py \
bash scripts/run_full_8xh100.sh
```

## Notes

- `--train-shards 1` reduces download size and iteration cost, but it does not by itself shorten a run. Shorter tests come from lowering `MAX_WALLCLOCK_SECONDS`.
- `scripts/run_smoke_1xh100.sh` is intentionally a cheap screen, not a leaderboard-comparable run.
- For a real submission, save the final `train.log`, exact `train_gpt.py`, and `submission.json` in a new folder under `records/`.
