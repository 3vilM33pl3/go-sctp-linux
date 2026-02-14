# SCTP First-Class Citizen Paper (IEEE)

This directory contains a full IEEE conference-style rewrite of the original 2013 paper, updated for Linux and the current Go runtime tree in this repository.

## Layout

- `main.tex`: IEEE manuscript entry point.
- `sections/`: body sections split into focused files.
- `refs.bib`: bibliography.
- `appendix/interop-matrix.md`: feature coverage matrix for Go and C++ interoperability scenarios.
- `repro/`: reproducibility scripts and captured evaluation artifacts.

## Build

This project expects a standard LaTeX toolchain with `IEEEtran`, `pdflatex`, and `bibtex`.

```bash
cd paper
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

Output: `paper/main.pdf`.

## Reproduce Evaluation Inputs

The paper's evaluation references two sources:

1. In-tree Go SCTP tests:

```bash
cd ..
GOROOT=$(pwd) ./bin/go test net -run '^TestSCTP|TestParseNetworkSCTP|TestResolveSCTPAddrUnknownNetwork' -count=1 -v
```

2. Go<->C++ interop matrix and repeated timing:

```bash
cd ..
./paper/repro/run_interop_matrix_benchmark.sh
```

Generated CSV and summary files are written under `paper/repro/data/`.
