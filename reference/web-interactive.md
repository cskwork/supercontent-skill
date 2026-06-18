# web-interactive - WEB medium

Load at Build when medium = WEB. `pedagogy-core.md` always wins on conflict.

Deliverable: one self-contained `index.html` learning widget. Done-when: `edu-gate.sh` green incl. contrast every pair.

## What WEB is for

A small interactive that makes the learner DO the objective: quiz, simulation, drag-sort/classify, flashcards, matching, slider-explore. Not a slide, not a page - one tight loop tied to one 성취기준.

Tie every interaction to the objective. If a control does not exercise the skill, cut it. Engagement is the delivery, not the point.

## Self-contained, no external dependency

- Single `index.html`: inline `<style>` + `<script>`. No external CDN at runtime - vendor any lib inline or write vanilla. Must open offline from a file path.
- No build step. No framework required (vanilla JS preferred for a widget). If state is heavy, a tiny inline reducer - not React-from-CDN.
- No PII, no tracking, no external fetch. Student answers stay in-page (or localStorage with a clear note).

## State + feedback (the teaching loop)

- Explicit state: `idle -> attempt -> feedback -> next`. Never silent.
- Immediate, specific feedback. Wrong answer -> say why + nudge, not just "X". Misconception-aware: if the wrong option is the common 오개념, name it.
- Progress visible (n/total). Closing recap ties back to objective.
- No dark patterns, no punitive scoring for young bands. Retry is free.

## Accessibility + reduced-motion (non-negotiable)

- Full keyboard: Tab order logical, Enter/Space activate, focus ring visible. Drag interactions need a keyboard alternative (select-then-place, or arrow-move).
- `aria-live="polite"` region for feedback so screen readers hear results.
- Labels on every control; `role`/`aria-pressed` on custom buttons.
- WCAG AA contrast every text-bg pair -> contrast-pairs.json. Tap targets >=44px (larger for 초저).
- `@media (prefers-reduced-motion: reduce)` -> disable transitions; correctness never depends on animation.
- Korean: `word-break: keep-all` so 어절 never splits.

## Primary -> fallback

Primary path is Claude Code direct (vanilla HTML/CSS/JS) - already self-contained, no tool to degrade. If a richer sim needs a physics/canvas lib, vendor it inline; if that bloats past readable, fall back to a simpler mechanic that still teaches the objective and log the trade in claims.md. Never reach for a runtime CDN.

## Worked mini-example - 드래그분류 widget

Read: WEB for 초고 과학, 동물 분류(척추/무척추) [4과 XX-XX]. Dials: FUN med, LOAD low-med, SCAFFOLD med.

Loop: 8 동물 카드 -> drag into 척추동물 / 무척추동물 bins -> drop checks -> feedback names the trait ("개구리는 등뼈가 있어요 - 척추동물").

Skeleton:

```html
<!doctype html><html lang="ko"><head><meta charset="utf-8">
<style>
  :root{--ok:#1f6f5c;--no:#9a3b2f;--bg:#faf9f6;--ink:#1f2123}
  body{background:var(--bg);color:var(--ink);font-size:20px}
  .card{min-height:48px;padding:12px}
  .bin{min-height:120px;border:2px dashed #555}
  @media (prefers-reduced-motion:reduce){*{transition:none!important}}
</style></head><body>
<h1>동물을 등뼈로 나눠 보세요</h1>
<div id="live" aria-live="polite"></div>
<!-- cards: draggable + keyboard: focusable, Enter picks, bin Enter drops -->
<script>
  const TRAIT={개구리:'척추',나비:'무척추'/*...*/};
  function place(card,bin){
    const ok = TRAIT[card]===bin;
    live.textContent = ok
      ? card+'은(는) 등뼈가 있어요 - 척추동물이 맞아요'
      : card+'은(는) 등뼈가 없어요 - 다시 한 번 생각해 볼까요';
    // free retry, no score penalty
  }
</script></body></html>
```

Keyboard alt: each card focusable, Enter "집기", focus a bin, Enter "놓기". Feedback to `#live`. Then enumerate contrast pairs (ink/bg, ok/no on bg) -> `edu-gate.sh`.
