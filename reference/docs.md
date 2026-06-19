# docs - DOCS mode hub (docx / pptx / pdf / hwpx 생성·읽기·변환)

Load at Mode = DOCS. The hub: pick the format, pick the operation, pick the gate. `pedagogy-core.md` wins only for 교육 대상 문서; 업무 문서는 doc-gate 규율을 따른다.

## What DOCS is for

Office/업무 문서와 교육 문서를 **파일 포맷으로** 생성·읽기·변환한다. 슬라이드 발표(deck)는 SLIDES, 단일면 인쇄물은 POSTER, 영상 자막 ingest는 REPURPOSE가 소유한다. DOCS는 그 외 본문 문서(보고서·제안서·학습지·평가지·가정통신문·공문)와 기존 문서 파일의 읽기/표 추출/형식 변환을 맡는다.

대상: 회사 업무 문서(보고서/제안서/안내문, Windows 동료가 .docx/.hwpx로 편집) + 교육 문서(학생/학부모 배포). 둘은 게이트가 다르다 (아래).

## Step 1 - 형식 + 작업 판별 (one-line, state it)

State e.g. `DOCS: 업무 보고서 -> .docx 생성, 한국어, A4` 또는 `DOCS: 기존 .hwpx 읽어 표 추출`.

| 작업 | 분기 | Reference |
|---|---|---|
| .docx 생성/읽기 (보고서·제안서·학습지·공문 본문) | python-docx | `reference/docx.md` |
| .pptx 정밀 생성/읽기 (셀·표·서식 제어; AI 초안은 SLIDES) | python-pptx | `reference/pptx-precise.md` |
| .pdf 생성 (업무 문서) / .pdf 읽기·표 추출 | WeasyPrint·ReportLab·Chromium / pdfplumber·pypdf | `reference/pdf-docs.md` |
| .hwpx 생성/편집/읽기/검증 (한글, 한국 공교육·공공·기업 표준) | python-hwpx | `reference/hwpx.md` |
| 형식 무관 기존 문서 읽기 (어떤 파서를 언제) | 통합 매트릭스 | `reference/doc-ingest.md` |
| 형식 변환 (hwpx<->docx<->pdf 등) | LibreOffice + H2Orestart | `reference/hwpx.md` 변환 섹션 |

POSTER(단일면 인쇄물)와 pdf-docs(다페이지 본문 PDF)는 범위가 다르다 - 인쇄 포스터는 `reference/poster.md`로.

## Step 2 - 게이트 분기 (대상이 가른다)

문서의 **대상(audience)**으로 검증 트랙을 가른다. 신호: `curriculum-claims.json`의 유무.

- **교육 대상 문서** (학생/학부모 배포: 학습지, 평가지, 가정통신문, 차시 자료) -> 기존 `templates/edu-gate.sh`. 성취기준이 본질이므로 `curriculum-claims.json` 작성. 교육 콘텐츠 규율 전부 적용(`pedagogy-core.md`, 어절·읽기수준, safety band).
- **업무/성인 대상 문서** (회사 보고서, 제안서, 사내 공문) -> `templates/doc-gate.sh`. 교육과정·읽기수준 게이트는 부적합하므로 제외. 한국어 맞춤법/띄어쓰기(korean-gate)와 사실 무날조(integrity-gate)는 그대로 적용 - 업무 문서에서 미출처 수치는 오히려 더 위험하다.

하드 규칙: 학생에게 배포되는 문서는 반드시 edu-gate. doc-gate를 교육 문서의 우회로로 쓰지 않는다. 모호하면 한 질문, 비대화형이면 보수적으로 edu-gate.

## Vault 계약

업무 문서 vault (`templates/`에서 시작):
- 필수: `doc-claims.md` (형식/대상/페이지/폰트/변환 타깃 선언 - dials 없음), `facts.json` (수치·날짜·통계 출처; 없으면 `[]`).
- 선택: `contrast-pairs.json` (표지/도표 색 대비를 declare했을 때만).
- **`curriculum-claims.json` 없음** = doc-gate 트랙 신호.

교육 문서 vault: 기존 edu-gate 계약 그대로(`claims.md` + `curriculum-claims.json` + `facts.json` + ...). `agents/builder.md` + `reference/pedagogy-core.md`로 위임.

## 환경 (cross-platform, 한 번 확인)

- Python 라이브러리는 venv 권장. macOS/Linux 시스템 Python은 PEP 668로 전역 `pip install`이 막힌다: `python3 -m venv venv && ./venv/bin/pip install ...` (Windows: `py -m venv venv`, `venv\Scripts\pip install ...`).
- 핵심 패키지(전부 순수 Python, MIT/BSD/Apache): `python-docx python-pptx pdfplumber pypdf python-hwpx`. 생성 보강: `reportlab`(LGPL+상용 주의) / `weasyprint`(시스템 Pango 의존).
- 변환·한글 폰트의 OS 분기(soffice 경로, TTF 경로, registerFont, w:eastAsia)는 `templates/doc-env.sh` / `templates/doc-env.py`에 집약 - 각 형식 reference는 거기로 위임한다.
- 라이선스 경고는 형식 reference 인라인 + `reference/sources.md`. 특히 **PyMuPDF는 AGPL**(상업 통합 시 전염) - 기본 비채택.

## 비즈니스 보고 디자인 (업무 문서 공통)

경영/대표 보고 문서는 기본 텍스트 나열로는 부족하다 - 형식 간 통일된 비주얼 위계를 적용한다. 공통 팔레트:

- primary 딥 슬레이트 `#273340` (표지/헤더 배경 + 흰 텍스트), accent 절제된 블루 `#3D5A80` (강조 단 한 곳), ink `#1F2933`, 연회색 `#F3F5F7`. anti-slop: 색을 최소화하고 위계로 승부 - 탁한 머스타드/황토, 의미 없는 베이지, 네온은 전형적 AI slop이니 금지.
- 상태색(RAG): Green `#2E6F5E` / Amber `#E3A82B`(**밝은 골드 + 다크 텍스트** - 골드를 어둡게 누르면 갈색=AI slop이 되니 반대로) / Red `#B0413E`. 배지 위 텍스트는 밝은 골드엔 다크, 진한 색엔 흰색.
- 형식별 구현: PPTX는 `pptx-precise.md`(도형 띠·배지·컬러 표), DOCX는 색 헤딩 + 셀 음영(`w:shd`) + 상태 셀색, PDF는 HTML/CSS 표지·배지(가장 자유로움), HWPX는 `ensure_run_style(color=, bold=, size=)`로 제목·헤더·상태 색(`reference/hwpx.md`).
- contrast 필수: 모든 텍스트-배경 쌍을 `contrast-pairs.json`에 enumerate하고 `contrast-gate.mjs`로 WCAG AA 검증(흰 텍스트는 충분히 진한 배경에만). 검증된 색은 4형식이 공유한다.
- 메시지 구조(결론 먼저 action title, executive summary SCQA, status report 7섹션, RAG, 차트 takeaway)는 `reference/biz-report.md` - **디자인보다 이것이 먼저다**. 색이 예뻐도 결론이 묻혀 있으면 비즈니스 문서가 아니다.

## No-fabrication (문서에서 특히)

라이브러리·변환 도구 부재나 렌더 실패 -> **문서화된 placeholder**, 절대 "생성됨"으로 위조하지 않는다. 변환 미지원 경로는 원본 + 수동 변환 안내를 남긴다. 동작을 직접 보지 못한 경로를 "동작함"으로 쓰지 않는다(reference는 fallback-우선 서술). 보고서의 모든 수치/날짜/통계는 `facts.json` 출처 또는 삭제 - integrity-gate가 막는다.
