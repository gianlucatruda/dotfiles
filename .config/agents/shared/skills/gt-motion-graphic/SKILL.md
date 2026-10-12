---
name: gt-motion-graphic
description: "Build animations and motion graphics: UI motion, 2D canvas scenes, 3D scenes, shaders, globes, animated data layers, celebration effects, interactive vector animation, math and diagram explainer videos, and video export. Use when the user asks to animate something, make a motion graphic, hero visual, animated scene, or explainer video, or to render an animation to a file. Do not use for static charts or static UI design with no motion."
metadata:
  source: https://x.com/damkina7/status/2109275362660130919
---

# Motion graphics

Select the smallest tool that produces the requested motion. Then build it, make it smooth, and export it if the user needs a file.

Read [references/tools.md](references/tools.md) before you write code. It gives the package, core pattern, and pitfalls for each tool.

## Select a tool

| Need | Tool |
| --- | --- |
| CSS-only fade, slide, or hover | No library. Use CSS transitions or keyframes. |
| UI motion, springs, gestures, layout transitions, scroll effects | Motion |
| 2D vector scene with objects to move, edit, or serialise | Fabric.js |
| 3D scene, camera moves, lights, particles, custom shaders | three.js |
| 3D scene inside React | three.js with React Three Fiber and drei |
| One full-screen fragment shader or small raw WebGL effect | twgl.js |
| Animated 3D globe for a hero section | cobe |
| Large geospatial or data-driven layers, animated trips or arcs | deck.gl |
| Confetti or celebration burst | canvas-confetti |
| Designer-made interactive vector animation with a state machine | Rive |
| Math, equation, graph, or diagram explainer video | Manim |
| Browser scene rendered to an MP4 file | Mediabunny |
| Transcode, trim, join, or add audio to existing video in the browser | ffmpeg.wasm |
| Any video post-processing with a shell available | Native `ffmpeg` |

Rules:

- Prefer one rendering tool per scene. Add a second tool only for a separate job, for example confetti on top of a Motion UI.
- Follow the project stack first. Use the React package variant in a React project.
- Do not add a 3D library for an effect that CSS or 2D canvas can do.
- Rive needs a `.riv` file made in the Rive editor. Do not choose it unless the user has one or will make one.
- Choose Manim when the deliverable is a video and the content is math, diagrams, or text. It renders frame-exact files with no browser.

## Supply chain

- Install with the project's package manager and lockfile. Pin exact versions.
- Do not add a dependency that a listed tool or the platform already covers.
- In a standalone HTML file, pin exact CDN versions. Add an `integrity` map to the import map.
- Do not let a library fetch code at runtime from a third-party CDN. Self-host its assets.

## Workflow

1. Identify the output: live web component, standalone HTML page, or video file.
2. Identify the constraints: framework, target size, duration, frame rate, and interactivity.
3. Select the tool with the table. State the choice and the reason in one line.
4. Read the API for the pinned version. Prefer the installed package README and types. These APIs change between major versions.
5. Build the motion. Drive all time-based change from one clock, such as the frame callback timestamp.
6. Make it smooth and safe. Apply the guardrails below.
7. If the user needs a video, export it. See the export section in the reference.

## Guardrails

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
