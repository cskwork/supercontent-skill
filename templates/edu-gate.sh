#!/usr/bin/env bash
# edu-gate - the education-fit preflight for /supercontent. Exit 0 = ship-ready; 1 = violation; 2 = usage.
# "vault" = work dir for one content piece. Must contain:
#   claims.md             (Builder's claim: dials declared + a run-to-prove)
#   curriculum-claims.json (declared 성취기준 -> curriculum-gate)
#   facts.json            (declared sourced facts, may be [] -> integrity-gate)
# Optional:
#   contrast-pairs.json   (critic's enumerated FG/BG pairs -> contrast-gate; required for visual modes)
# Source files: passed as args, or auto-discovered in the vault (deliverables, not the control files).
# Band for safety/read-level is derived from curriculum-claims.json grade.
#
# NEVER edit a gate to make failing content pass - fix the content.

set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
fail() { echo "edu-gate: $*" >&2; echo "== EDU PREFLIGHT: FAIL =="; exit 1; }
usage() { echo "usage: edu-gate.sh <vault> [<source files>]" >&2; exit 2; }

VAULT="${1:-}"
[ -n "$VAULT" ] || usage
[ -d "$VAULT" ] || fail "vault not found: $VAULT"
shift || true

# 1. claims.md exists and declares dials.
CLAIMS="$VAULT/claims.md"
[ -f "$CLAIMS" ] || fail "claims.md missing in vault (Builder must record the claim + run-to-prove)"
grep -q "FUN_INTENSITY" "$CLAIMS" || fail "claims.md does not declare dials (FUN_INTENSITY / COGNITIVE_LOAD / SCAFFOLDING)"

# 2. Required vault JSONs.
CCLAIMS="$VAULT/curriculum-claims.json"
FACTS="$VAULT/facts.json"
[ -f "$CCLAIMS" ] || fail "curriculum-claims.json missing (declare the 성취기준 the piece teaches)"
[ -f "$FACTS" ] || fail "facts.json missing (declare sourced facts, or write [])"

# 3. Derive grade band from the curriculum claim.
BAND="$(node -e '
const fs=require("fs");
let c=JSON.parse(fs.readFileSync(process.argv[1],"utf8"));
if(Array.isArray(c)) c=c[0]||{};
const g=String(c.grade||"").replace(/\s|학년|등/g,"");
let b="";
if(g.includes("초저"))b="초저"; else if(g.includes("초고"))b="초고";
else if(g.startsWith("고"))b="고"; else if(g.startsWith("중"))b="중";
else{const m=g.match(/초?([1-6])/); if(m)b=(+m[1]<=2)?"초저":"초고";}
process.stdout.write(b);
' "$CCLAIMS" 2>/dev/null)"
[ -n "$BAND" ] || fail "could not derive grade band from curriculum-claims.json grade (use 초저/초고/중/고 or 초N/중N/고N)"

# 4. Collect source files (args, or auto-discover deliverables in the vault).
SRC=()
if [ "$#" -gt 0 ]; then
  SRC=("$@")
else
  while IFS= read -r f; do SRC+=("$f"); done < <(find "$VAULT" -type f \
    \( -name '*.html' -o -name '*.css' -o -name '*.js' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.svg' -o -name '*.md' -o -name '*.txt' -o -name '*.py' \) \
    ! -name 'claims.md' ! -name 'content-brief.md' ! -name 'trend-pulse.md' \
    -not -path '*/node_modules/*' -not -path '*/dist/*' -not -path '*/build/*')
fi
[ "${#SRC[@]}" -gt 0 ] && [ -n "${SRC[0]:-}" ] || fail "no source files to scan (pass files as args, or put deliverables in the vault)"

# Text subset for read-level.
TXT=()
for f in "${SRC[@]}"; do case "$f" in *.md|*.txt|*.html) TXT+=("$f");; esac; done

# 5. Curriculum gate.
echo "-- curriculum-gate --"
node "$HERE/curriculum-gate.mjs" "$CCLAIMS" || fail "curriculum alignment violations"

# 6. Safety gate.
echo "-- safety-gate (band $BAND) --"
node "$HERE/safety-gate.mjs" --band "$BAND" "${SRC[@]}" || fail "safety violations"

# 7. Read-level gate (text only).
if [ "${#TXT[@]}" -gt 0 ]; then
  echo "-- readlevel-gate (band $BAND) --"
  node "$HERE/readlevel-gate.mjs" --band "$BAND" "${TXT[@]}" || fail "read-level too hard for band"
fi

# 8. Integrity gate.
echo "-- integrity-gate --"
node "$HERE/integrity-gate.mjs" "$FACTS" "${SRC[@]}" || fail "integrity violations"

# 9. Contrast gate (visual modes; required if pairs enumerated).
PAIRS="$VAULT/contrast-pairs.json"
if [ -f "$PAIRS" ]; then
  echo "-- contrast-gate --"
  node "$HERE/contrast-gate.mjs" "$PAIRS" || fail "contrast below threshold"
fi

echo "== EDU PREFLIGHT: PASS == (band $BAND, ${#SRC[@]} source file(s))"
exit 0
