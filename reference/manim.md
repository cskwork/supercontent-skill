# manim - MANIM build (math/science animation, ManimCE)

Overlay on `pedagogy-core.md`. Use when the animation IS the whole deliverable (수식/그래프/도형 증명). Inside a VIDEO, this is a sub-asset, not the owner. Pattern source = Math-To-Manim (ManimCE + LaTeX).

## Pipeline

1. reverse-prerequisite ordering - start from the target concept, walk backward to the last idea the curriculum guarantees at this band. Animate forward from that floor. Never assume a step the grade has not met.
2. storyboard - one frame per cognitive step; each step adds exactly one new visual element. Over-stacking = the top failure.
3. scene-spec - per scene: objects, transforms (`Create`/`Transform`/`FadeIn`), on-screen KO label, hold duration, narration line.
4. render - ManimCE -> MP4 (`-qm` draft, `-qh` final). Pair with narration via VIDEO/AUDIO loop if voiced.

## Korean text (the setup that breaks silently)

ManimCE's default `Tex`/`MathTex` use LaTeX and render 한글 as blank boxes (tofu) unless configured. Two safe paths:

- `Text()` with a Korean font (no LaTeX needed for plain labels):

```python
from manim import *
class Refract(Scene):
    def construct(self):
        title = Text("빛의 굴절", font="Noto Sans KR", font_size=48)
        self.play(Write(title))
```

- `Tex` with the `kotex` package for mixed 한글 + 수식 - requires XeLaTeX and a CJK font installed:

```python
config.tex_template = TexTemplate(
    tex_compiler="xelatex", output_format=".xdv",
    preamble=r"\usepackage{kotex}\usepackage{amsmath}")
# then: Tex(r"입사각 $\theta_1$ 과 굴절각 $\theta_2$")
```

- Pure equations (no 한글 inside) work with default `MathTex`. Keep KO words in `Text()`, math in `MathTex`, and position them side by side - simplest reliable mix.
- Install once: XeLaTeX (TeX Live / MacTeX), `texlive-lang-korean` (kotex), a CJK font (Noto Sans KR / 나눔). Verify: `xelatex --version` and a one-line kotex compile before rendering scenes.

## Fallback chain (primary -> fallback, log it)

- ManimCE + XeLaTeX/kotex render -> if FFmpeg or LaTeX missing: static SVG diagram (matplotlib / hand-authored SVG) of the final frame + the storyboard as a stepped image series. Log "Manim render unavailable -> static SVG storyboard".
- Never claim an MP4 that was not produced. Ship the SVG series + scene-spec so a teacher can narrate the steps manually.

## Worked mini-example (중3 수학, 이차함수 그래프의 평행이동 [9수03-02])

- Reverse-prereq: target = `y=(x-2)^2+3` 이동. Floor = 학생이 아는 `y=x^2` 기본형. Start there.
- Scene 1: `MathTex("y = x^2")` + `Text("기본형", font="Noto Sans KR")`, draw parabola.
- Scene 2: Transform to `y=(x-2)^2` - `Text("오른쪽으로 2칸")` label, animate vertex slide.
- Scene 3: Transform to `y=(x-2)^2+3` - `Text("위로 3칸")`, animate vertical shift.
- Scene 4: hold final with vertex `(2,3)` marked; narration recap question.
- Render `-qh` -> MP4; if LaTeX absent -> 4-frame SVG series + scene-spec, logged. Captions = narration script (중 ~14 어절).

## Done-when

- `edu-gate.sh` green; MP4 or documented SVG fallback; KO text renders (no tofu); narration script as captions; prereq floor respected.
