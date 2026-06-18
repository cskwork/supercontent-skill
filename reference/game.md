# game - GAME medium

Load at Build when medium = GAME. `pedagogy-core.md` always wins on conflict.

Deliverable: one self-contained playable file, objective-locked. Done-when: `edu-gate.sh` green incl. contrast every pair.

## Objective-locked, not gamified-decoration

The mechanic must REQUIRE the skill - if a learner can win without using the objective, it is not a learning game. Loop:

`objective -> mechanic that forces the skill -> specific feedback -> scaffolded difficulty`

Difficulty ramps within the curriculum band; never adds new content the grade does not guarantee. No dark-pattern reward loops: no loss-aversion, no artificial scarcity, no streak-pressure, no punitive scoring for young bands. Free retry. Fun serves the objective, never replaces it.

## Engine by need (pick one, justify in claims.md)

| Need | Engine | When |
|---|---|---|
| 초저 tap / match / point | vanilla canvas or DOM | simplest input, biggest tap targets, least code |
| 2D arcade / platform / timed drill | Phaser | sprites, scenes, physics, score - 초고/중 drill |
| 3D explore / spatial concept | Three.js | volume, orbit, 입체 - 중/고 explore, lazy-load |

Default to the lightest engine that the mechanic needs. Vendor the engine inline or pin local - no runtime CDN; one playable file.

## 5 example archetypes (band + subject mapped)

1. **카드매칭 (memory match)** - 초저 / 국어·영어 어휘. canvas/DOM. Flip two cards, match 단어-그림. Skill forced: recall the pairing. Feedback names the word on match.
2. **드래그분류 (sort-into-bins)** - 초고 / 과학 분류·수학 도형. DOM drag + keyboard alt. Drop item in correct category; wrong drop explains the trait. Difficulty: more bins, finer distinctions.
3. **퀴즈런너 (endless-runner quiz)** - 중 / 사회·과학 개념. Phaser. Run, choose the correct gate to pass; wrong gate = gentle reset, not death. Skill forced: answer to advance.
4. **3D탐험 (explore-and-label)** - 고 / 과학 지구·천체, 수학 입체. Three.js. Orbit a model, click parts to label; objective is spatial understanding. Reduced-motion: auto-orbit off, manual only.
5. **수식격파 (equation-solve to clear)** - 중·고 / 수학 연산. canvas or Phaser. Solve to remove a block; only the correct value clears it. Skill forced: the computation IS the input.

## Accessibility + reduced-motion

- `@media (prefers-reduced-motion:reduce)`: stop auto-motion, parallax, screen-shake; game stays fully playable. Correctness never depends on animation.
- Keyboard playable (or a documented keyboard alt for pointer-only mechanics). Visible focus.
- WCAG AA contrast on all HUD/text/labels -> contrast-pairs.json. Tap targets generous (초저 largest).
- No flashing >3Hz. No audio-only cue without a visual twin. No emoji - bracket labels in UI.
- No PII, no external send, no leaderboards that expose names.

## Primary -> fallback

Primary is Claude Code direct (canvas / Phaser / Three.js inline). If a 3D build grows past a self-contained single file or a model asset cannot be sourced (assets.md), fall back to a 2D mechanic that teaches the same objective and log the substitution - never ship a faked model or a CDN dependency.

## Worked mini-example - 드래그분류 (archetype 2)

Read: GAME for 초고 수학, 도형 분류(다각형/원) [4수 XX-XX]. Dials: FUN med, LOAD low-med, SCAFFOLD med. Engine: DOM (lightest fit).

Loop: shapes spawn -> drag into 다각형 / 원 bins -> correct drop locks with a one-line reason ("변과 꼭짓점이 있어요 - 다각형") -> after 6 correct, add 모서리 수 distinction.

```js
const KIND = {삼각형:'다각형', 원:'원', 오각형:'다각형'/*...*/};
function drop(shape, bin){
  const ok = KIND[shape]===bin;
  announce(ok
    ? shape+'은(는) 곧은 변으로 둘러싸였어요 - 다각형'
    : shape+'을(를) 다시 살펴볼까요 - 변이 곧은가요');
  if(ok) lock(shape, bin);           // free retry on wrong, no penalty
  if(correctCount>=6) addLevel();    // scaffolded, stays in-band
}
```

Keyboard alt: shape focusable, Enter picks, bin Enter drops, `aria-live` announces. Reduced-motion: no spawn animation, instant placement. Enumerate HUD/label contrast pairs -> `edu-gate.sh`.
