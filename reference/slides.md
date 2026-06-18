# slides - SLIDES medium

Load at Build when medium = SLIDES. `pedagogy-core.md` always wins on conflict.

Deliverable: curriculum-aligned, editable deck (PPTX preferred). Done-when: `edu-gate.sh` green incl. contrast on every text-bg pair.

## Confirm spec before building

Slides are structural - wrong 장수/차시 = full rebuild. Confirm or log assumption:

- 학년 band + 과목 + 단원/차시, 성취기준 code, learning objective (one).
- 장수 (slide count) + 차시 length. Default: 1차시 40-45분 -> 12-18장 (초저 lower, 고 higher density).
- Output: PPTX (teacher edits) default; HTML only if explicitly screen-only.
- Per-slide objective tie: every slide serves the one objective or is cut.

## Deck arc (curriculum-shaped, not topic-dump)

`[동기유발]` hook (1) -> `[학습목표]` (1) -> `[활동]` build, one idea/slide (n) -> `[정리]` recap + `[형성평가]` check (1-2). Misconception slide where the band trips. Active beat every slide: a question, predict, or task - never wall-of-text.

## Slide-design discipline

- One idea per slide. If two ideas, two slides.
- Generous type: 본문 >=24pt, 제목 >=32pt (초저 larger). Max ~6 lines/slide.
- Korean `word-break: keep-all` equivalent - never split a 어절 across lines; manual line breaks at phrase boundaries.
- No emoji; bracket markers as section labels. Real/generated images only (assets.md) - never a faked screenshot.
- WCAG AA contrast every pair (log to contrast-pairs.json). Reduced-motion: no auto-advance, no essential transition.

## Pipeline: primary -> fallback (log any substitution)

1. **presenton (primary)** - self-hosted REST, Ollama-local or BYOK, exports PPTX, MCP-callable. Student data -> Ollama local only, never external BYOK.

   ```bash
   # self-host: docker run -p 5000:80 ghcr.io/presenton/presenton
   curl -X POST localhost:5000/api/v1/ppt/generate \
     -H 'Content-Type: application/json' \
     -d '{"prompt":"<deck outline>","n_slides":14,"language":"Korean","export":"pptx"}'
   # returns path to .pptx
   ```

   Feed it the deck arc above as structured outline, not a raw topic. Re-open exported PPTX, verify slide count + objective tie before gate.

2. **PPT Master (fallback)** - agentic PPT harness (hugohe3); use when presenton unreachable or finer per-slide control needed. Same outline contract in.

3. **reveal.js single-file HTML (last resort, Claude-Code-only)** - no server, no model. One `index.html`, inline CSS/JS, no external CDN (vendor reveal.js inline or pin local). Section per slide; objective tie preserved. Log: "PPTX path unavailable -> reveal.js HTML; not teacher-editable as slides."

## Worked mini-example

Read: SLIDES for 초고 과학, 그림자와 빛 [4과 XX-XX], 14장, 1차시.

Dials (초고 default): FUN med, LOAD low-med, SCAFFOLD med.

Outline fed to presenton:

```
1 [동기유발] 손전등 하나로 벽에 큰 그림자, 작은 그림자 - 무엇이 다를까
2 [학습목표] 빛과 물체 사이 거리에 따라 그림자 크기가 변하는 까닭
3-4 [활동] 빛은 곧게 나아간다 (직진) - 사진 + 한 문장 질문
5-7 [활동] 물체를 빛에 가까이 -> 그림자 커짐, 멀리 -> 작아짐, 예측 먼저
8 [오개념] "그림자는 물체 색과 같다" -> 실제는 어둡기만 다름
9-11 [활동] 직접 해보기: 거리 바꿔 그림자 재기, 표 채우기
12-13 [정리] 핵심 한 줄 + 그림으로 다시
14 [형성평가] 거리가 멀어지면 그림자는? (보기 3개)
```

Export PPTX -> reopen -> count = 14, every slide maps to objective -> enumerate text pairs to contrast-pairs.json -> `edu-gate.sh`.

Fallback trace if presenton down: PPT Master same outline; if that fails, single-file reveal.js, log substitution in claims.md.
