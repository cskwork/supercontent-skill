# changelog 2026-06-18 - supercontent build decisions

Initial build of the supercontent skill. Decisions + rejected alternatives below; the *why* lives here so the next author can rebuild the reasoning.

## Why mode = medium (not subject)

- Routing on the *content medium* (VIDEO / WEB / SLIDES / ...) keeps each reference focused on one production pipeline with one fallback chain.
- Rejected: routing on 과목 (과학/수학/국어). 과목 cuts across every medium; it belongs in the brief and curriculum map, not the router. A 과목-keyed router would duplicate pipeline knowledge across rows.
- Rejected: routing on grade band. Band sets the dials (FUN/LOAD/SCAFFOLD) and read-level, not the production path. Band is an axis inside every mode, so it is a parameter, not a mode.
- Ten modes mirror superdesign's six-mode discipline (one intent -> one medium -> one aesthetic/pedagogy family) rather than a flat menu.

## Why a deterministic education-fit gate

- "Looks educational" is the same failure class as "looks designed." A model grading its own teaching output will rationalize off-standard drift, an over-loaded scene, or a too-long sentence.
- The predictable failures are machine-checkable: off-standard 성취기준, emoji, missing CommonMark blank lines, PII, over-length 어절, unsourced facts, sub-AA contrast. So a script computes the verdict and the Builder cannot self-approve.
- Mirrors superdesign's anti-slop-gate + contrast-gate split, generalized to five sub-gates under one `edu-gate.sh` entry point.
- Rejected: a single monolithic gate. Five small gates (curriculum / safety / readlevel / integrity / contrast) fail with precise file:line + rule, and each can be run alone during iteration.
- edu-critic runs the gate and edits nothing. Author independence is the whole point; folding critique into build would defeat it.

## Why quality-first with graceful fallback

- Project choice is quality-first: Codex gpt-image-2 for images, premium TTS + Flow/Veo for video, presenton for slides.
- But a skill that only works with paid/external tools is not portable and not safe for student data. So every stage degrades to a Claude-Code-only / local path and *logs the substitution* - the log line is the contract that nothing was silently faked.
- Student-data stages prefer local/self-hosted (Supertonic TTS, presenton+Ollama). Any external send is a consent hard-stop, not a default.
- Rejected: Claude-Code-only baseline as the primary path. It would cap quality below what the project wants and waste the available premium tooling.
- Rejected: external-only with no fallback. Breaks offline, breaks on missing keys, and risks faked-media shortcuts when a tool is absent.

## Why the 2026 / 2022 개정 seed subset

- Current year is fixed at 2026; curriculum baseline is the 2022 개정 standard (current in 2026). Hardcoding these as constants removes a recurring drift source (model defaulting to an older curriculum or year).
- `reference/curriculum-index.json` ships a *seed subset* of 성취기준 codes, not the full national set. Enough to make curriculum-gate real and testable across the four bands without claiming completeness.
- Rejected: the full 2022 개정 성취기준 corpus. Out of scope for an initial build, large to maintain, and not needed to prove the gate. Expandable - the index format is stable and additive.
- Rejected: free-text 성취기준 with no index. Then curriculum-gate could only check formatting, not validity. The index is what makes "off-standard" detectable.

## Stubbed / expandable

- `reference/curriculum-index.json` - seed subset; extend per 과목/학년 as needed. Format frozen.
- Trend snapshot (`reference/trend-snapshot.md`) - dated 2026 offline fallback; refresh on use, warned stale.
- vocab tiers in readlevel-gate - band-level 어절 thresholds seeded (초저 ~7, 초고 ~10, 중 ~14, 고 ~20); per-word vocab lists are a starter set, expandable.
- forbidden-topics / PII patterns in safety-gate - conservative starter set; tighten per deployment.
- Tool adapters (Codex image, premium TTS, Flow/Veo, presenton) - documented in `reference/tools.md`; the fallback paths are the guaranteed-working baseline today, the premium adapters are wire-up points.

## Mirror note

Structure, role-separation, vault concept, and gate-not-vibe-check discipline are deliberately parallel to superdesign (cskwork.github.io/superdesign-skill) so a user fluent in one is fluent in the other.
