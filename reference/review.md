# review - gate-only critique, edit nothing

REVIEW mode. The user hands you existing content ("이거 학년에 맞아?", "검수만"). Run the full gate, judge what scripts cannot see, report verdicts with severity + file:line + a concrete fix. **Edit nothing.** If they want it fixed, that is the build mode for that medium, not REVIEW.

## Setup

- Identify the band + 과목 + claimed 성취기준 from the content or ask ONE question if undeterminable.
- Build a minimal vault from the input: enumerate facts -> `facts.json`, claimed codes -> `curriculum-claims.json`, text-bg pairs -> `contrast-pairs.json`. No vault, no gate.
- If a field is unknowable (no declared band), state the assumption and review against the conservative band.

## Run the gate

`templates/edu-gate.sh <vault> <files>` runs in order:

- `curriculum-gate.mjs` - claimed 성취기준 vs `reference/curriculum-index.json`.
- `safety-gate.mjs --band <band>` - emoji / PII / forbidden-topics / insecure-link / CommonMark spacing.
- `readlevel-gate.mjs --band <band>` - 어절 length floor + vocab-tiers.
- `integrity-gate.mjs <facts.json>` - every factual signal sourced.
- `contrast-gate.mjs` - WCAG AA on each pair.

Report each gate's raw verdict.

## Then judge what scripts cannot (pedagogy-core pre-flight)

- Does it actually teach the objective, or just entertain around it?
- One new idea at a time, or overloaded for the band?
- Misconception addressed? Closing check tied to the standard?
- Korean natural and age-appropriate in tone, not just sentence length?
- Every fact in `facts.json` actually correct, not merely sourced?

## Report shape

One row per finding:

`[severity] gate/judgment | file:line | what's wrong | concrete fix`

- **severity**: HIGH (factual error, safety, off-standard, failed gate) / MED (read-level, contrast, weak scaffolding) / LOW (polish, tone).
- Lead with HIGH. State pass lines too (`safety-gate: PASS`).
- End with a verdict: 학년 적합 / 조건부 적합(아래 수정 시) / 부적합.

## Boundary

Zero edits. No rewritten sentences in-place - put suggested wording in the "fix" column as a proposal. If the user then says "고쳐줘", switch to the medium's build mode and run the full loop.
