# Motion tools

Each entry gives the use, the package, a core pattern, and pitfalls. Patterns are sketches. Check them against the pinned version before you use one.

## Motion

- Repo: https://github.com/motiondivision/motion
- Package: `motion`. React: `motion/react`. Vanilla: `motion`.
- Vanilla `animate` from `motion` is the hybrid version. Use it for independent transforms such as `x` and `y`. `motion/mini` does not support them.
- Use for: UI springs, gestures, layout transitions, enter and exit, scroll-linked motion.
- Avoid for: canvas or WebGL scenes.

```js
import { animate, scroll } from "motion"
animate(".card", { opacity: [0, 1], y: [20, 0] }, { type: "spring", bounce: 0.2 })
scroll(animate(".bar", { scaleX: [0, 1] }))
```

```jsx
import { motion, AnimatePresence } from "motion/react"
<motion.div layout initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} />
```

Pitfalls:

- `AnimatePresence` needs a stable `key` on each child to run exit animations.
- Use `useReducedMotion` or `MotionConfig reducedMotion="user"` for accessibility.
- The old package name is `framer-motion`. Match the name the project already uses.

## Fabric.js

- Repo: https://github.com/fabricjs/fabric.js
- Package: `fabric`. Version 6 and later use named ES module exports.
- Use for: 2D vector scenes with an object model, editing, hit testing, and JSON serialisation.
- Avoid for: pure decorative particles. Use plain canvas or canvas-confetti.

```js
import { Canvas, Rect } from "fabric"
const canvas = new Canvas("c")
const box = new Rect({ left: 0, top: 50, width: 60, height: 60, fill: "#4f46e5" })
canvas.add(box)
box.animate({ left: 300 }, { duration: 800, onChange: () => canvas.requestRenderAll() })
const saved = canvas.toJSON()
```

Pitfalls:

- Call `requestRenderAll` during animation, or nothing redraws.
- Version 5 code uses a global `fabric` namespace. Do not mix it with version 6 imports.

## three.js

- Repo: https://github.com/mrdoob/three.js
- Package: `three`. Add-ons import from `three/addons/...`.
- Use for: 3D scenes, camera moves, lights, particles, post-processing, custom GLSL shaders.
- Avoid for: one flat shader with no scene graph. Use twgl.js.

```js
import * as THREE from "three"
const renderer = new THREE.WebGLRenderer({ antialias: true })
renderer.setPixelRatio(Math.min(devicePixelRatio, 2))
const scene = new THREE.Scene()
const camera = new THREE.PerspectiveCamera(50, innerWidth / innerHeight, 0.1, 100)
renderer.setAnimationLoop((ms) => {
  const t = ms / 1000
  camera.position.set(Math.cos(t) * 5, 2, Math.sin(t) * 5)
  camera.lookAt(0, 0, 0)
  renderer.render(scene, camera)
})
```

Pitfalls:

- Call `dispose()` on geometries, materials, textures, and the renderer on teardown.
- Update `camera.aspect`, call `updateProjectionMatrix()`, and resize the renderer on window resize.
- Set `renderer.outputColorSpace` and texture `colorSpace` correctly, or colours look washed out.
- Do not use `THREE.Clock`. It is deprecated since r183. Use the loop timestamp, or `THREE.Timer` for deltas.
- For a standalone HTML file, map `three` and `three/addons/` in an import map.

## drei

- Repo: https://github.com/pmndrs/drei
- Package: `@react-three/drei`. Needs `@react-three/fiber` and `three`.
- Use for: three.js in React. Gives controls, environment maps, staging, text, and helpers.
- Avoid for: non-React projects.

```jsx
import { Canvas } from "@react-three/fiber"
import { OrbitControls, Environment, Float } from "@react-three/drei"
<Canvas dpr={[1, 2]} camera={{ position: [0, 1, 5] }}>
  <Float speed={2}><mesh><torusKnotGeometry /><meshStandardMaterial /></mesh></Float>
  <Environment preset="city" />
  <OrbitControls enableDamping />
</Canvas>
```

Pitfalls:

- Animate with `useFrame((state, delta) => ...)`. Do not use React state per frame.
- Match `@react-three/fiber` major version to the React major version.

## twgl.js

- Repo: https://github.com/greggman/twgl.js
- Package: `twgl.js`.
- Use for: full-screen fragment shaders, small raw WebGL effects, shader backgrounds.
- Avoid for: scenes with many objects, cameras, or loaders. Use three.js.

```js
import * as twgl from "twgl.js"
const gl = canvas.getContext("webgl2")
const programInfo = twgl.createProgramInfo(gl, [vertexSrc, fragmentSrc])
const bufferInfo = twgl.createBufferInfoFromArrays(gl, {
  position: [-1, -1, 0, 1, -1, 0, -1, 1, 0, -1, 1, 0, 1, -1, 0, 1, 1, 0],
})
function render(ms) {
  twgl.resizeCanvasToDisplaySize(gl.canvas, Math.min(devicePixelRatio, 2))
  gl.viewport(0, 0, gl.canvas.width, gl.canvas.height)
  gl.useProgram(programInfo.program)
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo)
  twgl.setUniforms(programInfo, { u_time: ms / 1000, u_resolution: [gl.canvas.width, gl.canvas.height] })
  twgl.drawBufferInfo(gl, bufferInfo)
  requestAnimationFrame(render)
}
requestAnimationFrame(render)
```

Pitfalls:

- Write GLSL ES 3.00 shaders. Start them with `#version 300 es`.
- Keep fragment shader cost low. It runs once per pixel per frame.

## cobe

- Repo: https://github.com/shuding/cobe
- Package: `cobe`.
- Use for: a small animated dot-matrix globe, usually in a hero section.
- Avoid for: real map data, labels, or interaction beyond rotation. Use deck.gl.

```js
import createGlobe from "cobe"
const globe = createGlobe(canvas, {
  devicePixelRatio: 2, width: 1200, height: 1200, phi: 0, theta: 0.3,
  dark: 1, diffuse: 1.2, mapSamples: 16000, mapBrightness: 6,
  baseColor: [0.3, 0.3, 0.3], markerColor: [0.1, 0.8, 1], glowColor: [1, 1, 1],
  markers: [{ location: [51.5, -0.12], size: 0.05 }],
  onRender: (state) => { state.phi = performance.now() / 4000 },
})
```

Pitfalls:

- Call `globe.destroy()` on teardown.
- `width` and `height` set the drawing buffer size. Set the display size with CSS.

## deck.gl

- Repo: https://github.com/visgl/deck.gl
- Package: `deck.gl`, or scoped `@deck.gl/core`, `@deck.gl/layers`, `@deck.gl/geo-layers`.
- Use for: animated layers over large datasets, such as trips, arcs, points, and hexagons.
- Avoid for: small charts. Use a chart library.

```js
import { Deck } from "@deck.gl/core"
import { TripsLayer } from "@deck.gl/geo-layers"
const deck = new Deck({ initialViewState, controller: true })
function frame(ms) {
  deck.setProps({ layers: [new TripsLayer({
    id: "trips", data: trips, getPath: (d) => d.path, getTimestamps: (d) => d.timestamps,
    currentTime: (ms / 20) % loopLength, trailLength: 200, widthMinPixels: 2,
  })] })
  requestAnimationFrame(frame)
}
requestAnimationFrame(frame)
```

Pitfalls:

- Keep layer `id` stable so deck.gl reuses GPU buffers.
- Use the `transitions` layer prop for smooth changes between data states.
- Set `updateTriggers` when an accessor depends on external state.

## canvas-confetti

- Repo: https://github.com/catdad/canvas-confetti
- Package: `canvas-confetti`.
- Use for: a short celebration burst on success.
- Avoid for: ambient or looping particle backgrounds.

```js
import confetti from "canvas-confetti"
confetti({ particleCount: 120, spread: 70, origin: { y: 0.6 }, disableForReducedMotion: true })
```

Pitfalls:

- Use `confetti.create(canvas, { resize: true })` to draw into a specific canvas.
- Keep bursts short and rare. Repeated confetti loses meaning.

## Rive

- Repo: https://github.com/rive-app/rive-runtime. This is the C++ core. Web runtimes come from `rive-app/rive-wasm`.
- Package: `@rive-app/webgl2`. React: `@rive-app/react-webgl2`. Rive recommends it because it uses the same renderer as the Rive editor. The `canvas` package does not draw every editor feature, for example vector feathering.
- Use for: interactive vector animation made in the Rive editor, driven by a state machine.
- Avoid for: motion that code must generate. Rive plays authored `.riv` files.

```js
import { Rive } from "@rive-app/webgl2"
const r = new Rive({
  src: "/hero.riv", canvas, autoplay: true, stateMachines: "State Machine 1",
  onLoad: () => r.resizeDrawingSurfaceToCanvas(),
})
const hover = r.stateMachineInputs("State Machine 1").find((i) => i.name === "hover")
```

Pitfalls:

- Read the state machine and input names from the `.riv` file. Do not guess them.
- Call `r.cleanup()` on teardown.

## ffmpeg.wasm

- Repo: https://github.com/ffmpegwasm/ffmpeg.wasm
- Package: `@ffmpeg/ffmpeg` and `@ffmpeg/util`.
- Use for: browser-side transcode, trim, join, frame extraction, and audio muxing of existing files.
- Avoid for: encoding canvas frames. Use Mediabunny. Avoid for local work. Use native `ffmpeg`. It is much faster.

```js
import { FFmpeg } from "@ffmpeg/ffmpeg"
import { fetchFile, toBlobURL } from "@ffmpeg/util"
const ffmpeg = new FFmpeg()
// Self-hosted copy of the pinned @ffmpeg/core dist files.
await ffmpeg.load({
  coreURL: await toBlobURL("/vendor/ffmpeg-core.js", "text/javascript"),
  wasmURL: await toBlobURL("/vendor/ffmpeg-core.wasm", "application/wasm"),
})
await ffmpeg.writeFile("in.webm", await fetchFile(webmBlob))
await ffmpeg.exec(["-i", "in.webm", "-c:v", "libx264", "-pix_fmt", "yuv420p", "out.mp4"])
const mp4 = new Blob([await ffmpeg.readFile("out.mp4")], { type: "video/mp4" })
```

Pitfalls:

- `load()` with no options fetches the core from a third-party CDN at runtime. Always pass self-hosted URLs.
- The multi-thread core needs `SharedArrayBuffer`. That needs COOP and COEP headers. The single-thread core does not.
- The core is large. Load it only when the user starts an export.

## Manim

- Repo: https://github.com/ManimCommunity/manim
- Package: `manim`, the community edition. Needs Cairo and pkg-config. LaTeX is optional, for `MathTex`.
- Use for: math, equation, graph, and diagram explainer videos. Output is frame-exact.
- Avoid for: interactive or live web motion. Manim renders files only.
- Do not use ManimGL, the 3Blue1Brown fork. It has a different API and less documentation.

```python
from manim import *

class Intro(Scene):
    def construct(self):
        circle = Circle(color=BLUE)
        self.play(Create(circle))
        self.play(circle.animate.shift(RIGHT * 2), run_time=1.5)
```

```bash
uv add manim
uv run manim -qh scene.py Intro
uv run manim -ql --format gif scene.py Intro
```

Pitfalls:

- Render with `-ql` while you iterate. Render with `-qh` or `-qk` for the final file.
- Example code for ManimGL does not run on Manim Community. Check imports before you copy.
- Run `uv run manim checkhealth` when a render fails on a new machine.

## Mediabunny

- Repo: https://github.com/Vanilagy/mediabunny
- Package: `mediabunny`.
- Use for: encoding a canvas animation to MP4 or WebM in the browser with WebCodecs.
- Avoid for: live playback. It only writes files.

```js
import { Output, Mp4OutputFormat, BufferTarget, CanvasSource, Quality } from "mediabunny"
const output = new Output({ format: new Mp4OutputFormat(), target: new BufferTarget() })
const source = new CanvasSource(canvas, { codec: "avc", quality: new Quality("high") })
output.addVideoTrack(source)
await output.start()
const fps = 60
for (let frame = 0; frame < durationSeconds * fps; frame++) {
  drawScene(frame / fps)
  await source.add(frame / fps, 1 / fps)
}
await output.finalize()
const mp4 = new Blob([output.target.buffer], { type: "video/mp4" })
```

Pitfalls:

- The scene must accept a time argument. Render each frame from that time, not from the wall clock.
- Codec support differs by browser. Check support before you choose a codec.

## Export to video

Use this path when the user needs a file, not a live page.

1. Math, diagram, or text explainer: render with Manim.
2. Browser canvas scene: step the scene time by `1 / fps` and encode each frame with Mediabunny.
3. Do not use `MediaRecorder` for final output. It records wall-clock time, drops frames under load, and its formats differ by browser.
4. Post-process with native `ffmpeg` when a shell is available.
5. For a GIF, make a palette first: `-vf "fps=30,scale=800:-1:flags=lanczos,split[a][b];[a]palettegen[p];[b][p]paletteuse"`.
