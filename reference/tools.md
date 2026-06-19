# tools - stage matrix, quality-first -> fallback -> last-resort

Per-stage tool routing. Quality-first by project choice; EVERY stage degrades to a Claude-Code-only / local path and logs the substitution. Builder picks the highest tier that runs; on miss, drop a tier and write the substitution to `claims.md`. Never fake the output of a missing tool.

## Subscriptions in play

- `Claude Code` - orchestration, scripting, critique, and all last-resort fallbacks. Always available.
- `Gemini` - Korean text/script drafting; Veo for premium video.
- `Codex` - gpt-image-2 for images (primary image tier).

## Stage matrix

| Stage | Primary (quality) | Fallback | Last-resort (always runs) | Driven by |
|---|---|---|---|---|
| text / script | Gemini KO draft -> Claude edit | Claude Code direct draft | Claude Code direct | Gemini, Claude |
| image | Codex gpt-image-2 | real CC / 공공누리 image | documented placeholder + baked still | Codex |
| TTS | premium TTS (cloud) | Supertonic local (self-host) | captioned silent still + script | external / local |
| video render | Flow / Veo | OpenMontage / Ken-Burns over stills | slideshow MP4 of stills + captions | Gemini (Veo) |
| manim | ManimCE + XeLaTeX KO | ManimCE no-LaTeX (Text only) | static frame PNG sequence | local |
| PPT | presenton + Ollama (REST) | PPT Master agentic | reveal.js HTML deck | local / Claude |
| transcript | youtube-transcript-api (`languages=['ko']`) | `.translate('ko')` of source lang | manual paste by user | local |
| doc generate | python-docx/-pptx, python-hwpx, WeasyPrint/Chromium | ReportLab (코드 직접) / lean zipfile | 텍스트 산출 + 변환 안내 placeholder | local |
| doc read | python-hwpx·pdfplumber·python-docx·python-pptx | zipfile+ET / pypdf | 사용자 수동 추출 | local |
| doc convert | LibreOffice + H2Orestart (`soffice`) | export_html + Chrome PDF (H2O 불필요) | 원본 + 수동 변환 안내 | local |

Degrade rule: tool absent or errors -> drop one tier, log `[substitution] <stage>: <primary> unavailable -> <tier used> (<reason>)` in `claims.md`. Two tiers down still failing -> emit the last-resort placeholder and flag for human.

## PRIVACY (hard rule)

- Student data (names, IDs, faces, voices, written work) -> LOCAL tools only: Supertonic TTS, presenton+Ollama, local ManimCE, on-disk transcripts.
- Any external send (cloud TTS, Veo, Codex, hosted API) carrying student data = consent HARD-STOP. Stop, state what would leave the machine, ask. No consent -> use the local tier or placeholder.
- No-student-data pieces may use cloud primary tiers freely.

## Install / run notes (self-hostable)

- presenton + Ollama: `docker run` presenton; point `LLM` env at local Ollama (`ollama serve`, pull a KO-capable model). REST `POST /api/v1/ppt/generate`; exports PPTX; MCP-callable. BYOK optional but defeats privacy - keep Ollama for student data.
- supertonic-tts (cskwork): clone, `pip install -r requirements.txt`, load KO voice pack; multi-voice; CLI/Python -> WAV. Fully offline.
- youtube-transcript-api (jdepoix): `pip install youtube-transcript-api`; `YouTubeTranscriptApi.get_transcript(id, languages=['ko'])`; `.translate('ko')` when only other langs exist; no API key.
- ManimCE: `pip install manim`; KO text needs XeLaTeX + a CJK font (e.g. Noto Sans KR) in the LaTeX template; render `manim -qh scene.py`.
- DOCS (`reference/docs.md`): venv 권장(macOS/Linux는 PEP 668로 전역 pip 차단). `pip install python-docx python-pptx pdfplumber pypdf python-hwpx` (+ reportlab/weasyprint 생성 보강). 변환은 LibreOffice `soffice`; .hwpx는 H2Orestart 확장(GPLv3, Java) 필요하거나 `export_html`+Chrome PDF로 강등. OS별 경로·한글 폰트·변환은 `templates/doc-env.py`/`doc-env.sh`. 라이선스: PyMuPDF=AGPL(기본 비채택), ReportLab=LGPL+상용, wkhtmltopdf=2023 아카이브(신규 채택 금지) - 자세히는 `reference/sources.md`.

## Graceful-degradation table

| Missing | Documented placeholder (never faked) |
|---|---|
| Codex image | gray box, alt-text caption, `[placeholder: image - <desc>]` in vault |
| premium TTS | silent still + on-screen script; `[substitution] TTS: cloud -> Supertonic` or placeholder |
| Veo / render | stills slideshow MP4 + captions; log tier used |
| ManimCE | static PNG of final frame + spec note |
| presenton | reveal.js HTML; note "PPTX export unavailable" |
| doc library (docx/pptx/pdf/hwpx) | 텍스트/HTML로 산출 + "라이브러리 미설치: <형식>" 안내 + 설치 명령 |
| hwpx 변환 (H2Orestart 없음) | export_html + Chrome PDF로 강등; 그것도 없으면 .hwpx 원본 + 수동 변환 안내 |

Rule: a placeholder is labeled and points to the real asset spec. Never invent a screenshot, render, or claimed-but-absent file.
