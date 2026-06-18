# content-brief - reading the brief into a locked Read

The Read step. Turn whatever the user gave you into a complete brief, state it in one line, ask at most one question. Record in the vault `content-brief.md`. This file is HOW to read; `templates/content-brief.md` is the fillable stub.

## What to infer (every field, even from a thin prompt)

- **학년 band** - map to 초저(초1-2) / 초고(초3-6) / 중 / 고. "초5" -> 초고. No grade stated -> infer from vocabulary/topic, log the assumption.
- **과목** - 국어/수학/사회/과학/영어/... Name it; it scopes the 성취기준 search.
- **단원/차시** - the unit and (if a series) the lesson number. Drives sequencing and prior-knowledge assumptions.
- **성취기준** - the curriculum standard code (e.g. `[6과05-01]`). MANDATORY. See below.
- **learning objective (학습목표)** - one sentence, what the learner can DO afterward. The spine of the piece.
- **reading level** - follows the band default (어절 floor per `pedagogy-core.md`); override only if the brief says so.
- **format constraints** - medium, length (초/장수/분량), publish target, deadline.
- **quiet constraints** - 안전/저작권/개인정보. These override fun, always; surface them even if unasked.

## The one-line Read

State it before building, e.g.:

`Read: 초고(초5) 과학, 빛의 단원, [6과05-01] 빛의 굴절, 학습목표=굴절을 예측·설명한다, 90초 VIDEO, 자막 필수.`

This is the contract. The Builder and Critic both judge against it.

## The single-question rule

- Two readings genuinely diverge on something load-bearing (band, objective, medium) -> ask ONE consolidated question, then proceed.
- Minor gaps -> pick the conservative reading, log the assumption, do not ask.
- Non-interactive run -> never block; conservative read + logged assumption in the vault.
- Never ask a question you can answer from the prompt or curriculum-index.

## 성취기준 is mandatory

- Look up the code in `reference/curriculum-index.json` (source of truth) using 학년 band + 과목 + topic.
- User gave a code -> verify it exists in the index; if not, treat as "none".
- No code or no match -> **propose the closest standard**, write it to `curriculum-claims.json`, and flag plainly: `성취기준 [추정] - 교사 확인 필요`. Never invent a code that is not in the index.
- The curriculum-gate checks claimed codes against the index; an unverifiable code fails the gate, so the teacher-confirm flag is the honest path, not a workaround.

## Hand-off

Brief complete -> Direction sets dials and picks ONE medium. Carry the one-line Read and the 성취기준 (verified or flagged) forward into `claims.md`.
