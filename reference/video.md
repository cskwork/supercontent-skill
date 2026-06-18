# video - VIDEO build (research -> render, captions always)

Overlay on `pedagogy-core.md`. Short explainer / 쇼츠 / 애니메이션 설명. Spine = one objective + one 성취기준. The script and captions are the deliverable even when render fails.

## Stage loop (youtube-autopilot pattern)

A linear, resumable stage loop. Each stage writes one artifact to the vault; a crash resumes at the last completed stage, never re-narrates from scratch.

1. research - confirm brief + sourced facts. Every claim -> `facts.json` or cut. No fact, no line.
2. script (beats) - write narration as beats, not paragraphs. One beat = one idea = one active moment.
3. scene plan - map each beat to a visual (still / Manim sub-asset / motion), an on-screen text, and a duration.
4. assets - produce visuals + narration audio via `reference/assets.md` (no fabricated media; placeholder + baked still on tool-miss).
5. narrate - sentence-level TTS per beat (see `reference/audio.md` for KO rate, multi-voice).
6. render - mux visuals + audio + captions -> MP4. Burned-in OR sidecar `.srt`, never neither.

## Beat cadence

- Active beat every 30-60s: a question, prediction, "잠깐, 왜 그럴까요?", or an on-screen task. Learner does something each beat.
- 초저/초고: shorter beats (~30s), one new idea, show-then-name. 중/고: up to 60s, may stack a second idea if SCAFFOLD allows.
- Total length: 초저 60-90s, 초고 90-120s, 중/고 120-180s. Longer is rarely better.
- Open with 동기유발 (a hook tied to the objective), close with a check ("이제 ~할 수 있어요" + one recap question).

## Tool chain (primary -> fallback, log every substitution)

- Narration: premium TTS -> Supertonic local KO (`reference/audio.md`). Student-data/consent concerns -> local default.
- Motion / b-roll: Flow/Veo (premium) -> Ken-Burns slideshow fallback = still images + TTS + ffmpeg pan/zoom. Math/graph beat -> Manim sub-asset (`reference/manim.md`).
- Stills: Codex gpt-image-2 -> documented placeholder + baked still card (never an invented frame).
- Mux/captions: ffmpeg (always available locally). This stage never has an external dependency, so a piece always ships at least the Ken-Burns cut.

## Ken-Burns fallback (Claude-Code-only path)

Per beat: one still + its narration .wav. Pan/zoom each still over its audio duration, concat, attach captions. Log "Flow unavailable -> Ken-Burns slideshow".

```bash
# beat_03: still + narration -> 6s clip with slow zoom
ffmpeg -loop 1 -i beat_03.png -i beat_03.wav \
  -filter_complex "[0:v]scale=1920:-1,zoompan=z='min(zoom+0.0008,1.15)':d=150:s=1920x1080,format=yuv420p[v]" \
  -map "[v]" -map 1:a -shortest -c:v libx264 -c:a aac beat_03.mp4
# concat all beats, then burn captions
ffmpeg -i full.mp4 -vf "subtitles=captions.srt" -c:a copy final.mp4
```

## Captions (non-negotiable)

- Every video ships captions (`.srt`) AND the full script in the vault. Caption text = narration verbatim, CommonMark-clean, no emoji.
- Caption sentence length follows band floor (readlevel-gate): 초저 ~7 어절, 초고 ~10, 중 ~14, 고 ~20.

## Worked mini-example (초5 과학, 빛의 굴절 [6과05-01], 90s)

- Beat 1 (0-15s) 동기유발: 물잔 속 빨대가 꺾여 보이는 still. 자막 "빨대가 정말 부러진 걸까요?" [질문]
- Beat 2 (15-40s) 개념: 빛이 물에서 공기로 나올 때 꺾이는 Manim sub-asset. 자막 한 문장씩.
- Beat 3 (40-65s) 예측: "물을 더 부으면 빨대는 어떻게 보일까요?" 선택지 2개 still.
- Beat 4 (65-90s) 정리: "빛이 다른 물질로 들어갈 때 꺾이는 것을 굴절이라고 해요." 마무리 점검 1문항.
- facts.json: 굴절 정의 -> 2022 개정 과학 교과 용어. Narration: Supertonic KO (student-safe). Render: Ken-Burns (Flow off, logged). Output: final.mp4 + captions.srt + script.md.

## Done-when

- `edu-gate.sh` green; MP4 or documented placeholder; captions.srt + script in vault; every fact sourced; no emoji in captions.
