#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RUNS="${RUNS:-20}"
DATE_TAG="$(date +%F)"
DATA_DIR="${ROOT}/paper/repro/data"
CSV_PATH="${DATA_DIR}/interop_matrix_runtime_${DATE_TAG}.csv"
SUMMARY_PATH="${DATA_DIR}/interop_matrix_runtime_${DATE_TAG}-summary.md"
LOG_SNAPSHOT_PATH="${DATA_DIR}/interop_logs_${DATE_TAG}.txt"

mkdir -p "${DATA_DIR}"

if [[ ! -x "${ROOT}/bin/go" ]]; then
  echo "error: ${ROOT}/bin/go not found; build the Go tree first (./src/make.bash)." >&2
  exit 1
fi

if [[ ! -f "${ROOT}/misc/sctp-interop/harness/run_matrix.sh" ]]; then
  echo "error: interop harness not found at misc/sctp-interop/harness/run_matrix.sh" >&2
  exit 1
fi

echo "run,seconds" > "${CSV_PATH}"

tmp_logs="$(mktemp -d)"
echo "Capturing one matrix run with logs..."
(
  cd "${ROOT}"
  INTEROP_LOG_DIR="${tmp_logs}" ./misc/sctp-interop/harness/run_matrix.sh
)

{
  echo "# Interop logs (${DATE_TAG})"
  echo
  for f in go_server.log cpp_client.log cpp_server.log go_client.log; do
    echo "## ${f}"
    cat "${tmp_logs}/${f}"
    echo
  done
} > "${LOG_SNAPSHOT_PATH}"

echo "Running ${RUNS} timed iterations..."
for i in $(seq 1 "${RUNS}"); do
  start_ns="$(date +%s%N)"
  (
    cd "${ROOT}"
    INTEROP_LOG_DIR="" ./misc/sctp-interop/harness/run_matrix.sh >/dev/null
  )
  end_ns="$(date +%s%N)"
  elapsed_ns=$((end_ns - start_ns))
  elapsed_s="$(awk -v n="${elapsed_ns}" 'BEGIN { printf "%.6f", n/1000000000 }')"
  echo "${i},${elapsed_s}" >> "${CSV_PATH}"
  echo "run ${i}/${RUNS}: ${elapsed_s}s"
done

summary_line="$(awk -F, '
  NR==1 { next }
  {
    sum += $2
    if (min == 0 || $2 < min) min = $2
    if ($2 > max) max = $2
    a[count++] = $2
  }
  END {
    n = count
    mean = sum / n
    ss = 0
    for (i = 0; i < n; i++) {
      d = a[i] - mean
      ss += d * d
    }
    sd = (n > 1) ? sqrt(ss / (n - 1)) : 0
    printf "runs=%d mean=%.6f min=%.6f max=%.6f sd=%.6f", n, mean, min, max, sd
  }
' "${CSV_PATH}")"

runs="$(echo "${summary_line}" | awk '{print $1}' | cut -d= -f2)"
mean="$(echo "${summary_line}" | awk '{print $2}' | cut -d= -f2)"
min="$(echo "${summary_line}" | awk '{print $3}' | cut -d= -f2)"
max="$(echo "${summary_line}" | awk '{print $4}' | cut -d= -f2)"
sd="$(echo "${summary_line}" | awk '{print $5}' | cut -d= -f2)"

{
  echo "# Interop Matrix Runtime Summary (${DATE_TAG})"
  echo
  echo "- Runs: ${runs}"
  echo "- Mean runtime: ${mean} s"
  echo "- Min runtime: ${min} s"
  echo "- Max runtime: ${max} s"
  echo "- Standard deviation: ${sd} s"
  echo
  echo "## Environment"
  echo
  echo "- Kernel: $(uname -srmo)"
  echo "- Distro: $(lsb_release -ds 2>/dev/null || cat /etc/os-release | awk -F= '/^PRETTY_NAME=/{gsub(/\"/,\"\",$2); print $2}')"
  echo "- Go: $(${ROOT}/bin/go version)"
  if git -C "${ROOT}" rev-parse HEAD >/dev/null 2>&1; then
    echo "- Repository revision: \`$(git -C "${ROOT}" rev-parse HEAD)\`"
  fi
} > "${SUMMARY_PATH}"

echo "Wrote:"
echo "  ${CSV_PATH}"
echo "  ${SUMMARY_PATH}"
echo "  ${LOG_SNAPSHOT_PATH}"
