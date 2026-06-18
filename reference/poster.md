# poster - POSTER medium

Load at Build when medium = POSTER. `pedagogy-core.md` always wins on conflict.

Deliverable: one print-safe layout (A4 or A3), HTML -> PDF. Done-when: `edu-gate.sh` green incl. contrast on every text-bg pair.

## What POSTER is for

A single static surface a learner reads at distance or on a board: 안내문, 인포그래픽, 학습 포스터, 게시판 자료. One objective, one glance-hierarchy. Not interactive, not multi-page.

## Print-safe page setup

- Size: A4 (210x297mm) default; A3 (297x420mm) for board/게시판. Set both in CSS so it prints exact.
- Margins: >=12mm safe area; nothing critical in the bleed.
- Color: high contrast for print; avoid pale-on-white. Background tints light enough that black text passes AA on paper.

```css
@page { size: A4; margin: 12mm; }
@media print { html,body{ -webkit-print-color-adjust:exact; print-color-adjust:exact } }
:root{ --ink:#1f2123; --bg:#faf9f6; --accent:#1f6f5c }
```

## Infographic hierarchy

- One title that states the objective. One dominant element (chart/image/big number). Then 3-5 supporting blocks, ordered by reading priority.
- Type scale large: poster is read at distance. Title huge, headings clear, body still legible at print size (test at 100% print, not screen zoom).
- Whitespace is structure - group related, separate unrelated. No wall of text.
- Korean: `word-break: keep-all`, manual breaks at phrase boundaries so 어절 never splits.
- No emoji; bracket markers `[목적]`/`[활동]`/`[정리]` as labels.

## Integrity - no fabricated stats

Every number, date, statistic, or figure on a poster must be sourced in facts.json or cut. A poster reads as authoritative - an invented stat is the worst place for one. integrity-gate blocks unsourced factual signals. Chart values trace to a declared source.

## Image via asset chain (assets.md)

Primary = Codex gpt-image-2; degrade per assets.md to local/Claude-Code path; never a faked or scraped-without-license image. Record source + license in the vault. Prefer 공공누리/CC/originals. Alt text on every image for the digital PDF.

## HTML -> PDF render: primary -> fallback

1. **Headless Chromium (primary)** - exact `@page` + print colors.

   ```bash
   chromium --headless --no-pdf-header-footer --print-to-pdf=poster.pdf \
     --no-margins file://$PWD/poster.html
   # or: npx playwright ... page.pdf({format:'A4', printBackground:true})
   ```

2. **wkhtmltopdf (fallback)** if no Chromium: `wkhtmltopdf -s A4 poster.html poster.pdf`. Weaker CSS support - re-verify layout, log substitution.

3. **HTML-only (last resort)** if no PDF engine at all: ship `poster.html` with correct `@page`, document "PDF engine unavailable - print HTML to PDF via browser Ctrl+P, A4, background graphics on." Log in claims.md.

## Worked mini-example

Read: POSTER for 초고 과학, 분리수거 안내 [관련 단원], A3 게시판용. Dials: FUN med, LOAD low, SCAFFOLD high.

Layout (top to bottom hierarchy):

```
[제목] 올바른 분리수거, 이렇게 해요        <- dominant, huge
[대표 이미지] 4칸 분리함 (Codex 생성, alt 기재)
[활동] 3 step blocks, each: 큰 아이콘풍 그림 + 한 줄
   1 헹궈요  2 비닐 떼요  3 나눠 담아요
[정리] 헷갈리기 쉬운 것 표 (출처: 환경부 지침 -> facts.json)
[목적] 한 줄 요약 + 우리 반 실천 약속
```

Render: Chromium headless -> A3 PDF, printBackground on. Enumerate every text-bg pair (제목/bg, 본문/tint, 표 헤더/accent) -> contrast-pairs.json. Confirm 표의 모든 수치/지침 has a source row in facts.json -> `edu-gate.sh`. Fallback trace if no Chromium: wkhtmltopdf, re-verify A3 sizing, log.
