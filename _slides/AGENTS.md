# AGENTS.md

This directory contains Typst slide decks that use the local `greenbar.typ` template.
The goal of this guide is to keep slide authoring fast, correct, and syntax-safe.

## Scope

- Applies to `*.typ` slide decks in this directory.
- Assumes `#import "greenbar.typ": *` and `#show: slides.with(...)`.
- Focuses on practical authoring and avoiding Typst syntax mistakes.

## Minimal Deck Skeleton

Use this exact shape when starting a new deck:

```typ
#import "greenbar.typ": *

#show: slides.with(
  title: [Course Name],
  short-title: [CS 0000],
  subtitle: [Topic],
  author: [Name],
  institute: [School or Dept],
  short-institute: [Dept],
  date: [Term Year],
)

= Section Name
== Topic Name
=== Slide Title
Slide body content.
```

## Greenbar Authoring Contract (Critical)

`greenbar.typ` parses headings by depth. If you use the wrong level, slide layout breaks.

- `=`: section state (header + PDF outline)
- `==`: topic state (header + PDF outline)
- `===`: starts a new slide (title band text)
- `====`: subheading inside the current slide body

Rules:

- Never use `===` for inline emphasis; it always starts a new slide. `====` is the subheading level to use within a slide
- Put all body content after a `===` heading; content before the first `===` is ignored by slide rendering.
- Do not insert manual `#pagebreak`; the template handles pagination.
- Keep section/topic headings before the slide that should display them.

## Syntax Safety Rules

- Keep `#show: slides.with(...)` near the top and define it once per deck.
- In function calls (for example `#grid(...)`, `#table(...)`), prefer trailing commas in multiline argument lists.
- Close every delimiter deliberately:
  - `(...)` for function calls
  - `[...]` for content blocks
  - `{...}` for code/logic blocks
- When using inline code, wrap with backticks: `` `ra` ``.
- Use fenced raw blocks for code examples:

````typ
```c
for (int i = 0; i < n; i++) {
  sum += a[i];
}
```
````

- For math, use `$...$` inline and keep expressions simple per line.

## Layout Patterns That Work Well

- Two-column comparison:

```typ
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  [Left content],
  [Right content],
)
```

- Basic table:

```typ
#table(
  columns: 3,
  [*Col A*], [*Col B*], [*Col C*],
  [a1], [b1], [c1],
)
```

- Use `====` subheadings to split dense slides instead of starting a new slide too early.

## Content and Readability Guidelines

- One slide should make one clear point.
- Prefer short bullet lines; move long derivations/examples into code blocks or tables.
- Keep terminology consistent across slides (same label for same concept).
- If a slide exceeds comfortable reading density, split it with another `===` slide.
- It is sometimes helpful to repeat an idea or code snippet on a new slide to continue discussing it. For a complex idea or diagram, putting it in one column and using the other column for discussion that spans multiple slides is a good pattern

## Paper-Based Lecture Deck Guidelines

Use these defaults when creating slides from research papers for class.

- Audience: assume advanced undergraduate students (for example CS 3410), not domain specialists.
- Priority: emphasize core distributed systems ideas first (failure model, consistency model, control vs data plane, recovery, scaling tradeoffs), then paper-specific optimizations.
- Level of detail: include enough implementation detail for causal understanding of behavior and tradeoffs, but avoid spending many slides on benchmark minutiae or historical side notes.
- Pacing target: for a 75-minute lecture covering one major paper, aim for roughly 18-25 content slides (`===`). For two major papers in one lecture, aim for roughly balanced coverage (about 16-22 content slides per paper).
- Structure: each paper should be a top-level `=` section. Use `==` topics to mirror the paper’s major sections, and `===` slides for teachable units.
- Flow: start each paper with problem context and design goals; then architecture; then operation flows; then fault tolerance/consistency; then measurements and takeaways.
- Discussion prompts: if discussion questions are provided, integrate them into the main arc rather than treating them as a disconnected appendix.
- Diagrams: include frequent diagrams/tables/flows, especially for request paths, metadata ownership, and recovery sequences.
- Comparative framing: when teaching multiple papers, include explicit bridges between them (what changed, what stayed, why).
- Terminology: define paper-specific terms the first time they appear and reuse terms consistently.

### Typography and Unicode

- Prefer real Unicode symbols in normal prose where it improves readability (for example `→`, `↔`, `≤`).
- Keep ASCII-art diagrams in fenced raw/code blocks as ASCII to preserve alignment and visual style.
- Do not mix Unicode arrows into ASCII diagrams unless the diagram is redesigned to remain aligned.

## Build and Feedback Loop

- Fast loop while editing:
  - `typst watch assembly.typ`
  - `typst watch binary.typ`
  - `typst watch caching.typ`
- One-off compile:
  - `typst compile deck.typ`

## LLM Visual Debugging Workflow

When debugging layout or styling issues, render a single slide to PNG and give that image to an LLM.
This lets the model "see" the actual visual output instead of guessing from source.

- Export one slide (page numbers are 1-based):
  - `typst compile --format png --pages 7 assembly.typ slide-7.png`
- Export multiple slides for a targeted review:
  - `typst compile --format png --pages 7-9 assembly.typ slide-{p}.png`
- Increase raster quality when text/details are hard to read:
  - `typst compile --format png --ppi 200 --pages 7 assembly.typ slide-7.png`

Recommended loop:

1. Render the problematic slide(s) to PNG.
2. Ask the LLM for visual issues only (overflow, spacing, alignment, contrast, hierarchy).
3. Apply small, explicit Typst edits.
4. Re-render the same slide(s) and compare.
5. Repeat until the slide is stable, then continue authoring.

## Debugging Checklist

When output looks wrong, check in this order:

1. Heading depths: `=`, `==`, `===`, `====` are used exactly as intended.
2. Missing/extra delimiters: unmatched `]`, `)`, or `}`.
3. Multiline function-call commas, especially in `#grid` and `#table`.
4. Raw/code block fences are balanced.
5. `#show: slides.with(...)` exists and is not duplicated.
6. The deck imports `greenbar.typ` from the current directory.

## Repo Conventions for Slide Edits

- Preserve existing visual style and structure unless a change is requested.
- Keep examples technically accurate; do not add placeholders that look like final content.
- Prefer explicit Typst structures (`#grid`, `#table`, headings) over ad-hoc spacing hacks.
- Avoid adding custom macros in slide decks unless reused enough to justify them.
