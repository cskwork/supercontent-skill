# audio - AUDIO build (narrated audio / 듣기 자료 / 팟캐스트)

Overlay on `pedagogy-core.md`. Script -> sentence-level TTS -> optional ducked BGM. The script ships as captions, always. Contrast-gate is skipped (no visuals); every other gate still runs.

## Pipeline

1. script - write to band reading level + speaking rate (below). One idea per sentence. Mark speaker turns for dialogue.
2. sentence-level TTS - synthesize per sentence (not per paragraph): clean boundaries, easy re-takes, precise caption timing.
3. concat - join clips with small inter-sentence gaps (200-400ms; longer for 초저).
4. optional ducked BGM - mix bed under voice with sidechain ducking; skip if it hurts comprehension.
5. ship script as captions - the full text, CommonMark-clean, no emoji.

## Tool chain (primary -> fallback, log substitution)

- Default = Supertonic local KO (cskwork/supertonic-tts): on-device, multi-voice, privacy-safe. Use this by default for any student-data context - no external send.
- Premium TTS = opt-in only, and a hard-stop if it would send student data externally (consent required).
- Dialogue/podcast format -> NotebookLM podcast skill (`/notebooklm`) for two-voice conversation; still grade-level the script first and treat any upload as a consent gate.
- Missing all TTS -> documented placeholder + ship the script alone (teacher reads aloud). Never fake an audio file.

## Korean speaking-rate guidance (by band)

Slower for younger learners; let comprehension set the ceiling, not runtime.

- 초저: ~3.0-3.5 음절/초, generous pauses, single clause per breath.
- 초고: ~3.5-4.0 음절/초.
- 중: ~4.0-4.5 음절/초.
- 고: ~4.5-5.0 음절/초, near natural pace.
- Define a term the first time spoken; repeat key vocabulary once. Avoid English loanwords when a common Korean word exists.

## Multi-voice (Supertonic)

- Assign a stable voice per speaker; keep the narrator voice constant across a series.
- Dialogue 듣기 자료: 2 voices (e.g. 질문하는 학생 / 설명하는 친구) make turns audible. Label turns in the script for caption sync.

## Worked mini-example (초고 영어, 듣기 자료 - 길 묻기 대화, 60s)

- Script: 2 speakers, 8 short turns, 초고 rate (~3.7 음절/초), 한 문장 = 한 생각.
- TTS: Supertonic local, voice A = 묻는 사람, voice B = 답하는 사람 (no external send - student-safe default).
- Concat: 300ms gaps; light cafe BGM ducked -12 dB under voice.
- Captions: speaker-labeled script in vault; facts.json empty (no factual claims) but vocab checked by readlevel-gate.

```bash
# duck BGM under narration (sidechain) then mux
ffmpeg -i voice.wav -i bgm.mp3 -filter_complex \
  "[1:a]volume=0.3[bg];[bg][0:a]sidechaincompress=threshold=0.03:ratio=8[duck];[duck][0:a]amix=inputs=2" \
  -c:a aac dialogue.m4a
```

## Done-when

- `edu-gate.sh` green (contrast skipped); audio file or documented placeholder; speaker-labeled script as captions; speaking rate matches band; no external student-data send without consent.
