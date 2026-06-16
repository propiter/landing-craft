# Animation Levels — configurable depth (load before the motion phase)

A landing that just fades the hero in is flat. A landing that moves on every pixel is exhausting.
The answer is a **dial**: three intensity levels the user picks (default **medium**), each a coherent
system — not random effects. Every level is 60fps (`transform`/`opacity` only) and degrades under
`prefers-reduced-motion`. Pair this with the `motion-craft` skill for the craft rules (easing,
duration, restraint).

## The stack (Next.js + Tailwind — researched, current)

| Tool | Role | When |
|------|------|------|
| **Motion** (`motion`, ex–Framer Motion) | Declarative React enter/exit, layout, gestures, `useScroll` | Default for React/Next — every level |
| **GSAP** (free, all plugins) + ScrollTrigger | Scroll-scrub, pinning, timelines, SVG | medium (light) → rich |
| **Lenis** (`lenis`) | Buttery smooth-scroll momentum (doesn't break sticky) | medium → rich (the "premium feel") |
| **Aceternity UI** / **Magic UI** (copy-paste, Tailwind + Motion) | Pro effects: 3D cards, magnetic buttons, spotlight, animated beams, aurora/grid backgrounds | rich (pick 1–2, don't dump) |
| `tailwindcss-motion` | 5KB CSS utilities for simple reveals | subtle, or as fallback |

Install only what the chosen level needs (per-project deps, never global). The **tokens stay in
`tailwind.config`** — animations reference Tailwind theme values, never hardcoded hex/px.

## Level 0 — `subtle` (menos)
Quiet and fast. For tools, dashboards, conservative B2B, or accessibility-first.
- Hero: one staggered reveal (headline → sub → CTA), `ease-out-expo`, 40–60ms step.
- Scroll: fade + small `translateY` on section enter, once (Motion `whileInView`, `once:true`).
- Interactive: button `:active` scale(0.97), hover color/underline. Visible focus rings.
- **No** smooth-scroll, no parallax, no scroll-scrub. Reduced-motion ≈ already minimal.

## Level 1 — `medium` (DEFAULT) ← start here
Premium and alive without shouting. The everyday "this feels designed".
- Everything in `subtle`, **plus**:
- **Lenis smooth scroll** (the single biggest "premium" upgrade for the cost).
- **Card hover depth** — lift (`translateY(-4px)`), border/glow shift, subtle `scale(1.01)`, content
  reveal (an arrow slides in, a stat counts up). This is the "cards que al pasar el mouse animan".
- **Section reveals with movement** + light stagger across grids (60–80ms).
- **Number counters** on metrics (count up on scroll-in), animated underlines on nav/links.
- **CTA emphasis** — a soft animated gradient border or glow pulse on the ONE primary CTA.
- Optional one **GSAP scroll-scrub** moment (e.g. the hero product panel parallax).

## Level 2 — `rich` (más / muchas animaciones)
The spectacle tier — for marketing/launch pages that must stop the scroll.
- Everything in `medium`, **plus** (pick 2–4, curated — not all at once):
- **Magnetic buttons** & **3D tilt cards** (Aceternity), **spotlight / animated beams / aurora or
  retro-grid backgrounds** (Magic UI) — copy-paste, already Tailwind+Motion.
- **GSAP scroll-scrubbed sequences**: pinned sections, horizontal scroll, step-through reveals,
  SVG draw-on (the network-nodes motif animating node-by-node).
- **Parallax layers**, depth on the hero, image clip-path reveals on scroll.
- Optional Lottie/Rive for one hero illustration; particles only if on-brand.
- Still 60fps, still one signal per viewport — richness ≠ chaos. Curate, don't carpet-bomb.

## The intensity is REMEMBERED
Read the user's saved preference at intake (engram `landing-craft/style-profile`,
`animation_intensity`). Use it as the default — don't re-ask every time. If the user says "más/menos
animaciones" or "siempre con muchas", **update the profile** so it sticks across future landings.

## reduced-motion at EVERY level (non-negotiable)
`@media (prefers-reduced-motion: reduce)` (or Motion's `useReducedMotion()`): keep opacity/colour
fades that aid comprehension; drop movement, parallax, scroll-scrub, magnetic/tilt, counters→snap to
final. A rich landing must still be calm for users who asked for less motion.

## Anti-slop guardrails (carry over from motion-craft)
- Move only `transform`/`opacity`. Custom easing, not weak defaults. Interactive < 300ms.
- One orchestrated signal per viewport. Don't animate high-frequency actions. Never scroll-jack
  (Lenis ≠ scroll-jacking; it smooths, it doesn't hijack speed/direction).
- Run `motion-craft`'s scanner before sign-off; respect the contrast gate after motion is added
  (hover/focus states must still clear AA).
