# repurpose - REPURPOSE (existing video -> teachable intermediate)

Overlay on `pedagogy-core.md`. Ingest a transcript, chunk to beats, grade-level the text, then route to a build mode. REPURPOSE never ships a final by itself - it produces an intermediate and hands off to VIDEO/SLIDES/WEB (which runs the gate).

## Pipeline

1. ingest transcript - pull the source captions/transcript with `youtube-transcript-api` (Python, no API key).
2. record source + license - URL, channel, license/저작권 status -> vault attribution. No clear reuse right -> stop and flag.
3. chunk to teachable beats - segment the transcript into 30-90s idea units; one beat = one teachable point tied to the objective.
4. grade-level the text - rewrite each beat to the band reading level (어절 length, vocab tier, define terms, drop loanwords). The source's wording is rarely grade-fit.
5. route to a build mode - VIDEO (re-narrate beats), SLIDES (one beat per slide), or WEB (interactive recap). That mode runs `edu-gate.sh`.

## Transcript ingest (youtube-transcript-api, no API key)

Korean-first, with translate fallback. Library is Python; languages list is priority order.

```python
from youtube_transcript_api import YouTubeTranscriptApi

vid = "VIDEO_ID"
api = YouTubeTranscriptApi()
try:
    # prefer an existing Korean transcript
    fetched = api.fetch(vid, languages=["ko"])
except Exception:
    # else fetch the original and translate to Korean
    tlist = api.list(vid)
    t = tlist.find_transcript([tr.language_code for tr in tlist])
    fetched = t.translate("ko").fetch()

for s in fetched:
    print(f"{s.start:.1f}s\t{s.text}")
```

- Prefer a native `ko` transcript; only `.translate("ko")` when none exists (machine translation needs a heavier grade-level pass).
- Auto-generated transcripts carry errors - verify any factual line against `facts.json` before reuse; never propagate an unsourced claim.

## Source + license (저작권, mandatory)

- Record in the vault: source URL, channel/author, license (CC / 공공누리 / 일반 저작권), retrieved date.
- Reuse only what the license allows. No clear right -> teach from the concept, not the clip; cite the source as a reference, do not embed it.
- Translated text = derivative; attribute the original. Prefer 공공누리/CC/original sources.

## Grade-level pass (the core re-authoring)

- Split long source sentences to the band 어절 floor (초저 ~7, 초고 ~10, 중 ~14, 고 ~20).
- Replace jargon/loanwords with grade vocab; define each term on first use (show-then-name).
- Drop off-objective tangents from the source; keep only beats that serve the declared 성취기준.

## Worked mini-example (고1 통합과학, 기후변화 다큐 5분 -> SLIDES)

- Ingest: `fetch(vid, languages=["ko"])` succeeds (native KO captions).
- Attribution: 공공누리 1유형 확인 -> vault에 URL/채널/라이선스/날짜 기록.
- Beats: 6 idea units (원인 / 증거 / 영향 / 대응 ...). Drop a celebrity tangent (off-objective).
- Grade-level: 고 ~20 어절, "탄소중립" 첫 등장 시 정의. 통계 수치 2건 -> facts.json에 원출처 연결, 미검증 1건 cut.
- Route: SLIDES, one beat per slide -> `reference/slides.md` runs `edu-gate.sh`.

## Done-when

- Transcript sourced + license recorded; beats grade-leveled to band; off-objective material cut; routed to a build mode; no unsourced claim carried over.
