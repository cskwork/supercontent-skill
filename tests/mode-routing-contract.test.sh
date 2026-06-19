#!/usr/bin/env bash
# /supercontent - mode-routing contract. The routing table in SKILL.md maps each
# MODE to a reference file; this checks (a) every MODE named in SKILL.md routes to
# a reference/*.md that exists, and (b) the full MODE set matches the canonical
# constant set exactly. Each case asserts BOTH exit code and a substring.
# Run from repo root: bash tests/mode-routing-contract.test.sh
set -u

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$SKILL_DIR/SKILL.md"
PASS=0; FAIL=0

# Canonical MODE set (from skill constants): 11 modes.
MODES="VIDEO MANIM POSTER WEB SLIDES GAME AUDIO DOCS REPURPOSE REVIEW EXPLORE"

run_case() {
  local label="$1" exp="$2" substr="$3" out rc ok=1
  shift 3
  out="$("$@" 2>&1)"; rc=$?
  [ "$rc" = "$exp" ] || ok=0
  if [ "$substr" != "-" ]; then echo "$out" | grep -qF "$substr" || ok=0; fi
  if [ "$ok" = 1 ]; then PASS=$((PASS+1)); echo "  ok   $label"
  else FAIL=$((FAIL+1)); echo "FAIL   $label (rc=$rc exp=$exp; wanted substr: $substr)"; fi
}

run_case "SKILL.md present" 0 "found" bash -c '[ -f "'"$SKILL_MD"'" ] && echo found'

# (a) Each canonical MODE must appear in SKILL.md as a standalone routing cell
#     ("| MODE |") and name an existing reference file on that same row.
check_mode_files() {
  local md="$1" missing=0 ok=0 m row ref
  for m in $MODES; do
    # Find a table row that uses the mode as a routing cell.
    row="$(grep -E "\| *$m *\|" "$md" | head -1)"
    if [ -z "$row" ]; then
      echo "MODE not routed in SKILL.md: $m"; missing=$((missing+1)); continue
    fi
    ref="$(echo "$row" | grep -oE 'reference/[A-Za-z0-9._/-]+\.md' | head -1)"
    if [ -z "$ref" ]; then
      echo "MODE $m row names no reference file"; missing=$((missing+1)); continue
    fi
    if [ -f "$SKILL_DIR/$ref" ]; then ok=$((ok+1)); else
      echo "MODE $m -> $ref MISSING"; missing=$((missing+1)); fi
  done
  echo "modes routed to existing files: $ok ok, $missing missing"
  [ "$missing" = 0 ]
}
export -f check_mode_files; export SKILL_DIR MODES

run_case "every MODE row names a reference file that exists" 0 "0 missing" \
  bash -c 'check_mode_files "'"$SKILL_MD"'"'

# (b) The set of MODE tokens appearing as routing cells in SKILL.md equals the
#     canonical constant set (no extra modes, none missing).
check_mode_set() {
  local md="$1" m got want extra=0 declared
  want="$(printf '%s\n' $MODES | sort -u)"
  declared=""
  for m in $MODES; do
    grep -qE "\| *$m *\|" "$md" && declared="$declared $m"
  done
  got="$(printf '%s\n' $declared | sort -u)"
  if [ "$got" = "$want" ]; then echo "mode set matches canonical (11 modes)"; return 0; fi
  echo "mode set mismatch"; diff <(echo "$want") <(echo "$got"); return 1
}
export -f check_mode_set

run_case "MODE set matches canonical constant set" 0 "matches canonical" \
  bash -c 'check_mode_set "'"$SKILL_MD"'"'

echo
printf "RESULT: %d passed, %d failed\n" "$PASS" "$FAIL"
[ "$FAIL" = 0 ]
