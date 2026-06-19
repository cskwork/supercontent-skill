# pptx-precise - PowerPoint 정밀 제어 (python-pptx)

Load from `reference/docs.md` when 단일 .pptx 파일을 셀·표·서식까지 정밀 제어해야 할 때. **AI 초안/발표 deck은 SLIDES**(`reference/slides.md`, presenton)가 소유한다 - 역할 구분:

- SLIDES: 차시/장수 기반 수업 deck, presenton AI 초안 -> 빠른 생성, 교육 게이트.
- DOCS/pptx-precise: 회사 발표자료의 특정 표·도형·좌표·서식을 코드로 결정론적으로 박을 때, 또는 기존 .pptx를 읽을 때.

라이브러리: `python-pptx` (MIT, 순수 Python, Windows/macOS 동일). 설치: `pip install python-pptx`. 실측: 1.0.2에서 생성·읽기 확인.

## 생성

```python
from pptx import Presentation
from pptx.util import Inches, Pt
prs = Presentation()                               # 또는 Presentation("회사템플릿.pptx")
s = prs.slides.add_slide(prs.slide_layouts[5])     # 5 = 제목만/빈, 6 = 완전 빈
tf = s.shapes.add_textbox(Inches(1), Inches(1), Inches(8), Inches(1)).text_frame
tf.text = "분기 실적"; tf.paragraphs[0].font.size = Pt(28); tf.paragraphs[0].font.name = "Malgun Gothic"
tbl = s.shapes.add_table(3, 2, Inches(1), Inches(2.5), Inches(8), Inches(2)).table
tbl.cell(0,0).text = "지표"; tbl.cell(0,1).text = "값"
s.shapes.add_picture("chart.png", Inches(1), Inches(5))   # 실제 파일만
prs.save("deck.pptx")
```

한글 폰트: docx와 같은 원리지만 python-pptx는 `font.name`만으로 동작하는 경우가 많다. 깨질 때는 단락의 `rPr`에 eastAsia를 다는 패턴을 `templates/doc-env.py`에서 가져온다. 폰트는 이름만 임베드되므로 협업 시 범용 폰트 권장.

## 읽기

```python
from pptx import Presentation
prs = Presentation("in.pptx")
for i, slide in enumerate(prs.slides):
    for sh in slide.shapes:
        if sh.has_text_frame: print(i, sh.text_frame.text)
        if sh.has_table:
            for r in sh.table.rows: print([c.text for c in r.cells])
```

한계(실측): 레이아웃 placeholder가 빈 텍스트박스로 함께 읽힌다(필터 필요). 표는 `shape.has_table`로 접근하지만 SmartArt·그룹 도형·차트 데이터는 고수준 API로 안 잡혀 XML 직접 파싱이 필요하다. 스피커 노트는 `slide.notes_slide.notes_text_frame.text`.

## 변환

`soffice --headless --convert-to pdf deck.pptx` (H2Orestart 불필요). 경로 래퍼는 `templates/doc-env.sh`.

## 게이트

업무 발표자료 -> `doc-gate.sh`. 텍스트 근거는 `doc-claims.md`/별도 .txt로 옮겨 korean-gate. 표의 수치는 `facts.json` 출처. 교육 발표면 SLIDES + edu-gate.
