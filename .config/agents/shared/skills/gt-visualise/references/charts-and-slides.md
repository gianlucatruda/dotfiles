# Chart and slide tools

Each entry gives the use, the package, a core pattern, and pitfalls. Patterns are sketches. Check them against the pinned version before you use one.

## Recharts

- Site: https://recharts.github.io. Repo: https://github.com/recharts/recharts
- Package: `recharts` and `react-is`. It renders SVG with D3 submodules.
- Use for: standard charts in React. Line, area, bar, scatter, pie, radar, treemap, and composed charts.
- Avoid for: non-React projects, more than about 10,000 points, or novel chart forms. Use D3, deck.gl, or canvas.

```jsx
import { CartesianGrid, Line, LineChart, Tooltip, XAxis, YAxis } from "recharts"

// Pass animate={false} for reduced motion, screenshots, and exports.
export function Revenue({ data, animate = true }) {
  return (
    <LineChart data={data} responsive width="100%" height={300}>
      <CartesianGrid strokeDasharray="3 3" vertical={false} />
      <XAxis dataKey="month" />
      <YAxis width="auto" />
      <Tooltip />
      <Line type="monotone" dataKey="revenue" dot={false} isAnimationActive={animate} />
    </LineChart>
  )
}
```

Pitfalls:

- Match the `react-is` version to the installed `react` version.
- A chart with no size renders nothing. From 3.3, use the `responsive` prop with `width` and `height`. Before 3.3, wrap it in `ResponsiveContainer` inside a parent with a set height.
- In Next.js App Router, charts are client components. Add `"use client"`.
- Set `isAnimationActive={false}` for screenshots, exports, tests, and reduced motion.
- Version 3 rewrote the internals. Do not copy version 2 examples that read chart internals or pass `activeIndex`.

## Bento Slides

- Site: https://bento.page/slides. Repo: https://github.com/nyblnet/bento
- Agent guide: https://bento.page/agents.md. Schema: https://bento.page/schema/slides.json
- Format: one self-contained `*.bento.html` file. It is the document, viewer, and editor.
- Use for: a presentation with morph transitions, charts, tables, count-ups, and ambient motion, shared as one file.
- Avoid for: a `.pptx` deliverable, or slides that must live in a Git-friendly text format.

```bash
curl -fsSL https://bento.page/releases/slides/Bento_Slides.bento.html -o "Topic.bento.html"
```

```json
// Inside <script type="application/bento+json" id="bento-doc">. Same id + "morph" = glide.
{ "id": "s1", "transition": "none", "elements": [
  { "id": "headline", "type": "text", "x": 96, "y": 140, "w": 900, "h": 200,
    "html": "Big claim.", "fontSize": 120, "fontWeight": 900 } ] }
{ "id": "s2", "transition": "morph", "elements": [
  { "id": "headline", "type": "text", "x": 96, "y": 84, "w": 500, "h": 80,
    "html": "Big claim.", "fontSize": 40, "fontWeight": 900 } ] }
```

Pitfalls:

- Read the agent guide before you write a deck. If the `bento-slides` skill is installed, use it.
- Edit only the `#bento-doc` JSON block. Do not touch the compressed runtime blocks.
- Escape every `<` in the JSON as `<`.
- A `collab` key with `ownerPriv`, `writerPriv`, or `invite` holds live room keys. Tell the user before you read the deck further.
- The release URL always serves the latest app. Note the guide version in the file when you start.
- Map content to features. Numbers become charts. Grids become tables. Same subject across slides becomes morph.
- The canvas is 1280 by 720. Chart `bar` and `line` data are plain numbers.
