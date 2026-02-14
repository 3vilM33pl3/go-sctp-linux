# Go<->C++ SCTP Interoperability Matrix

## Scope

This matrix documents what was explicitly exercised between:

- Go endpoint built from this repository (`net` package with SCTP support)
- C++ endpoint using Linux SCTP userspace APIs (`<linux/sctp.h>`)

## Scenarios

| ID | Direction | Status | Evidence |
|---|---|---|---|
| M1 | Go server <- C++ client | PASS | `GO_SERVER_RECV stream=3 ppid=101 payload=cpp-to-go` |
| M2 | C++ server <- Go client | PASS | `CPP_SERVER_RECV stream=4 ppid=202 payload=go-to-cpp` |

## Feature Coverage

| Feature | Covered | Notes |
|---|---|---|
| SCTP association bring-up | Yes | Both scenario directions establish associations successfully. |
| Message boundary preservation | Yes | Single-message payload arrives intact as one application message. |
| Stream identifier transfer | Yes | Stream IDs (`3` and `4`) observed at receiver. |
| PPID transfer | Yes | PPID (`101` and `202`) observed at receiver. |
| SCTP notification path | Partial | Association/shutdown notifications observed in logs. |
| Ordered/unordered modes | No | Harness currently sends ordered messages only. |
| Multistream contention behavior | No | No concurrent stream stress test in current harness. |
| Multihoming/failover | No | Not exercised in loopback setup. |
| Partial reliability (PR-SCTP) | No | Not exercised. |

## Commands

```bash
cd /home/olivier/Projects/sctp/go-sctp-linux
./misc/sctp-interop/harness/run_matrix.sh
```

## Raw Artifacts

- `paper/repro/data/interop_logs_2026-02-14.txt`
- `paper/repro/data/interop_matrix_runtime_2026-02-14.csv`
