**English** | [한국어](README.ko.md)

# supercontent

A master educational-content maker for the Korean K-12 curriculum (초중고) as a Claude Code skill. Read the intent, pulse what engages the grade band, route to the right medium, and ship content kids enjoy that passes a deterministic education-fit gate. Self-contained and portable: every stage degrades to a Claude-Code-only path and logs the substitution. Beyond the classroom, a DOCS mode also produces, reads, and converts workplace documents - 보고서·제안서·PDF·PPT·HWPX - across Windows and macOS.

Landing page: https://cskwork.github.io/supercontent-skill

Mirrors the structure of the sibling [superdesign](https://cskwork.github.io/superdesign-skill) skill. Current year 2026; curriculum = 2022 개정.

## What it adds over a plain content prompt

- **Curriculum first, fun second - but fun is not optional.** Every piece locks to a 성취기준 and a learning objective. Engagement is how it lands, never the goal itself.
- **Intent-driven routing.** Classifies the job into one of eleven modes and picks the medium + cognitive load that fit the grade band, instead of one default template.
- **Trend-aware, not trend-chasing.** A live `WebSearch` pulse (dated offline snapshot fallback) applies only trends that engage the band AND stay on-curriculum and safe. The trend read is recorded with its date.
- **Education-fit is enforced, not eyeballed.** A deterministic gate (`templates/edu-gate.sh`) scans the built source. The Builder never self-approves; edu-critic runs the gate and edits nothing.
- **Never fabricate.** No invented citation, statistic, figure, date, or fact - source it (in `facts.json`) or cut it. Missing render/TTS/image tool yields a documented placeholder, never faked media.
- **Documents, not just lessons.** A `DOCS` mode generates, reads, and converts `.docx` / `.pptx` / `.pdf` / `.hwpx` for both 교육 자료 and 직장인 업무 문서. Workplace docs run a lighter `doc-gate` (맞춤법 + 사실 무결성 + 이모지/PII), not the education gate. hwpx is fully supported - 생성·편집·읽기·검증 - cross-platform (Windows/macOS).

## Modes

State the mode and a one-line Read first, e.g. `Making this as: VIDEO for 초5 과학, 빛의 굴절 [6과05-01], 90초 explainer`.

| Mode | For |
|---|---|
| VIDEO | short video / explainer / 쇼츠 / 애니메이션 설명 |
| MANIM | math/science animation / 수식 / 그래프 / 도형 증명 |
| POSTER | 안내문 / 인포그래픽 / 학습 포스터 / 게시판 |
| WEB | interactive HTML / 위젯 / 퀴즈 / 시뮬레이션 |
| SLIDES | PPT / 차시별 수업 자료 / 발표 (editable PPTX) |
| GAME | 학습 게임 / 카드 매칭 / 드래그 학습 |
| AUDIO | 듣기 자료 / 내레이션 / 동화 구연 |
| DOCS | 보고서 / 제안서 / 학습지 / docx · pptx · pdf · hwpx 생성·읽기·변환 (업무 + 교육) |
| REPURPOSE | 기존 영상 자막으로 수업자료 (intermediate -> a build mode) |
| REVIEW | 검수 / 이거 학년에 맞아? (runs the gate, no edits) |
| EXPLORE | 방향 잡아줘 (2-4 divergent directions, commit to none) |

Grade bands: 초저(초1-2), 초고(초3-6), 중, 고. Dials declared in `claims.md`: `FUN_INTENSITY` / `COGNITIVE_LOAD` / `SCAFFOLDING` (each low|med|high).

## Default loop (build modes) - role-separated

1. **Read** the brief; infer 학년 band / 과목 / 단원·차시 / 성취기준 / objective; state it in one line.
2. **Trend pulse** - search what engages the band now (snapshot fallback), record dated; set dials.
3. **Direction** - pick one format family + medium; load that medium's reference.
4. **Build** to `reference/pedagogy-core.md` + the chosen medium; source real/generated media, never fabricate.
5. **Critique** (independent) - enumerate claims/terms/pairs into the vault JSONs; run `templates/edu-gate.sh`; log every violation.
6. **Verify** - fix each violation, re-run until green, report with output. Cap: 3 cycles.

The **vault** is the per-piece work dir (default `.supercontent/<piece>/`): `content-brief.md`, `trend-pulse.md`, `claims.md`, `curriculum-claims.json`, `facts.json`, `contrast-pairs.json`. No vault, no gate.

## Quickstart

```
/supercontent "초5 과학 빛의 굴절 인터랙티브"
/supercontent "초3 곱셈 학습 게임 만들어줘"
/supercontent "중2 역사 차시별 PPT"
/supercontent "이 영상 자막으로 수업자료"   # REPURPOSE
/supercontent "분기 실적 보고서 docx로"       # DOCS (업무 생성)
/supercontent "이 hwpx 학습지 표 추출해줘"    # DOCS (읽기)
/supercontent "이거 초2 학년에 맞아?"        # REVIEW
```

## The education-fit gate

```bash
# full gate on a piece vault (curriculum + safety + read-level + integrity + contrast)
bash templates/edu-gate.sh .supercontent/<piece> path/to/index.html
```

The gate runs, in order: `curriculum-gate.mjs` (성취기준 vs `reference/curriculum-index.json`), `safety-gate.mjs --band <band>` (emoji / PII / forbidden-topics / insecure-link / CommonMark), `readlevel-gate.mjs --band <band>` (어절 length + vocab tiers), `integrity-gate.mjs <facts.json>` (sourced facts), `contrast-gate.mjs` (WCAG AA).

업무 문서(DOCS, 비교육)는 교육 게이트 대신 `templates/doc-gate.sh`를 쓴다 - `curriculum-claims.json` 없이 safety(이모지/PII/링크) + korean(맞춤법·띄어쓰기) + integrity(출처) (+contrast)만 돈다. `curriculum-claims.json`의 부재가 두 트랙을 가른다. 학생/학부모 배포 문서는 반드시 edu-gate.

## House rules (the gate enforces these)

- No emoji anywhere. Use bracket markers instead: `[목적]`, `[활동]`, `[정리]`.
- Strict CommonMark spacing: a blank line between every paragraph and before every heading/list.
- Never fabricate a fact or media; honor WCAG AA, `prefers-reduced-motion`, and captions.

## Tool posture

Quality-first by project choice. Primary = Codex gpt-image-2 (images), premium TTS + Flow/Veo (video). Every stage degrades gracefully to a Claude-Code-only / local path and logs the substitution. When student data is involved, prefer local/self-hosted (Supertonic TTS, presenton+Ollama) and treat any external send as a consent hard-stop.

## Attribution

Capability and patterns draw on: [youtube-autopilot](https://github.com/cskwork/youtube-autopilot) (end-to-end stage loop), [OpenMontage](https://github.com/calesthio/OpenMontage) (montage/explainer), [youtube-automation-agent](https://github.com/darkzOGx/youtube-automation-agent), [supertonic-tts](https://github.com/cskwork/supertonic-tts) (local Korean TTS, multi-voice), [Math-To-Manim](https://github.com/HarleyCoops/Math-To-Manim) (ManimCE + LaTeX, Korean via XeLaTeX/CJK font), [youtube-transcript-api](https://github.com/jdepoix/youtube-transcript-api) (Python, `languages=['ko']`, no API key), [presenton](https://github.com/presenton/presenton) (self-hostable PPT gen, Ollama/BYOK, PPTX export, MCP-callable), [ppt-master](https://github.com/hugohe3/ppt-master) (agentic PPT), and for DOCS mode [python-docx](https://github.com/python-openxml/python-docx), [python-pptx](https://github.com/scanny/python-pptx), [pdfplumber](https://github.com/jsvine/pdfplumber), [pypdf](https://github.com/py-pdf/pypdf), [python-hwpx](https://github.com/airmang/python-hwpx) (HWPX 1급), [WeasyPrint](https://github.com/Kozea/WeasyPrint), and LibreOffice + [H2Orestart](https://github.com/ebandal/H2Orestart). Structure mirrors [superdesign](https://cskwork.github.io/superdesign-skill). Full attribution + licenses in `reference/sources.md`.

## Note on currency

Current year is 2026. All dated content, snapshots, and "현재" references are 2026. The curriculum baseline is the 2022 개정 standard (current in 2026).
