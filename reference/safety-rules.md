# safety-rules - child-safety authority behind safety-gate.mjs

The human-readable rules the deterministic `safety-gate.mjs` enforces, plus the judgment calls it cannot make. Content for minors: when in doubt, leave it out.

## What the script blocks (deterministic)

- **Emoji** - banned in every deliverable (house rule). Use `[목적]`/`[활동]` bracket markers.
- **PII** - phone numbers, 주민등록번호 shapes, email addresses. Never embed real personal data; use clearly fictional placeholders in worksheet samples (and add `edu-ok` on that line if a sample address is pedagogically needed).
- **Forbidden topics per band** - from `forbidden-topics.json`. Universal (all ages): 자살/자해 방법, 마약 사용, 음란물, 도박, 무기·폭발물 제조, PII 요구. Stricter for 초저/초고: 살해·시체 묘사, 음주·흡연, 잔혹 묘사.
- **Insecure links** - `http://` (use https or remove). External links for minors should point to vetted, age-appropriate destinations only.
- **CommonMark breaks** - heading/list with no blank line before (renders wrong, reads broken).

## What the Critic must judge (the script cannot)

- **Tone and framing.** A topic can be on the allow-list but framed scarily or insensitively. Read for fear, shaming, stereotyping, or anything that singles out a group.
- **Cultural/representational fit.** Korean classroom context; diverse, respectful representation; no gender/region/disability stereotypes.
- **Commercial safety.** No ads, no brand promotion, no data-collection prompts aimed at children.
- **Developmental appropriateness.** Abstract fear/death/violence themes that are technically allowed may still be wrong for 초저. Escalate to teacher review.
- **Context of a flagged term.** Science/history legitimately use words like "폭발"(화산), "전쟁"(역사). The gate may not flag these (patterns target unsafe phrasings), but if it does, confirm the context is educational and add `edu-ok` with a one-line reason - never broaden the gate's allow by editing the script.

## Escalation

- Anything uncertain for minors -> flag "교사 확인 필요" in the report and do not ship without consent.
- Publishing to an LMS/channel/public post, or sending any student-identifying data to an external tool (TTS/image/video API), is a HARD STOP requiring explicit consent. Prefer local/self-hosted tools when student data is involved (see `reference/tools.md`).
