# doc-ingest - 기존 문서 읽기 통합 (어떤 파서를 언제)

Load from `reference/docs.md` when 기존 문서 파일을 읽어 내용·표·데이터를 뽑을 때. 영상 자막 ingest는 여기가 아니라 REPURPOSE(`reference/repurpose.md`) - 그쪽은 transcript 전용이다.

용도: 문서 요약/분석, 표 데이터 추출, 학년 재가공(교육)·재작성(업무)의 소스 확보, 변환 전 내용 확인.

## 파서 선택 매트릭스 (실측 기준)

| 형식 | 텍스트 | 표 | 진입 reference | 비고 |
|---|---|---|---|---|
| .docx | `python-docx` paragraphs | `doc.tables` | `reference/docx.md` | 단락-표 등장 순서 손실 - 순서 필요 시 `body` 자식 순회 |
| .pptx | `python-pptx` text_frame | `shape.has_table` | `reference/pptx-precise.md` | placeholder 빈 박스 필터, SmartArt/차트는 XML 직접 |
| .pdf (텍스트층) | `pypdf` | `pdfplumber` extract_table | `reference/pdf-docs.md` | 한글 정확 추출 확인. 스캔 PDF는 OCR 별도 |
| .hwpx | `hwpx` export_text/markdown | export_markdown 표 / `<hp:tbl>` | `reference/hwpx.md` | 라이브러리 부재 시 zipfile+ET lean |
| .hwp (구) | (Windows) pyhwpx / olefile PrvText | pyhwpx | `reference/hwpx.md` | macOS는 .hwpx 변환 후 처리 |

## 공통 절차

1. 형식 판별(확장자 + 실제 매직). .hwpx/.docx/.pptx는 모두 ZIP - `file`/매직만으로는 구분 안 되니 내부 구조(`Contents/` vs `word/` vs `ppt/`)로 확정.
2. 해당 reference의 읽기 섹션으로 추출. 표가 핵심이면 표 전용 도구(pdfplumber/export_markdown).
3. 출처·저작권 기록: 받은 문서의 출처/작성자/사용 권한을 vault에 남긴다. 외부 문서 재사용은 권리 범위 내에서만(교육 자료 재가공 시 특히).
4. 추출 결과를 .txt/.md로 저장하면 이후 korean-gate/integrity-gate·LLM 분석에 바로 쓸 수 있다.

## 무결성 (위조 금지)

- 스캔 PDF/이미지 기반 문서는 텍스트층이 없어 추출이 빈다 - "OCR 미적용으로 빈 결과"를 명시하고, 빈 내용을 채워 넣지 않는다.
- 추출 텍스트의 수치/주장을 그대로 재배포할 때는 원문 출처를 유지(`facts.json`). 자동 추출은 오인식이 있으니 핵심 수치는 원문 대조.
- 라이브러리/도구 부재 시 "이 형식은 <도구> 필요, 미설치"로 남기고 가짜 추출을 만들지 않는다.
