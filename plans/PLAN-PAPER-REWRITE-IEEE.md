# Plan: IEEE Paper Rewrite — SCTP as a First-Class Transport

## Summary
Rewrite the 2013 paper into a modern IEEE conference-style manuscript focused on the thesis that SCTP should be treated as a first-class transport protocol next to TCP and UDP. The argument is anchored in Internet architectural extensibility and supported by concrete Linux Go runtime integration evidence and Go<->C++ interoperability results.

## Fixed Decisions
- Format: IEEE conference style (`IEEEtran`, two-column).
- Authoring: LaTeX + BibTeX.
- Evidence model: implementation details + quantitative test evidence.
- Citation depth: ~20+ high-quality references (RFCs + peer-reviewed literature + platform docs).
- Scope: Linux implementation in latest Go runtime branch.

## Core Thesis
SCTP deserves first-class runtime support because:
1. Internet protocol architecture is explicitly designed to evolve.
2. SCTP is a mature standards-track transport, not an experimental side path.
3. Integration into a modern language runtime is incremental and straightforward when socket abstractions are already protocol-oriented.
4. Independent Go<->C++ interoperability and metadata fidelity demonstrate practical viability.

## Manuscript Deliverables
- `paper/main.tex`
- `paper/sections/*.tex`
- `paper/refs.bib`
- `paper/appendix/interop-matrix.md`
- `paper/repro/README.md`
- `paper/repro/run_interop_matrix_benchmark.sh`
- `paper/repro/data/*` (captured logs and runtime CSV/summary)

## Section Plan

## 1) Introduction
- Reframe from “SCTP novelty” to “architectural legitimacy + implementation proof”.
- State contributions explicitly:
  - Linux Go runtime SCTP integration,
  - first-class API alignment with TCP/UDP style,
  - C++ interop validation.

## 2) Why SCTP Should Be First-Class
- IP and Internet architecture extensibility argument.
- SCTP capability comparison vs TCP/UDP:
  - reliability + message boundaries + multistreaming + multihoming.
- Current relevance (e.g., WebRTC data channel usage).

## 3) Design and Integration
- Explain where SCTP integrates in modern Go `net` internals.
- Detail public API additions and behavior decisions.
- Explain Linux socket model and ancillary metadata path.

## 4) Evaluation Method
- Environment and build details (OS/kernel/Go revision).
- In-tree Go test suite selection.
- Go<->C++ interop matrix methodology.
- Timing collection methodology for repeated matrix runs.

## 5) Results
- Report Go test pass outcomes.
- Report bilateral interop evidence:
  - payload fidelity,
  - stream ID,
  - PPID.
- Include runtime summary metrics from repeated runs.

## 6) Related Work
- SCTP RFC and socket API corpus.
- Peer-reviewed SCTP studies (performance/portability/multipath).
- Transport evolution/deployment friction literature.

## 7) Discussion
- Explicitly connect findings back to first-class runtime status.
- Add supporting practical arguments:
  - correctness,
  - performance isolation via streams,
  - resilience and failover semantics,
  - avoiding ad hoc app-layer reimplementation.

## 8) Limitations
- Linux-focused environment.
- Limited extension coverage in harness.
- No full multi-path fault-injection lab in current evaluation.

## 9) Conclusion
- Restate claim and evidence-backed conclusion.
- Position first-class SCTP as technically justified and operationally practical.

## Reference Plan
- Core architecture and transport RFCs:
  - IP/TCP/UDP base and host requirements.
  - SCTP base and updates/extensions.
  - SCTP sockets API RFC.
- Peer-reviewed papers:
  - SCTP multipath/performance/usability.
  - Transport extension/deployment studies.
- Operational references:
  - Linux SCTP docs/man pages.
  - Relevant Go networking source/doc references.

## Evaluation Requirements (for Paper Claims)
- Must include:
  - Go SCTP test command and output summary.
  - Go<->C++ matrix pass summary for both directions.
  - Captured log excerpts proving metadata round-trip.
  - Repeated run timing summary (mean/min/max/stddev).
- Must provide reproducibility commands and artifact locations.

## Acceptance Criteria
- Compiles via:
  - `pdflatex main.tex`
  - `bibtex main`
  - `pdflatex main.tex` (x2)
- No unresolved bibliography keys.
- Claims tied to either source code evidence or reproducible measurements.
- Includes at least:
  - one transport comparison table,
  - one integration/architecture figure,
  - one interop matrix appendix,
  - one quantitative runtime summary.

## Assumptions and Defaults
- Linux host has SCTP kernel module support.
- Go runtime integration branch is the source of truth for implementation details.
- Page budget favors concise, evidence-dense writing over tutorial exposition.
- If specific advanced SCTP features are not fully exercised, paper must mark them as out of scope or future work.
