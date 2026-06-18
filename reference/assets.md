# assets - media sourcing + the no-fabrication rule

Every visual/audio asset is real (generated or sourced) or an honest, labeled placeholder. integrity-gate + the Critic enforce this; the Builder must respect it while building.

## No-fabrication rule (non-negotiable)

- Never invent a citation, statistic, date, figure, quote, chart number, or screenshot.
- A fact that appears in content must be in `facts.json` with a source, or be cut.
- A media asset must exist on disk (generated or downloaded with license), or be a documented placeholder pointing to its spec - never a claimed-but-absent file.
- Missing tool != permission to fake. Drop a tier (see `reference/tools.md`) and log it.

## Image chain (quality-first -> placeholder)

1. Codex gpt-image-2 - primary. Generate to the brief; save file; record prompt in the manifest.
2. Real CC / 공공누리 image - when a real photo/diagram is needed (a specific place, artwork, organism, document) and generation would fabricate it. Download, capture license.
3. Documented placeholder - gray box + alt text + `[placeholder: image - <one-line desc + intended source>]`. Bake a still if a render needs one.

Never skip from 1 to "trust me it exists". A figure that must be factual (a real map, a real painting, a data chart) goes 2 or placeholder - generation must not invent it.

## Audio / video / render assets

- TTS, video, manim follow the `reference/tools.md` tiers; output a real file or a labeled placeholder (silent still + script, stills slideshow, final-frame PNG).
- A render that did not happen is a placeholder, not a description claimed as a finished file.

## Manifest (write to the vault)

Record per piece, in `claims.md` (or an `assets-manifest` block):

- asset id / filename
- tier used (gpt-image-2 | real-CC | 공공누리 | placeholder | TTS-cloud | Supertonic | Veo | stills | manim | manim-PNG)
- substitutions: `[substitution] <stage>: <primary> -> <tier> (<reason>)`
- for sourced media: source URL, license, attribution string, date captured

## License capture (sourced media)

- Record license (CC-BY, CC0, 공공누리 1-4유형, public domain, ...) and the required attribution string at download time, in the manifest.
- Honor 저작권: prefer 공공누리 / CC / originals. Unknown or all-rights-reserved -> do not use; placeholder instead.
- Attribution travels with the piece (caption, credits, or vault) wherever it is published.
- Student-created media is student data: local handling only, external send = consent hard-stop (see `reference/tools.md`).

## Pre-ship asset check

- [ ] Every on-screen fact in `facts.json` with a source
- [ ] Every asset is a real file or a labeled placeholder (no claimed-but-absent files)
- [ ] No invented citation / stat / figure / screenshot
- [ ] Sourced media has license + attribution captured
- [ ] Manifest lists tier + every substitution
