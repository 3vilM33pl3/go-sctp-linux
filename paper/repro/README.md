# Reproducibility Artifacts

This folder contains scripts and captured data used by the paper's evaluation section.

## Script

- `run_interop_matrix_benchmark.sh`
  - Runs the Go<->C++ SCTP interop matrix once and saves logs.
  - Repeats the matrix for `N` runs (default `20`) and records wall-clock runtime per run.
  - Writes CSV and a markdown summary under `paper/repro/data/`.

## Usage

```bash
cd /home/olivier/Projects/sctp/go-sctp-linux
./paper/repro/run_interop_matrix_benchmark.sh
```

Optional:

```bash
RUNS=50 ./paper/repro/run_interop_matrix_benchmark.sh
```

## Captured Data in This Commit

- `data/interop_logs_2026-02-14.txt`
- `data/interop_matrix_runtime_2026-02-14.csv`
- `data/interop_matrix_runtime_2026-02-14-summary.md`
