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

## Document libraries (DOCS mode)

문서 생성·읽기·변환 라이브러리. 라이선스는 2026 실측 read - 재배포 전 각 패키지에서 재확인.

| Library | URL | License (verify) | Used for |
|---|---|---|---|
| python-docx | github.com/python-openxml/python-docx | MIT | .docx 생성·읽기 (한글 w:eastAsia) |
| python-pptx | github.com/scanny/python-pptx | MIT | .pptx 정밀 생성·읽기 |
| pdfplumber | github.com/jsvine/pdfplumber | MIT | PDF 텍스트·표 추출 |
| pypdf | github.com/py-pdf/pypdf | BSD | PDF 텍스트 추출·병합 |
| python-hwpx (airmang) | github.com/airmang/python-hwpx | Apache-2.0 | .hwpx 생성·편집·읽기·검증 (1급) |
| WeasyPrint | github.com/Kozea/WeasyPrint | BSD | HTML/CSS -> PDF (Pango 의존) |
| ReportLab | github.com/MrBitsBytes/reportlab | **LGPL + 상용 이중** | PDF 코드 직접 생성; 상용 재배포는 라이선스 검토 |
| PyMuPDF (fitz) | github.com/pymupdf/pymupdf | **AGPL-3.0** | 고속 PDF·이미지·OCR; 상업 SaaS 통합 시 전염 - **기본 비채택** |
| LibreOffice | libreoffice.org | MPL-2.0 / LGPL | headless 문서 변환(soffice CLI) |
| H2Orestart (ebandal) | github.com/ebandal/H2Orestart | **GPLv3 + Java** | LibreOffice용 HWP/HWPX import 확장; 별도 설치 |
| pyhwpx | pypi.org/project/pyhwpx | verify | (Windows 전용) 한컴 COM 자동화 - .hwp 포함, macOS 불가 |

라이선스 경고는 형식 reference(`pdf-docs.md`/`hwpx.md`) 인라인에도 둔다. AGPL/상용 이중/GPLv3는 결합 산출물의 배포 조건을 바꿀 수 있다 - 아래 규칙 적용.

## Attribution rule

- When code, prompts, or output derive from a repo above, name it and link it where the work is published (README, credits, or vault manifest).
- Capture the upstream license string at the time you pull, alongside the URL.

## Verify license before redistribution

- "check repo" = read the actual LICENSE file before shipping derived code or media; do not assume MIT/permissive.
- No license file or all-rights-reserved -> use for reference/learning only; do not redistribute its code or outputs.
- License on a dependency can differ from the skill's own terms - the strictest applies to the combined work.
- Generated media (Codex, Veo, TTS) carries the provider's usage terms; for student-facing redistribution, confirm those too.
