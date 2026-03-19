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
3. Use `scripts/run_qtail_1xh100.sh` for the current `QTAIL_STE` candidate, or `scripts/run_smoke_1xh100.sh` for the generic baseline smoke path.
4. When the config is stable, download the full dataset.
5. Use `scripts/run_qtail_8xh100.sh` on an `8xH100 SXM` box.
6. Reuse `scripts/run_pricebook_eval.sh` when you want export-only fp16 island sweeps on an existing `final_model.pt`.

## Pod Commands

Quick setup on Runpod:

```bash
cd /workspace
git clone --branch codex/runpod-setup https://github.com/emicovi/parameter-golf.git parameter-golf
cd /workspace/parameter-golf
bash scripts/runpod_setup.sh
bash scripts/download_fineweb.sh 1
bash scripts/run_qtail_1xh100.sh
```

Full dataset download:

```bash
cd /workspace/parameter-golf
bash scripts/download_fineweb.sh 80
```

Full QTAIL run on `8xH100 SXM`:

```bash
cd /workspace/parameter-golf
bash scripts/run_qtail_8xh100.sh
```

Export-only `PriceBook` sweep from a saved dense checkpoint:

```bash
cd /workspace/parameter-golf
INIT_STATE_PATH=./final_model.pt FP16_TAIL_V_LAYERS=1 \
bash scripts/run_pricebook_eval.sh
```

## Notes

- `--train-shards 1` reduces download size and iteration cost, but it does not by itself shorten a run. Shorter tests come from lowering `MAX_WALLCLOCK_SECONDS`.
- `scripts/run_qtail_1xh100.sh` is intentionally a cheap screen, not a leaderboard-comparable run.
- `scripts/run_pricebook_eval.sh` expects an existing `final_model.pt` from a previous run and does `ITERATIONS=0`, so it only measures export+eval deltas.
- For a real submission, save the final `train.log`, exact `train_gpt.py`, and `submission.json` in a new folder under `records/`.
