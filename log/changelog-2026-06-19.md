# 2026-06-19 - DOCS 모드 추가 (업무/교육 문서 docx·pptx·pdf·hwpx)

## 무엇을

교육 콘텐츠 전용이던 supercontent에 11번째 모드 `DOCS`를 추가. 직장인 업무 문서(보고서·제안서·PDF·PPT·한글 HWPX)와 교육 문서를 파일 포맷으로 생성·읽기·변환. Windows/macOS 호환. hwpx 1급 풀 지원(생성·편집·읽기·검증).

## 왜 / 결정과 근거

- **새 모드 신설(흡수 아님).** SLIDES(발표 deck/presenton)·POSTER(단일면 인쇄)·REPURPOSE(영상 자막)와 본질이 다르고, 업무 문서는 교육 게이트를 통과할 수 없어 게이트 분기가 필요한데 그 분기는 모드 경계에서 가장 깨끗하다.
- **게이트 분기 = `curriculum-claims.json` 유무.** edu-gate.sh는 이 파일에서 학년 band를 파생하므로 업무 문서(성취기준 없음)는 구조적으로 통과 불가. 그래서 업무용 `doc-gate.sh`를 신설하되 **기존 게이트를 재사용만** 한다: safety(band 없이 호출 = 이모지/PII/링크/universal 금지어), korean(맞춤법/띄어쓰기), integrity(수치/날짜 출처), contrast(pairs 선언 시). curriculum/readlevel은 제외. 기존 edu-gate.sh·6개 .mjs·curriculum-index.json은 한 줄도 수정하지 않음(무회귀).
- **safety-gate를 band 없이 재사용 가능함을 코드로 확인.** Plan 초안은 "safety 분리는 v2"로 미뤘으나, 실제 safety-gate.mjs를 읽으니 RULES(이모지/PII/링크/CommonMark)와 universal 금지어가 band와 무관하게 동작 → 추가 코드 없이 doc-gate에 포함. 메모리의 "이모지 금지" 정책도 결정론적으로 강제됨.
- **cross-platform 헬퍼를 한 곳에.** soffice/chrome 경로·한글 폰트·변환을 `templates/doc-env.py`(전 OS, sys.platform 분기)에 집약하고 `doc-env.sh`는 bash 래퍼. 각 reference는 OS 경로를 직접 적지 않고 위임.

## 실측으로 확정한 사실 (no-fabrication)

- python-hwpx 2.11.1(Apache-2.0, import `hwpx`): `HwpxDocument.new()/add_paragraph/add_table/set_header_text`, `save_to_path()`(save는 deprecated), `export_text/markdown/html`, `validate()`. 한글 라운드트립 확인. `.hwpx`=ZIP+XML(lean fallback: zipfile+ET).
- 변환 2경로: (1) `export_html`→Chrome headless→PDF(H2Orestart/Java 불필요, 확인), (2) LibreOffice+H2Orestart 직접(미설치 시 "source file could not be loaded" 확인 → 확장 필수). docx→pdf는 H2Orestart 없이 됨.
- PDF: reportlab+AppleGothic(.ttf)로 한글 PDF 생성, pypdf·pdfplumber 한글 정확 추출. macOS AppleSDGothicNeo.ttc는 reportlab이 PostScript outline 미지원으로 거부 → .ttf 우선.
- doc-gate 검증: 깨끗한 업무 문서 PASS, 이메일 PII→safety FAIL, 미출처 30%→integrity FAIL, 교육 edu-gate 무회귀 PASS.

## 거부한 대안

- 기존 SLIDES/POSTER에 흡수: 같은 모드 안에 edu/doc 게이트 조건 분기가 생겨 라우팅이 흐려짐.
- 별도 범용 문서 스킬로 분리: 사용자가 "이 스킬"로 통합을 원함.
- PyMuPDF(AGPL) 기본 채택: 상업 통합 시 전염 → pdfplumber/pypdf primary, PyMuPDF는 옵션+경고.
- `.hwp`(구 바이너리) 신규 생성/한컴 COM을 cross-platform으로: macOS 불가 → "1급 = .hwpx 한정"으로 범위 확정, hwp는 변환 의존.

## 추가/수정 파일

신규: `reference/{docs,docx,pptx-precise,pdf-docs,hwpx,doc-ingest}.md`, `templates/{doc-gate.sh,doc-claims.md,doc-env.sh,doc-env.py}`, `agents/doc-producer.md`.
수정: `SKILL.md`(DOCS 라우팅/tie-break/contract/reference map), `tests/mode-routing-contract.test.sh`(MODES +DOCS, 11 modes), `reference/{tools,sources,pdf-docs}.md`, `agents/edu-critic.md`(doc 트랙 단락), `README.md`/`README.ko.md`, `docs/index.html`.

## 검증

테스트 4종 green: gate-data-contract 9, gate-scenarios 15, mode-routing 3, reference-links 2. doc-env.py/doc-gate.sh 실측 통과.

---

# 2026-06-19 - 스킬 점검: 크로스플랫폼 file:// URL 버그 수정

## 무엇을

스킬 빌드 베스트프랙티스 + Windows/macOS 호환성 점검. 실제 결함 1건만 surgical 수정: `templates/doc-env.py`의 Chrome PDF 변환 URL 생성을 `"file://" + os.path.abspath(...)` → `Path(html_path).resolve().as_uri()`로 교체 (+`from pathlib import Path`).

## 왜 / 결정과 근거

- **진짜 크로스플랫폼 버그.** POSIX에선 `os.path.abspath`가 `/`로 시작해 `file:///...`로 우연히 맞지만, Windows에선 `C:\...`라서 `file://C:\...`(역슬래시 + host=C:)가 되어 Chrome headless가 로드 실패 → PDF 미생성. README가 "across Windows and macOS"를 명시 약속하므로 정합성 결함.
- **`Path.as_uri()`가 정답.** 전 플랫폼에서 RFC 8089 file URI 생성: POSIX `file:///...`(기존과 동일), Windows `file:///C:/.../`. 덤으로 공백 경로를 `%20` 인코딩 → 공백 포함 파일명(학습지·보고서)이 전 플랫폼에서 깨지던 잠재 버그도 해소. `PureWindowsPath(...).as_uri()` 시뮬레이션으로 `file:///C:/Users/x/lesson%20deck.html` 확인.
- **최소 변경.** 2줄. 잘 만들어진 스킬에 억지 변경 금지(commandment #5/#6).

## 거부한 대안 (Explore 에이전트 지적을 ground truth로 검증 후 기각)

- **게이트 .mjs의 CRLF 처리**: 전부 `text.split(/\r?\n/)` + 문장분리는 `.trim()`/`\s+`가 `\r` 흡수 → 이미 CRLF-safe. 코드 확인 후 기각.
- **doc-env.py env var 미검출**: `SOFFICE`/`CHROME` env override 이미 존재(26·44행). 기각.
- **셸 배열 quoting**: 이미 `"${SRC[@]}"`. 기각.
- **Windows 네이티브 bash 부재로 게이트 불가**: 스킬은 Claude Code가 실행하고 Claude Code Bash 도구는 전 OS에서 bash(Git Bash/WSL) 제공 → 실사용에서 게이트 정상 동작. 기각.
- **curriculum CODE_RE 2022개정 하드코딩**: 의도된 설계(데이터계약 테스트가 version=="2022 개정" assert). 기각.
- **`doc-env.py:117` Pyright `shapable: bool` 경고**: `TTFont(..., subfontIndex=0)`는 정상 ReportLab API. `**kw`(dict[str,int]) 언패킹을 stub이 잘못 매칭한 false-positive, 런타임 무결 + 작업 무관. 동작하는 fallback 코드를 linter 위해 바꾸지 않음.

## 검증

`Path(...).resolve().as_uri()` 실제 코드는 deprecated 아님(테스트 출력의 경고는 시뮬레이션용 `PureWindowsPath.as_uri()`에서 발생). 모듈 import OK, POSIX `%20` 인코딩 + Windows 시뮬 assert PASS, CLI `doc-env.py font` 정상, 기존 테스트 4종 무회귀 green(9/15/3/2).
