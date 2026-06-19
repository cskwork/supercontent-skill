# pdf-docs - 업무 문서 PDF 생성·읽기

Load from `reference/docs.md` when 다페이지 본문 PDF를 만들거나 기존 PDF를 읽을 때. **단일면 인쇄 포스터는 `reference/poster.md`** (범위가 다름: 포스터=게시·인쇄 1장, 여기=보고서/제안서 본문 문서).

## 생성 - 3경로 (우선순위는 상황별)

1. **HTML/CSS -> Chromium headless (primary, 실측 OK).** 고충실도, 기존 웹 자산 재사용, 설치 부담 적음. 한글은 시스템 폰트(NotoSansCJK/Nanum) 사용.
   ```bash
   "<chrome>" --headless --disable-gpu --no-pdf-header-footer \
     --print-to-pdf=out.pdf "file://$PWD/doc.html"
   ```
   chrome 경로 OS 분기는 `templates/doc-env.sh`(`chrome_to_pdf`). macOS `/Applications/Google Chrome.app/...`, Windows `chrome.exe`.

2. **HTML/CSS -> WeasyPrint.** `@page` 마진·페이지번호 등 인쇄 제어가 정밀. 단 시스템 Pango/Cairo 의존(미설치 환경 흔함) - `pip install weasyprint` 후 import 실패하면 Chromium으로 강등하고 `claims.md`에 기록. 라이선스 BSD(안전).

3. **코드 직접 -> ReportLab (표·차트·좌표 정밀).** 한글은 TTF를 `registerFont`로 등록(실측: AppleGothic .ttf 등록 후 한글 PDF 생성 확인). `.ttc`는 `subfontIndex=` 필요하나 PostScript outline .ttc(예: macOS `AppleSDGothicNeo.ttc`)는 reportlab이 거부한다(실측) - TrueType `.ttf`(AppleGothic/Nanum) 권장. `doc-env.py korean_ttf_path()`가 .ttf 우선 반환.
   ```python
   from reportlab.pdfbase import pdfmetrics
   from reportlab.pdfbase.ttfonts import TTFont
   pdfmetrics.registerFont(TTFont("KO", korean_ttf_path()))   # 경로는 doc-env.py
   c.setFont("KO", 12); c.drawString(72, 760, "한글 본문")
   ```
   라이선스 경고: ReportLab은 **LGPL + 상용 이중 라이선스**. 오픈소스 LGPL 범위를 넘는 상용 재배포는 별도 라이선스 검토. 단순 PDF 생성은 LGPL로 충분하나 `reference/sources.md`에서 재확인.

4. **docx/pptx/hwpx -> PDF 변환**은 생성이 아니라 변환: `reference/docx.md` / `hwpx.md`의 LibreOffice 경로.

## 읽기 - 텍스트·표·이미지 추출

| 목적 | 도구 | 라이선스 | 비고 |
|---|---|---|---|
| 텍스트 (기본) | `pypdf` | BSD | 실측: 한글 정확 추출. 병합/분할도 |
| 표 추출 (전문) | `pdfplumber` | MIT | 실측: 한글 정확. `page.extract_table(s)` |
| 고속·이미지·스캔 OCR | PyMuPDF(fitz) | **AGPL-3.0** | 경고: 상업 SaaS 통합 시 소스공개 전염. **기본 비채택**, 꼭 필요할 때만 + 라이선스 검토 |

```python
import pdfplumber
with pdfplumber.open("in.pdf") as pdf:
    text = pdf.pages[0].extract_text()
    table = pdf.pages[0].extract_table()      # list[list[str]]
# 또는 from pypdf import PdfReader; PdfReader("in.pdf").pages[0].extract_text()
```

스캔(이미지) PDF는 텍스트층이 없어 추출 결과가 빈다 - OCR(Tesseract `kor`)이 별도로 필요하며, 도구 부재 시 "스캔 PDF, OCR 미적용"으로 명시(빈 결과를 내용으로 위조 금지).

## 게이트

생성한 PDF의 본문 텍스트 근거는 `doc-claims.md`/별도 .txt로 옮겨 `doc-gate.sh`(korean+integrity). 차트·표지 색을 declare하면 `contrast-pairs.json` -> contrast-gate. 모든 수치/날짜/통계는 `facts.json` 출처 필수.
