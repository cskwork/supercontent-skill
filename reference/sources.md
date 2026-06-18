# sources - reference repos, licenses, attribution

Capabilities this skill borrows from, with provenance. Verify the license at the repo before redistributing any code or output - licenses change; this table is a 2026 read, not a guarantee.

## Repos

| Repo (owner) | URL | License (verify) | Contributed |
|---|---|---|---|
| youtube-autopilot (cskwork) | github.com/cskwork/youtube-autopilot | check repo | end-to-end stage loop for VIDEO (research -> script -> assets -> narrate -> render) |
| OpenMontage (calesthio) | github.com/calesthio/OpenMontage | check repo | montage / explainer assembly; video render fallback over stills |
| youtube-automation-agent (darkzOGx) | github.com/darkzOGx/youtube-automation-agent | check repo | autopilot agent patterns for the VIDEO pipeline |
| supertonic-tts (cskwork) | github.com/cskwork/supertonic-tts | check repo | local Korean TTS, multi-voice - the privacy-safe AUDIO/TTS tier |
| Math-To-Manim (HarleyCoops) | github.com/HarleyCoops/Math-To-Manim | check repo | MANIM pipeline; ManimCE + LaTeX (Korean needs XeLaTeX/CJK font) |
| youtube-transcript-api (jdepoix) | github.com/jdepoix/youtube-transcript-api | MIT (verify) | REPURPOSE transcript ingest; Python, `languages=['ko']`, `.translate`, no API key |
| presenton | github.com/presenton/presenton | check repo | SLIDES primary; self-hostable REST PPT gen, Ollama/BYOK, exports PPTX, MCP-callable |
| ppt-master (hugohe3) | github.com/hugohe3/ppt-master | check repo | SLIDES fallback; agentic PPT generation |
| superdesign (cskwork) | cskwork.github.io/superdesign-skill | check repo | skill structure + anti-slop gate pattern this skill mirrors |

## Attribution rule

- When code, prompts, or output derive from a repo above, name it and link it where the work is published (README, credits, or vault manifest).
- Capture the upstream license string at the time you pull, alongside the URL.

## Verify license before redistribution

- "check repo" = read the actual LICENSE file before shipping derived code or media; do not assume MIT/permissive.
- No license file or all-rights-reserved -> use for reference/learning only; do not redistribute its code or outputs.
- License on a dependency can differ from the skill's own terms - the strictest applies to the combined work.
- Generated media (Codex, Veo, TTS) carries the provider's usage terms; for student-facing redistribution, confirm those too.
