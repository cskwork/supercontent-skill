# doc-claims - 업무 문서 선언 (doc-gate 대상)

업무/성인 대상 문서의 빌더 선언. 교육 dials(FUN_INTENSITY / COGNITIVE_LOAD / SCAFFOLDING)는 없다 - 이 파일의 부재가 곧 doc 트랙 신호다. 학생/학부모 배포 문서는 이 파일이 아니라 `claims.md` + `curriculum-claims.json`(edu-gate).

## 문서 spec

- 형식: <docx | pptx | pdf | hwpx>
- 대상: <업무/성인 - 예: 사내 임원, 거래처>   # 학생/학부모면 edu-gate로 가야 함
- 목적: <보고서 | 제안서 | 안내문 | 공문 | 발표자료>
- 언어: <한국어 | 영어 | ...>
- 분량: <예: A4 3페이지 / 슬라이드 12장>
- 폰트: <맑은 고딕 | 나눔고딕 | AppleGothic>   # 협업 시 범용 폰트 권장 (doc-env.py korean_font_name)
- 변환 타깃: <없음 | pdf | hwpx | docx>

## 텍스트 근거 (doc-gate 검사 대상)

바이너리 문서(.docx/.pdf/.hwpx)는 본문을 텍스트로 추출해 여기 둔다 - doc-gate는 텍스트만 스캔한다.

- <본문 .txt/.md 경로>   # 예: body.txt (hwpx export_text / pdfplumber / docx paragraphs로 추출)

## run-to-prove

- `bash templates/doc-gate.sh <vault> <text files>`   # safety(이모지/PII/링크) + korean + integrity (+contrast)

## substitutions (도구/라이브러리 부재 시, 위조 대신 기록)

- [substitution] <stage>: <primary> 불가 -> <대체 경로> (<이유>)
  예: [substitution] hwpx 변환: H2Orestart 미설치 -> export_html+Chrome PDF (확장 없음)
