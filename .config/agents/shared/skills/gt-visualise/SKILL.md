---
name: gt-visualise
description: "Build visualisations of any fidelity: ASCII and Unicode diagrams, Mermaid, Excalidraw sketches, charts, slide decks, UI motion, 2D canvas scenes, 3D scenes, shaders, globes, geospatial layers, celebration effects, Rive animation, math explainer videos, Blender renders, and video export. Use when the user asks to draw, diagram, chart, visualise, animate, render, or present something, or to make a motion graphic, hero visual, deck, or explainer video. Do not use for UI layout or styling with no visualisation."
metadata:
  source: https://x.com/damkina7/status/2109275362660130919
---

# Visualise

Select the simplest medium and tool that shows the idea clearly. Then build it, check it, and export it if the user needs a file.

## Select a tool

Read the reference for the chosen tool before you write code. It gives the package, core pattern, and pitfalls.

| Need | Tool | Reference |
| --- | --- | --- |
| Diagram in a terminal reply, code comment, or plain text | ASCII or Unicode text | [diagrams.md](references/diagrams.md) |
| Flowchart, sequence, state, or ER diagram in Markdown | Mermaid | [diagrams.md](references/diagrams.md) |
| Editable hand-drawn sketch or whiteboard diagram | Excalidraw | [diagrams.md](references/diagrams.md) |
| Small static figure with exact layout | Hand-written inline SVG | None |
| Standard chart in React | Recharts | [charts-and-slides.md](references/charts-and-slides.md) |
| Chart outside React | The project's chart library, else inline SVG | None |
| Slide deck with morph, charts, and motion in one file | Bento Slides | [charts-and-slides.md](references/charts-and-slides.md) |
| CSS-only fade, slide, or hover | No library. Use CSS transitions or keyframes. | None |
| UI motion, springs, gestures, layout transitions, scroll effects | Motion | [motion.md](references/motion.md) |
| 2D vector scene with objects to move, edit, or serialise | Fabric.js | [motion.md](references/motion.md) |
| Large geospatial or data-driven layers, animated trips or arcs | deck.gl | [motion.md](references/motion.md) |
| Confetti or celebration burst | canvas-confetti | [motion.md](references/motion.md) |
| Designer-made interactive vector animation with a state machine | Rive | [motion.md](references/motion.md) |
| Math, equation, graph, or diagram explainer video | Manim | [motion.md](references/motion.md) |
| 3D scene, camera moves, lights, particles, custom shaders | three.js | [3d.md](references/3d.md) |
| 3D scene inside React | three.js with React Three Fiber and drei | [3d.md](references/3d.md) |
| One full-screen fragment shader or small raw WebGL effect | twgl.js | [3d.md](references/3d.md) |
| Animated 3D globe for a hero section | cobe | [3d.md](references/3d.md) |
| Offline 3D render, physics, or a model to export to glTF | Blender | [3d.md](references/3d.md) |
| Browser scene rendered to an MP4 file | Mediabunny | [motion.md](references/motion.md) |
| Transcode, trim, join, or add audio to existing video in the browser | ffmpeg.wasm | [motion.md](references/motion.md) |
| Any video post-processing with a shell available | Native `ffmpeg` | [motion.md](references/motion.md) |

Rules:

- Match fidelity to the destination. Use text in a terminal, Mermaid in Markdown, and richer tools only when the output can show them.
- Prefer one rendering tool per visual. Add a second tool only for a separate job, for example confetti on top of a Motion UI.
- Follow the project stack first. Use the React package variant in a React project.
- Do not add a 3D library for an effect that CSS or 2D canvas can do.
- Rive needs a `.riv` file made in the Rive editor. Do not choose it unless the user has one or will make one.
- Choose Manim when the deliverable is a video and the content is math, diagrams, or text. It renders frame-exact files with no browser.
- Choose Blender over three.js when the output is a file and quality matters more than interaction.

## Supply chain

- Install with the project's package manager and lockfile. Pin exact versions.
- Do not add a dependency that a listed tool or the platform already covers.
- In a standalone HTML file, pin exact CDN versions. Add an `integrity` map to the import map.
- Do not let a library fetch code at runtime from a third-party CDN. Self-host its assets.

## Workflow

1. Identify the output: text block, Markdown, editable file, live web component, standalone HTML page, image, deck, or video.
2. Identify the constraints: framework, viewer, size, duration, frame rate, and interactivity.
3. Select the tool with the table. State the choice and the reason in one line.
4. Read the API for the pinned version. Prefer the installed package README and types. These APIs change between major versions.
5. Build the visual. For motion, read [animation-principles.md](references/animation-principles.md) first. Drive all time-based change from one clock, such as the frame callback timestamp.
6. Check it. Render or open the result and look at it. Apply the guardrails below.
7. If the user needs a file, export it. See the export section in [motion.md](references/motion.md).

## Guardrails

All visuals:

- Show one main idea. Remove marks, colours, and labels that do not support it.
- Label axes, units, and nodes directly. Prefer direct labels to legends.
- Do not encode meaning with colour alone. Check contrast in light and dark themes.
- Keep text readable at the target size.

Motion:

- Respect `prefers-reduced-motion`. Reduce or stop non-essential motion when it is set.
- Animate `transform` and `opacity` for DOM motion. Do not animate layout properties per frame.
- Scale canvas size by `devicePixelRatio`, but cap it at 2 to protect frame rate.
- Stop render loops when the element is off screen. Use `IntersectionObserver`. Browsers already pause `requestAnimationFrame` in hidden tabs.
- Dispose GPU resources, listeners, and loops on unmount.
- Derive motion from elapsed time, not frame counts, so speed is the same at 60 Hz and 120 Hz.
- Keep easing purposeful. Use springs for interaction and eased curves for choreography.
- Do not ship large assets without need. Compress textures, models, and video.

## Report

Tell the user the tool you chose and why. Give the file paths and how to open or run the result. State known limits, such as browser support, system dependencies, or COOP and COEP headers.
