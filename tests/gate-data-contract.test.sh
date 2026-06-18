#!/usr/bin/env bash
# /supercontent - gate-data contract. The deterministic gates read seed data from
# reference/. This verifies that seed data is present, valid, and pinned to the
# right curriculum/year, so the gates can never silently run against malformed or
# stale inputs. Each case asserts BOTH exit code and a substring.
# Run from repo root: bash tests/gate-data-contract.test.sh
set -u

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REF="$SKILL_DIR/reference"
PASS=0; FAIL=0

run_case() {
  local label="$1" exp="$2" substr="$3" out rc ok=1
  shift 3
  out="$("$@" 2>&1)"; rc=$?
  [ "$rc" = "$exp" ] || ok=0
  if [ "$substr" != "-" ]; then echo "$out" | grep -qF "$substr" || ok=0; fi
  if [ "$ok" = 1 ]; then PASS=$((PASS+1)); echo "  ok   $label"
  else FAIL=$((FAIL+1)); echo "FAIL   $label (rc=$rc exp=$exp; wanted substr: $substr)"; fi
}

# ---- curriculum-index.json: valid JSON, version "2022 개정", year 2026 --------
run_case "curriculum-index.json is valid JSON" 0 "valid" \
  node -e 'JSON.parse(require("fs").readFileSync(process.argv[1],"utf8")); console.log("valid")' \
  "$REF/curriculum-index.json"

run_case "curriculum-index.json version == 2022 개정" 0 "version-ok" \
  node -e 'const j=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8")); if(j.version!=="2022 개정"){console.error("got:",j.version);process.exit(1)} console.log("version-ok")' \
  "$REF/curriculum-index.json"

run_case "curriculum-index.json year == 2026" 0 "year-ok" \
  node -e 'const j=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8")); if(j.year!==2026){console.error("got:",j.year);process.exit(1)} console.log("year-ok")' \
  "$REF/curriculum-index.json"

run_case "curriculum-index.json has codes map" 0 "codes-ok" \
  node -e 'const j=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8")); if(!j.codes||typeof j.codes!=="object"){process.exit(1)} console.log("codes-ok")' \
  "$REF/curriculum-index.json"

# ---- forbidden-topics.json: valid JSON ---------------------------------------
run_case "forbidden-topics.json is valid JSON" 0 "valid" \
  node -e 'JSON.parse(require("fs").readFileSync(process.argv[1],"utf8")); console.log("valid")' \
  "$REF/forbidden-topics.json"

# ---- vocab-tiers overrange lists for every band -----------------------------
for band in 초저 초고 중 고; do
  run_case "vocab-tiers/$band-overrange.txt exists" 0 "exists" \
    bash -c '[ -f "'"$REF/vocab-tiers/$band-overrange.txt"'" ] && echo exists'
done

echo
printf "RESULT: %d passed, %d failed\n" "$PASS" "$FAIL"
[ "$FAIL" = 0 ]
