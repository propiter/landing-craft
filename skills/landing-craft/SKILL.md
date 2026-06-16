---
name: landing-craft
description: "Trigger: build/create/make a landing page, marketing site, product page, hero section, sales page, waitlist, 'armame una landing', 'landing que venda', 'una web que no parezca hecha con IA'. An end-to-end, phased workflow that orchestrates specialist sub-agents — strategy, copy, visual design, build, motion, polish, SEO, review — to ship a modern, elegant, intuitive, high-converting landing that does NOT look AI-generated. Next.js by default; framework-agnostic."
license: Apache-2.0
metadata:
  author: propiter
  version: "1.0.0"
---

# Landing Craft

A landing page is not a template you fill in. It's an argument that earns a click. This skill is
the **orchestrator**: when someone asks for a landing, you don't write it all yourself — you run
a phased pipeline and delegate each phase to a specialist sub-agent, exactly like SDD does for
features. Your job is to hold one thin thread, launch the right agent at the right time, pass
artifacts between them, and guard the quality bar.

## The Prime Directive

Every landing this workflow ships must clear four bars. If any fails, it is not done:

1. **It does NOT look AI-generated.** No centered-everything, no untouched component library, no
   purple gradient, no generic hero→3-cards→CTA with lorem spacing. Distinct, intentional, modern.
2. **It sells.** A stranger understands *what it is, who it's for, why it's better, and what to do
   next* within 5 seconds of the hero.
3. **It's intuitive.** One obvious primary action per screen. Nothing makes the user think about
   the interface instead of the offer.
4. **It's crafted.** 60fps motion with restraint, real type/spacing/contrast, accessible, fast.

## The Pipeline (the DAG)

```
                ┌────────────► copy ──────┐
  brief ► strategy                         ├─► build ─► motion ─► polish ─┐
                └────────────► design ─────┘                 build ─► seo ─┴─► review ⭯
```

- **Planning** (cheap, fast, do first): `strategy → {copy, design}`
- **Production** (the build): `build → motion → polish`, with `seo` in parallel off `build`
- **Gate**: `review` renders and critiques; it LOOPS back to polish/build until it passes.

## Phase → Sub-agent map

Delegate each phase to its agent via the Task/Agent mechanism. Each agent loads the deep skill it
needs (we already own them) and returns a structured artifact. Pass the prior artifacts forward.

| Phase | Sub-agent | Loads / leans on | Produces |
|-------|-----------|------------------|----------|
| 1. Strategy | `landing-strategy` | `marketing-strategy` | positioning, ICP/JTBD, core promise, offer, proof inventory |
| 2. Copy | `landing-copy` | `brand-voice` | section-by-section message + conversion copy (anti-slop) |
| 3. Design | `landing-design` | Impeccable, `web-assets` | visual direction (DESIGN.md): type/colour/space scale, component style, references |
| 4. Build | `landing-build` | the target framework | the actual landing code (Next.js default) |
| 5. Motion | `landing-motion` | `motion-craft` | reveals, micro-interactions, one hero moment — all reduced-motion safe |
| 6. Polish | `landing-polish` | Impeccable, a11y | aesthetic pass, responsive, contrast, focus states |
| 7. SEO | `landing-seo` | `seo-geo` | meta/OG/schema/perf, Core Web Vitals, llms.txt |
| 8. Review | `landing-review` | `design-review-loop` | render at 390/768/1440 + conversion heuristics → pass/fail + fixes |

## How to run it

Detect the mode from the request; if unclear, ask once.

- **`/landing-new <brief>`** → run Planning only (strategy → copy + design), then STOP and show the
  plan + visual direction for approval before building.
- **`/landing-build`** → run Production (build → motion → polish, + seo) on the approved plan.
- **`/landing-review`** → run the review loop and apply fixes (max 3 passes).
- **`/landing-ship <brief>`** → full auto: every phase end-to-end, stopping only if a gate fails.

**Interactive vs Auto:** default to Interactive — pause after each phase, show the artifact, ask
"¿seguimos o ajustamos?". Switch to Auto only when the user asks for speed.

## The brief — what you need before phase 1

Never start from nothing. Collect (ask the user, or infer + confirm): **product** (what it does),
**audience** (who buys), **the one action** you want them to take, **tone/brand** (or "infer it"),
**framework** (default Next.js + Tailwind), and any **proof** (logos, numbers, testimonials). If
the user can't answer the strategy questions, that's fine — `landing-strategy` will draft them and
you confirm. The user said they don't know marketing; that means YOU run strategy, not skip it.

## Artifacts & continuity

Write each phase's output to `landing/` in the project (`strategy.md`, `copy.md`, `design.md`,
`review.md`) so phases compose and the work survives a restart. If engram is available, also save
under topic keys `landing/<name>/<phase>`. Later phases READ the earlier artifacts — pass paths,
not full content, to keep the thread thin.

## Anti-slop guardrails (enforced at every phase)

- **No section without a job.** Every block earns its place (attention, desire, proof, objection,
  action). If you can't name its job, cut it.
- **One primary CTA**, repeated; everything else is secondary/ghost.
- **Specifics over adjectives.** "Factura ante la DIAN en 60s" beats "la mejor solución innovadora".
- **Real visual decisions** — a deliberate type scale, a real colour system, generous spacing,
  asymmetry where it helps. Never the framework defaults untouched.
- **Motion with restraint** — one orchestrated hero reveal beats ten micro-animations; always
  `prefers-reduced-motion`.
- **Accessible & fast** — AA contrast, focus states, semantic HTML, Core Web Vitals green.

See `references/playbook.md` for the conversion architecture (section sequence, hero formula,
proof patterns, CTA rules) — load it before phase 2.

## Output Contract

When the workflow finishes, report: the live preview URL (dev server), the phases run, the
positioning one-liner, the primary CTA, the review verdict (what passed / what was fixed), and the
remaining follow-ups. Never declare "done" until `landing-review` returns a pass.
