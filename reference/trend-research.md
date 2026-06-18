# trend-research - pulse what engages the band (2026)

Trend-aware != trend-chasing. Find concrete, implementable signals for what engages THIS grade band now, keep only what stays on-curriculum and safe, record dated in the vault `trend-pulse.md`. Reuse a same-band pulse <=30 days old. On search failure, fall back to `trend-snapshot.md`.

## Run 2-3 scoped searches

Scope every query to the band + 과목 + 2026, not generic "engaging content":

- `초등 고학년 과학 학습 콘텐츠 인기 형식 2026`
- `중학생 영상 학습 짧은 포맷 참여 2026`
- `K-12 educational video hook retention 2026` (cross-check, not primary)

Vary the angle (format / hook / pacing / reference), not the words. Two or three good searches beat ten noisy ones.

## Extract signals, not adjectives

Keep only what you could implement tomorrow:

- GOOD (concrete): "초고 영상은 첫 5초 안에 질문 던지기", "한 화면 1개념", "퀴즈를 중간에 끼워 능동 회상 유도", "세로 9:16 짧은 호흡".
- BAD (vague): "재미있게", "트렌디하게", "요즘 스타일", "감각적인". These are unusable - drop them.

Pull the mechanism behind a trend (why it holds attention), not just its name.

## Filter hard

- Off-curriculum -> drop, no matter how popular.
- Unsafe / age-inappropriate reference, brand, meme, or creator -> drop (safety overrides engagement; see `safety-rules.md`).
- Anything needing PII, external student-data send, or a copyrighted asset -> drop.
- Cross-check each surviving signal against `pedagogy-core.md`: a signal that raises COGNITIVE_LOAD past the band default or fights "one idea at a time" is a trap - drop or down-weight it.

## Record (dated)

In `trend-pulse.md`: date, band, queries run, the 3-6 surviving signals (each one implementable line), and which dial each signal pushes. This is what Direction reads when setting `FUN_INTENSITY` / `COGNITIVE_LOAD` / `SCAFFOLDING`.

## On failure

WebSearch unavailable, blocked, or returns nothing usable -> use `reference/trend-snapshot.md` (dated offline signals), and state plainly in `trend-pulse.md`: `검색 실패 - snapshot 2026-06 사용 (stale 가능)`. Never fabricate a trend.
