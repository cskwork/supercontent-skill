[English](README.md) | **한국어**

# supercontent

한국 초중고(K-12) 교육과정용 교육 콘텐츠 메이커를 Claude Code 스킬로 만든 것. 의도를 읽고, 학년 밴드가 무엇에 반응하는지 짚고, 알맞은 매체로 라우팅해, 결정적 교육-적합성 게이트를 통과한 "아이들이 즐기는" 콘텐츠를 만듭니다. 자기완결·이식 가능: 모든 단계가 Claude-Code-only / 로컬 경로로 우아하게 강등되며 대체를 기록합니다. 교실 밖에서는 DOCS 모드가 직장인 업무 문서(보고서·제안서·PDF·PPT·HWPX)도 생성·읽기·변환합니다 - Windows/macOS 호환.

랜딩 페이지: https://cskwork.github.io/supercontent-skill

자매 스킬 [superdesign](https://cskwork.github.io/superdesign-skill)의 구조를 그대로 따릅니다. 현재 연도 2026, 교육과정 = 2022 개정.

## 평범한 프롬프트보다 더하는 것

- **교육과정 먼저, 재미는 그 다음 - 그러나 재미는 선택이 아님.** 모든 작품은 성취기준과 학습목표에 잠깁니다. 재미는 전달 방식이지 목적지가 아닙니다.
- **의도 기반 라우팅.** 요청을 11개 모드 중 하나로 분류하고, 학년 밴드에 맞는 매체와 인지 부하를 고릅니다. 하나의 기본 틀이 아닙니다.
- **트렌드 인지, 트렌드 추종 아님.** 라이브 `WebSearch` 펄스(날짜가 박힌 오프라인 스냅샷 폴백)는 밴드에 반응하면서 교육과정에 맞고 안전한 트렌드만 적용합니다. 읽기는 날짜와 함께 기록.
- **적합성은 눈대중이 아니라 강제.** 결정적 게이트(`templates/edu-gate.sh`)가 빌드된 소스를 스캔합니다. 빌더는 절대 스스로 승인하지 않으며, edu-critic이 게이트를 돌리고 아무것도 편집하지 않습니다.
- **절대 날조 금지.** 지어낸 인용/통계/수치/날짜/사실 금지 - 출처를 달거나(`facts.json`) 잘라냅니다. 렌더/TTS/이미지 도구가 없으면 기록된 플레이스홀더이지 가짜 미디어가 아닙니다.
- **수업 자료만이 아니라 문서도.** `DOCS` 모드가 `.docx` / `.pptx` / `.pdf` / `.hwpx`를 교육 자료와 직장인 업무 문서 양쪽으로 생성·읽기·변환합니다. 업무 문서는 교육 게이트 대신 가벼운 `doc-gate`(맞춤법 + 사실 무결성 + 이모지/PII)를 돕니다. hwpx는 생성·편집·읽기·검증까지 1급 지원 - Windows/macOS 호환.

## 모드

먼저 모드와 한 줄 Read를 선언, 예: `Making this as: VIDEO for 초5 과학, 빛의 굴절 [6과05-01], 90초 explainer`.

| Mode | 용도 |
|---|---|
| VIDEO | 짧은 영상 / 쇼츠 / 애니메이션 설명 |
| MANIM | 수식·과학 애니메이션 / 그래프 / 도형 증명 |
| POSTER | 안내문 / 인포그래픽 / 학습 포스터 / 게시판 |
| WEB | 인터랙티브 HTML / 위젯 / 퀴즈 / 시뮬레이션 |
| SLIDES | PPT / 차시별 수업 자료 / 발표 (편집 가능 PPTX) |
| GAME | 학습 게임 / 카드 매칭 / 드래그 학습 |
| AUDIO | 듣기 자료 / 내레이션 / 동화 구연 |
| DOCS | 보고서 / 제안서 / 학습지 / docx · pptx · pdf · hwpx 생성·읽기·변환 (업무 + 교육) |
| REPURPOSE | 기존 영상 자막으로 수업자료 (중간물 -> 빌드 모드) |
| REVIEW | 검수 / 이거 학년에 맞아? (게이트 실행, 편집 없음) |
| EXPLORE | 방향 잡아줘 (2-4 방향, 어느 것도 확정 안 함) |

학년 밴드: 초저(초1-2), 초고(초3-6), 중, 고. 다이얼은 `claims.md`에 선언: `FUN_INTENSITY` / `COGNITIVE_LOAD` / `SCAFFOLDING` (각 low|med|high).

## 기본 루프 (빌드 모드) - 역할 분리

1. **Read.** 학년 밴드 / 과목 / 단원·차시 / 성취기준 / 학습목표를 추론하고 한 줄로 선언.
2. **Trend pulse.** 밴드가 지금 반응하는 것을 검색(스냅샷 폴백), 날짜와 함께 기록하고 다이얼 설정.
3. **Direction.** 한 포맷 패밀리 + 매체를 고르고, 해당 매체 레퍼런스를 로드.
4. **Build.** `reference/pedagogy-core.md` + 선택 매체에 맞춰 구현. 실제/생성 미디어만, 날조 금지.
5. **Critique** (독립). 주장·용어·쌍을 vault JSON에 열거하고 `templates/edu-gate.sh` 실행, 모든 위반 기록.
6. **Verify.** 위반마다 최소 수정, 초록될 때까지 재실행, 출력과 함께 보고. 최대 3회.

**Vault**는 작품별 작업 디렉터리(기본 `.supercontent/<piece>/`): `content-brief.md`, `trend-pulse.md`, `claims.md`, `curriculum-claims.json`, `facts.json`, `contrast-pairs.json`. Vault 없으면 게이트도 없음.

## 빠른 시작

```
/supercontent "초5 과학 빛의 굴절 인터랙티브"
/supercontent "초3 곱셈 학습 게임 만들어줘"
/supercontent "중2 역사 차시별 PPT"
/supercontent "이 영상 자막으로 수업자료"   # REPURPOSE
/supercontent "분기 실적 보고서 docx로"       # DOCS (업무 생성)
/supercontent "이 hwpx 학습지 표 추출해줘"    # DOCS (읽기)
/supercontent "이거 초2 학년에 맞아?"        # REVIEW
```

## 교육-적합성 게이트

```bash
# 작품 vault 전체 게이트 (교육과정 + 안전 + 읽기수준 + 무결성 + 명암)
bash templates/edu-gate.sh .supercontent/<piece> path/to/index.html
```

순서대로 실행: `curriculum-gate.mjs`(성취기준 vs `reference/curriculum-index.json`), `safety-gate.mjs --band <band>`(이모지 / PII / 금지 주제 / 안전하지 않은 링크 / CommonMark), `readlevel-gate.mjs --band <band>`(어절 길이 + 어휘 등급), `integrity-gate.mjs <facts.json>`(출처 있는 사실), `contrast-gate.mjs`(WCAG AA).

업무 문서(DOCS, 비교육)는 교육 게이트 대신 `templates/doc-gate.sh`를 씁니다 - `curriculum-claims.json` 없이 safety(이모지/PII/링크) + korean(맞춤법·띄어쓰기) + integrity(출처) (+contrast)만 돕니다. `curriculum-claims.json`의 부재가 두 트랙을 가릅니다. 학생/학부모 배포 문서는 반드시 edu-gate.

## 하우스 룰 (게이트가 강제)

- 이모지 절대 금지. 대신 대괄호 마커 사용: `[목적]`, `[활동]`, `[정리]`.
- 엄격한 CommonMark 간격: 모든 문단 사이, 모든 heading·list 앞에 빈 줄.
- 사실·미디어 날조 금지. WCAG AA, `prefers-reduced-motion`, 자막 준수.

## 도구 포지션

프로젝트 선택에 따른 품질 우선. 주력 = Codex gpt-image-2(이미지), 프리미엄 TTS + Flow/Veo(영상). 모든 단계는 Claude-Code-only / 로컬 경로로 우아하게 강등하고 대체를 기록합니다. 학생 데이터가 관여하면 로컬/자체 호스팅(Supertonic TTS, presenton+Ollama)을 선호하고, 외부 전송은 동의 하드스톱입니다.

## 출처

역량과 패턴 참조: [youtube-autopilot](https://github.com/cskwork/youtube-autopilot)(엔드투엔드 스테이지 루프), [OpenMontage](https://github.com/calesthio/OpenMontage)(몽타주/설명), [youtube-automation-agent](https://github.com/darkzOGx/youtube-automation-agent), [supertonic-tts](https://github.com/cskwork/supertonic-tts)(로컬 한국어 TTS, 멀티 보이스), [Math-To-Manim](https://github.com/HarleyCoops/Math-To-Manim)(ManimCE + LaTeX, 한국어는 XeLaTeX/CJK 폰트), [youtube-transcript-api](https://github.com/jdepoix/youtube-transcript-api)(Python, `languages=['ko']`, API 키 불필요), [presenton](https://github.com/presenton/presenton)(자체 호스팅 PPT 생성, Ollama/BYOK, PPTX 내보내기, MCP 호출), [ppt-master](https://github.com/hugohe3/ppt-master)(에이전트형 PPT), DOCS 모드용 [python-docx](https://github.com/python-openxml/python-docx), [python-pptx](https://github.com/scanny/python-pptx), [pdfplumber](https://github.com/jsvine/pdfplumber), [pypdf](https://github.com/py-pdf/pypdf), [python-hwpx](https://github.com/airmang/python-hwpx)(HWPX 1급), [WeasyPrint](https://github.com/Kozea/WeasyPrint), LibreOffice + [H2Orestart](https://github.com/ebandal/H2Orestart). 구조는 [superdesign](https://cskwork.github.io/superdesign-skill)를 따름. 전체 출처와 라이선스는 `reference/sources.md`.

## 연도 기준

현재 연도는 2026. 모든 날짜 콘텐츠·스냅샷·"현재" 참조는 2026 기준. 교육과정 기준선은 2022 개정(2026년 현행).
