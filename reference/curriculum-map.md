# curriculum-map - 2022 개정 교육과정 codes + sequencing

The 2026 standard is the **2022 개정 교육과정** (교육부 고시 제2022-33호), applied through 고등. Map 학년/과목/단원 to a 성취기준 code, and sequence to prior knowledge. `reference/curriculum-index.json` is the source of truth; this file is how to read and expand it.

## Code shape

`[학년군과목영역-순번]` - read left to right:

- **학년군** - the grade band number: `2`(초1-2), `4`(초3-4), `6`(초5-6), `9`(중1-3), `10`(고1 공통).
- **과목** - one or two Hangul chars: 국/수/사/과/영/도/음/미/체/실(과)/정(보)...
- **영역** - two-digit domain within the subject.
- **순번** - the standard's number in that domain.

Examples: `[2국01-01]` (초1-2 국어 듣기·말하기 1번), `[6과05-01]` (초5-6 과학 5영역 1번), `[9수03-02]` (중 수학 3영역 2번).

고등 공통과목 add a subject sub-index: `[10공국1-01-01]` (고1 공통국어1, 영역01, 순번01), `[10공수1-...]`, `[10통사1-...]`. Selective/진로 과목 use the subject's own code form - read it from the index, do not guess the shape.

## Band mapping (학년군 number -> our band)

| 학년군 number | grade | band |
|---|---|---|
| 2 | 초1-2 | 초저 |
| 4 | 초3-4 | 초고 |
| 6 | 초5-6 | 초고 |
| 9 | 중1-3 | 중 |
| 10+ | 고 | 고 |

Band sets the dial defaults (`pedagogy-core.md`) and the read-level floor.

## curriculum-index.json is the source of truth

- Builder/Critic resolve and verify codes ONLY against the index. curriculum-gate compares claimed codes in `curriculum-claims.json` to it.
- A code absent from the index = unverifiable = fails the gate. Do not paste a code you "remember" - if it is not indexed, it does not exist for this skill.

## Expanding the index (when a needed code is missing)

- Source ONLY from 교육부 고시 제2022-33호 (the official 성취기준 text), or a 1:1 derivative (KICE/교육청 published standard lists).
- Add the exact code + the official 성취기준 sentence + 학년군/과목/영역 fields. Never paraphrase the code, never invent 순번.
- Cite where the entry came from. If you cannot find the official text, do NOT add it - flag `교사 확인 필요` instead.
- One topic may map to several standards; index all, let Direction pick the tightest fit.

## Sequencing / prerequisite tips

- Build on what the curriculum guarantees at the prior 학년군, not on what a bright student might know.
- A series (차시별): order standards by their 영역/순번 and by stated prerequisites; introduce one new idea per piece.
- Cross-subject ties (e.g. 과학 그래프 needs 수학 비례) -> name the prerequisite standard and assume only its grade-level mastery.
- MANIM/explainer: reverse from the target standard to its prerequisites, teach the gap first.
