# Experiment Checklist

## Goal

Beat the current public open-PR frontier on Parameter Golf with a submission line that is reproducible, byte-safe, and wallclock-safe.

Current public target to beat:

- `PR #114`
- `val_bpb = 1.1574`

Current working line:

- `records/track_10min_16mb/2026-03-19_QTailSTE_Int6MLP3x`

Private notes path:

- Put your private analysis/strategy document under `docs/private/`
- That path is gitignored on purpose

## Current Status

- [x] Fork + local workflow set up
- [x] Runpod `1xH100` pod set up
- [x] `QTAIL_STE` implemented on top of the `#114` backbone
- [x] `INIT_STATE_PATH` added for export-only sweeps
- [x] `FINAL_SLIDING_EVAL` added so smoke runs stay cheap
- [x] First `1xH100` smoke run completed
- [ ] First `PriceBook` sweep completed
- [ ] First `8xH100` full run completed
- [ ] Best variant selected
- [ ] Submission-quality record finalized

## Smoke Evidence

From the first `1xH100` smoke run:

- `QTAIL_STE` activated correctly at `progress=0.820`
- tail activation changed `52` eligible modules
- pre-tail speed was about `201 ms/step`
- post-tail speed was about `226 ms/step`
- compressed model bytes: `8,619,373`
- total bytes with code: `8,677,016`
- post-export roundtrip smoke score: `val_bpb = 1.42612364`

This smoke result is only a technical gate. It is not leaderboard-comparable.

## Next Experiments

1. Run export-only `PriceBook` from the saved `final_model.pt`
2. Compare:
   - `K1`
   - `V1`
   - `O1`
3. Keep the best fp16-island allocation
4. Promote the best variant to `8xH100`
5. Compare against stock `#114` behavior under the same evaluation contract

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
