# QTail STE Candidate

## Status

Candidate line based on public PR `#114`. Score is still pending; this folder is for running the A/B, not for claiming a result yet.

## Delta vs `#114`

- Keep the same public backbone: `train@2048`, `TRAIN_BATCH_TOKENS=786432`, `MLP_HIDDEN=1536`, int6 export, fp16 tied embedding, late-`K` fp16, control tensors fp16, sliding eval `2048/256`.
- Add only `QTAIL_STE`: tail-only fake int6 quantization with STE on the weights that are actually exported as int6.
- Keep fp16 passthrough tensors out of fake-quant.

## Main knobs

- `QTAIL_STE=1`: enables tail fake-quant.
- `QTAIL_START_FRAC=0.82`: activates in the last ~18% of the allowed train wallclock, or last ~18% of steps if no wallclock cap is set.
- `FINAL_SLIDING_EVAL=1`: keep the expensive final sliding eval. Set it to `0` for cheap `1xH100` smoke runs.
- `FP16_TAIL_K_LAYERS=2`: matches `#114` default.
- `FP16_TAIL_V_LAYERS=0`
- `FP16_TAIL_O_LAYERS=0`
- `FP16_EXTRA_WEIGHT_PATTERNS=""`

Those fp16 knobs are shared by export and by `QTAIL_STE`, so they can be used for the `PriceBook` sweep without drifting the training/export contract.

## Full run

```bash
QTAIL_STE=1 QTAIL_START_FRAC=0.82 \
TRAIN_SEQ_LEN=2048 TRAIN_BATCH_TOKENS=786432 MATRIX_LR=0.02 SCALAR_LR=0.02 \
TIED_EMBED_LR=0.03 MUON_MOMENTUM=0.99 MUON_MOMENTUM_WARMUP_START=0.92 \
MUON_MOMENTUM_WARMUP_STEPS=1500 WARMDOWN_ITERS=3000 GRAD_CLIP_NORM=0.3 \
MLP_HIDDEN=1536 EVAL_SEQ_LEN=2048 EVAL_STRIDE=256 \
torchrun --standalone --nproc_per_node=8 train_gpt.py
```

## Export-only `PriceBook`

After one training run saves `final_model.pt`, you can reuse the checkpoint and sweep fp16 islands without retraining:

```bash
INIT_STATE_PATH=./final_model.pt ITERATIONS=0 WARMUP_STEPS=0 QTAIL_STE=0 \
EVAL_SEQ_LEN=2048 EVAL_STRIDE=256 FP16_TAIL_K_LAYERS=1 \
torchrun --standalone --nproc_per_node=8 train_gpt.py
```

Useful variants:

- `FP16_TAIL_K_LAYERS=1` and `2`
- `FP16_TAIL_V_LAYERS=1` and `2`
- `FP16_TAIL_O_LAYERS=1`
- `FP16_EXTRA_WEIGHT_PATTERNS=blocks.8.attn.c_v.weight`
