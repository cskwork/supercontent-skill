# pedagogy-core - always-on teaching + Korean-writing authority

The single authority every Builder and Critic re-reads. Medium references overlay this; they never override its base rules. If a medium tip conflicts with pedagogy-core, pedagogy-core wins.

## Teaching is the deliverable

- One piece, one objective. The 학습목표 (what the learner can DO afterward) is the spine; every scene/slide/screen serves it. Cut anything that does not.
- Lock to the 성취기준. Content that drifts off the declared standard is a defect even if it is fun. Fun is the delivery, not the destination.
- Right altitude. Match cognitive load to the band (see dials). Introduce one new idea at a time; build on prior knowledge the curriculum guarantees at that grade.
- Show, then name. Concrete example or visual first, the term second. Especially 초저/초고: experience before vocabulary.
- Active over passive. A question, prediction, drag, choice, or mini-task beats a wall of exposition. Aim for the learner to do something every ~30-60 seconds (video/interactive) or every slide.
- Misconception-aware. Name the common wrong idea and correct it; do not pretend it does not exist.
- Close the loop. End with a check (quiz item, recap question, "이제 ~할 수 있어요") tied to the objective.

## Dials (declare in claims.md)

- `FUN_INTENSITY` low|med|high - how playful the surface is (story, characters, game feel). Higher for younger bands and 동기유발; never at the cost of accuracy.
- `COGNITIVE_LOAD` low|med|high - how much new information per beat. Default low for 초저, med for 초고/중, med-high for 고. Over-load is the most common failure.
- `SCAFFOLDING` low|med|high - how much support (hints, worked examples, step labels). Higher when the skill is new; fade it within a series.

Band defaults: 초저 = FUN high / LOAD low / SCAFFOLD high. 초고 = FUN high / LOAD low-med / SCAFFOLD med. 중 = FUN med / LOAD med / SCAFFOLD med. 고 = FUN med / LOAD med-high / SCAFFOLD low-med.

## Korean writing style (enforced)

- Strict CommonMark spacing. A single newline is ignored by renderers; put a blank line between every paragraph, and a blank line before every heading and list. (safety-gate flags heading/list with no blank line before.)
- No emoji anywhere - cards, docs, slides, captions. Use bracket section markers instead: `[목적]`, `[활동]`, `[정리]`.
- Sentence length by band (readlevel-gate enforces the floor): 초저 ~7 어절, 초고 ~10, 중 ~14, 고 ~20. Shorter is almost always better for younger learners.
- Plain, warm, direct. 존댓말 to the learner ("~해 봐요", "~할 수 있어요"). Define a term the first time it appears. Avoid English loanwords when a common Korean word exists.
- One idea per sentence. Split compound sentences for 초저/초고.

## Integrity (non-negotiable)

- Never fabricate a fact, statistic, date, citation, quote, figure, or historical claim. Source it (declare in `facts.json`) or cut it. integrity-gate blocks unsourced factual signals.
- Never fake media. Missing TTS/render/image tool -> a documented placeholder + a baked still, never an invented screenshot or claimed-but-absent file.
- Attribute reused material. Transcripts, images, music - record the source and license in the vault. Respect 저작권; prefer 공공누리/CC/originals.

## Accessibility (honor over aesthetics)

- WCAG AA contrast on all text (contrast-gate). Respect `prefers-reduced-motion`. Captions/script for all audio and video. Tap targets and font sizes generous for younger bands.

## Pre-flight judgment checks (Critic eyeballs, beyond the scripts)

- Does it actually teach the objective, or just entertain around it?
- One new idea at a time, or overloaded?
- Misconception addressed? Closing check present and tied to the standard?
- Korean natural and age-appropriate in tone, not just in sentence length?
- Every fact in `facts.json` actually correct (not just sourced)?
