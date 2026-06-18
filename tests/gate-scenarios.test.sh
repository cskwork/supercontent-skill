#!/usr/bin/env bash
# /supercontent - gate scenario suite. Exercises all 5 gates (curriculum, safety,
# readlevel, integrity, contrast) plus the edu-gate.sh preflight orchestrator.
# Every case asserts BOTH the exit code AND a substring of the output, so a pass
# needs two independent signals (guards against silently-wrong gates and fabricated
# output). Run from repo root: bash tests/gate-scenarios.test.sh
set -u

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
PASS=0; FAIL=0

TPL="$SKILL_DIR/templates"
GOOD="$SKILL_DIR/tests/fixtures/good"
BAD="$SKILL_DIR/tests/fixtures/bad"

# run_case <label> <expected-exit> <expected-substr|-> <cmd...>
run_case() {
  local label="$1" exp="$2" substr="$3"; shift 3
  local out rc ok=1
  out="$("$@" 2>&1)"; rc=$?
  [ "$rc" = "$exp" ] || ok=0
  if [ "$substr" != "-" ]; then echo "$out" | grep -qF "$substr" || ok=0; fi
  if [ "$ok" = 1 ]; then
    PASS=$((PASS+1)); echo "  ok   $label"
  else
    FAIL=$((FAIL+1)); echo "FAIL   $label (rc=$rc exp=$exp; wanted substr: $substr)"
  fi
}

# ---- 1. curriculum-gate ----------------------------------------------------
run_case "curriculum: good claim -> PASS" 0 "CURRICULUM" \
  node "$TPL/curriculum-gate.mjs" "$GOOD/curriculum-claims.json"
run_case "curriculum: grade/code band mismatch -> FAIL" 1 "== CURRICULUM GATE: FAIL ==" \
  node "$TPL/curriculum-gate.mjs" "$BAD/curriculum-mismatch.json"
run_case "curriculum: invented code -> FAIL" 1 "== CURRICULUM GATE: FAIL ==" \
  node "$TPL/curriculum-gate.mjs" "$BAD/invented-code.json"

# ---- 2. safety-gate --------------------------------------------------------
run_case "safety: good lesson -> PASS" 0 "SAFETY" \
  node "$TPL/safety-gate.mjs" --band 초고 "$GOOD/lesson.md"
run_case "safety: emoji + PII -> FAIL" 1 "== SAFETY GATE: FAIL ==" \
  node "$TPL/safety-gate.mjs" --band 초고 "$BAD/unsafe.md"

# ---- 3. readlevel-gate -----------------------------------------------------
run_case "readlevel: good lesson for 초고 -> PASS" 0 "READLEVEL" \
  node "$TPL/readlevel-gate.mjs" --band 초고 "$GOOD/lesson.md"
run_case "readlevel: too-hard for 초저 -> FAIL" 1 "== READLEVEL GATE: FAIL ==" \
  node "$TPL/readlevel-gate.mjs" --band 초저 "$BAD/too-hard.txt"

# ---- 4. integrity-gate -----------------------------------------------------
run_case "integrity: good facts -> PASS" 0 "INTEGRITY" \
  node "$TPL/integrity-gate.mjs" "$GOOD/facts.json" "$GOOD/lesson.md"
run_case "integrity: empty facts + unsourced claim -> FAIL" 1 "== INTEGRITY GATE: FAIL ==" \
  node "$TPL/integrity-gate.mjs" "$BAD/empty-facts.json" "$BAD/unsourced.md"

# ---- 5. contrast-gate ------------------------------------------------------
run_case "contrast: good pairs -> PASS" 0 "== CONTRAST GATE PASS ==" \
  node "$TPL/contrast-gate.mjs" "$GOOD/contrast-pairs.json"
# Synthesize a failing pair (low FG/BG separation, normal text needs 4.5:1).
printf '[{"el":"low","fg":"#777777","bg":"#888888","size":"normal"}]' > "$T/bad-pairs.json"
run_case "contrast: low-separation pair -> FAIL" 1 "below threshold" \
  node "$TPL/contrast-gate.mjs" "$T/bad-pairs.json"

# ---- 6. edu-gate.sh preflight orchestrator ---------------------------------
run_case "edu-gate: no args -> usage exit 2" 2 "usage" \
  bash "$TPL/edu-gate.sh"
run_case "edu-gate: good vault -> PREFLIGHT PASS" 0 "== EDU PREFLIGHT: PASS ==" \
  bash "$TPL/edu-gate.sh" "$GOOD"

# Assemble a bad vault: good claim/curriculum/facts but an unsafe deliverable.
mkdir -p "$T/badvault"
cp "$GOOD/claims.md" "$GOOD/curriculum-claims.json" "$GOOD/facts.json" "$T/badvault/"
cp "$BAD/unsafe.md" "$T/badvault/lesson.md"
run_case "edu-gate: unsafe deliverable -> PREFLIGHT FAIL" 1 "== EDU PREFLIGHT: FAIL ==" \
  bash "$TPL/edu-gate.sh" "$T/badvault"

# Vault missing claims.md is blocked before any gate runs.
mkdir -p "$T/noclaims"
cp "$GOOD/curriculum-claims.json" "$GOOD/facts.json" "$T/noclaims/"
cp "$GOOD/lesson.md" "$T/noclaims/lesson.md"
run_case "edu-gate: missing claims.md -> PREFLIGHT FAIL" 1 "== EDU PREFLIGHT: FAIL ==" \
  bash "$TPL/edu-gate.sh" "$T/noclaims"

echo
printf "RESULT: %d passed, %d failed\n" "$PASS" "$FAIL"
[ "$FAIL" = 0 ]
