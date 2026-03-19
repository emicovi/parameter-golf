# Experiment Checklist

## Goal

Beat the current public open-PR frontier on Parameter Golf with a submission line that is reproducible, byte-safe, and wallclock-safe.

Current public target to beat:

- `PR #135`
- `val_bpb = 1.1539`

Current merged leaderboard top on `upstream/main`:

- `Muon WD + 10 layer`
- `val_bpb = 1.1748`

Current working line:

- `records/track_10min_16mb/2026-03-19_QTailSTE_Int6MLP3x`

Current public frontier references:

- `PR #135` -> `1.1539`
- `PR #114` -> `1.1574`

Private notes path:

- Put your private analysis/strategy document under `docs/private/`
- That path is gitignored on purpose

## Current Status

- [x] Fork + local workflow set up
- [x] Runpod `1xH100` pod set up
- [x] Runpod large-box proxy pod set up (`7xH100`, because `8xH100` was unavailable)
- [x] `QTAIL_STE` implemented on top of the `#114` backbone
- [x] `INIT_STATE_PATH` added for export-only sweeps
- [x] `FINAL_SLIDING_EVAL` added so smoke runs stay cheap
- [x] First `1xH100` smoke run completed
- [x] First `PriceBook` sweep completed
- [ ] First `8xH100` full run completed
- [x] Best `1xH100` candidate selected
- [ ] Submission-quality record finalized

## PriceBook Evidence

Export-only sweep from saved `final_model.pt`:

- `K2` -> `val_bpb = 1.42612421`, `total_bytes = 8,677,275`
- `K1` -> `val_bpb = 1.42637050`, `total_bytes = 8,483,744`
- `V1` -> `val_bpb = 1.42718133`, `total_bytes = 8,474,011`
- `O1` -> `val_bpb = 1.42672352`, `total_bytes = 8,677,357`

Current best fp16-island choice stays `K2`.

## Smoke Evidence

The `1xH100` smoke runs are directional only. They are not leaderboard-comparable.

Tail-start sweep results so far:

- `stock` -> `val_bpb = 1.53177523`, `total_bytes = 8,485,338`
- `qtail 0.82` -> `val_bpb = 1.42612364`, `total_bytes = 8,677,016`
- `qtail 0.75` -> `val_bpb = 1.40694623`, `total_bytes = 8,622,024`
- `qtail 0.70` -> `val_bpb = 1.41162008`, `total_bytes = 8,523,033`
- `qtail 0.65` -> `val_bpb = 1.41115429`, `total_bytes = 8,620,021`

Current best smoke candidate is `QTAIL_START_FRAC=0.75`.

## Next Experiments

1. Promote `QTAIL_START_FRAC=0.75` with `K2` to the first large-box proxy run on `7xH100`.
2. Measure the real `post-export val_bpb` under the submission-like contract.
3. Compare the result against `PR #135 = 1.1539`.
4. If the gap is still material, choose the next single lever on the critical path.
5. When `8xH100` becomes available, replay the best candidate under the exact leaderboard contract.

## Commands

Run the current cheap smoke:

```bash
bash scripts/run_qtail_1xh100.sh
```

Run export-only `PriceBook`:

```bash
INIT_STATE_PATH=./final_model.pt RUN_ID=pricebook_k1 FP16_TAIL_K_LAYERS=1 bash scripts/run_pricebook_eval.sh
INIT_STATE_PATH=./final_model.pt RUN_ID=pricebook_v1 FP16_TAIL_V_LAYERS=1 bash scripts/run_pricebook_eval.sh
INIT_STATE_PATH=./final_model.pt RUN_ID=pricebook_o1 FP16_TAIL_O_LAYERS=1 bash scripts/run_pricebook_eval.sh
```

Run the current full candidate:

```bash
bash scripts/run_qtail_8xh100.sh
```

Run the current `7xH100` proxy candidate:

```bash
bash scripts/run_qtail_7xh100.sh
```
