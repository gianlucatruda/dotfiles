# Animation principles

Compressed from John Lasseter, "Principles of Traditional Animation Applied to 3D Computer Animation", SIGGRAPH 1987. Lasseter adapted the Disney principles of Thomas and Johnston to computer animation.

Core idea: motion must read clearly and show intent. Design the motion before you tune the code.

| Principle | Meaning | Apply in code |
| --- | --- | --- |
| Squash and stretch | Shape shows mass and speed. Keep volume constant. | Scale along motion and shrink across it. Use it on impact. Keep it subtle in UI. |
| Timing | Frame count gives weight, mood, and meaning. | Small or light: 100 to 200 ms. Large or heavy: 300 to 500 ms. Keep choreography under about 1 s. |
| Anticipation | A small opposite move prepares the main action. | Pull back before a launch. Dip before a rise. Use a back-out ease or a short counter move. |
| Staging | Show one idea at a time, clearly. | Animate one focus at a time. Keep the silhouette readable. Dim or hold the rest. |
| Straight ahead and pose to pose | Simulate frame by frame, or plan key poses and fill between. | Use physics or particles for straight ahead. Use keyframes and tweens for pose to pose. |
| Follow through and overlapping action | Parts do not all stop or start together. | Stagger children by 20 to 60 ms. Let loose parts settle after the main body stops. Use springs. |
| Slow in and slow out | Speed changes at the start and end of a move. | Use ease-out to enter and ease-in to exit. Use linear only for constant loops and progress. |
| Arcs | Natural paths curve. | Move along curves or combine x and y with different easings. Avoid straight diagonals for organic motion. |
| Exaggeration | Push the essence of an action so it reads. | Overshoot slightly with a spring bounce. Exaggerate the key idea, not every detail. |
| Secondary action | A smaller action supports the main one. | Add a shadow, glow, or ripple that follows the main move. It must not compete with it. |
| Appeal | The result is pleasant and easy to watch. | Use a consistent motion language. Same easings, durations, and directions across the whole piece. |

Lasseter also stresses that each motion needs a reason. Show the thought before the action, and let the viewer see one idea at a time.

Checks before you finish:

- Can a viewer say what changed and why, after one watch?
- Does every moving element have a purpose?
- Do related elements share easing and timing?
- Does the motion still read with `prefers-reduced-motion` set?
