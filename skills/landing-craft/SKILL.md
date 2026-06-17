---
name: landing-craft
description: "Trigger: build/create/make a landing page, marketing site, product page, hero section, sales page, waitlist, 'armame una landing', 'landing que venda', 'una web que no parezca hecha con IA'. An end-to-end, phased workflow that LEADS with an autonomous MARKET STUDY (scrapes the product + competitors, mines keywords/intent, profiles the audience — no interrogation), then runs research → strategy → multi-page architecture → copy → visual design → build → motion (configurable depth — subtle/medium/rich, scroll-reactive via Motion+GSAP+Lenis) → polish → SEO → review, and DEPLOYS the result (GitHub + Vercel) — shipping a modern, elegant, intuitive, high-converting landing that does NOT look AI-generated, ready to view live. Next.js + Tailwind by default (no hardcoded tokens); remembers your style preferences."
license: Apache-2.0
metadata:
  author: propiter
  version: "1.6.1"
---

# Landing Craft

A landing page is not a template you fill in. It's an argument that earns a click. This skill is
the **orchestrator**: when someone asks for a landing, you don't write it all yourself — you run
a phased pipeline and delegate each phase to a specialist sub-agent, exactly like SDD does for
features. Your job is to hold one thin thread, launch the right agent at the right time, pass
artifacts between them, and guard the quality bar.

## The Prime Directive

Every landing this workflow ships must clear FIVE bars. If any fails, it is not done:

1. **It does NOT look AI-generated.** No centered-everything, no untouched component library, no
   purple gradient, no generic hero→3-cards→CTA with lorem spacing. Distinct, intentional, modern.
2. **It sells.** A stranger understands *what it is, who it's for, why it's better, and what to do
   next* within 5 seconds of the hero.
3. **It's intuitive.** One obvious primary action per screen. Nothing makes the user think about
   the interface instead of the offer.
4. **It's crafted.** 60fps motion with restraint, real type/spacing/contrast, accessible, fast.
5. **It's ALIVE — it has a vibe.** Real imagery (NOT a generic UI mock on a dark gradient), a
   signature visual idea that's THIS brand, colour with warmth/contrast (not one cold hue), and
   **scroll-reactive motion** — things enter and move as you scroll. "Pretty but generic/dead"
   fails this bar. Run the vibe test in `references/alive-not-generic.md` before sign-off.

## Zero technical debt (always-on, every phase)

Every agent operates under a no-debt rule: **the moment you spot a bug, a flaw, a smell, a broken
edge case, a dead link, duplicated code, or a clear improvement — fix it on the spot and CONTINUE.**
Don't leave a TODO, don't defer it, don't stop to ask. This covers the generated site (a11y/contrast
misses, broken responsive, missing states, hardcoded values, repetition) AND the workflow's own
artifacts. Later phases RE-CHECK earlier work and repair anything that slipped; `review` is the
backstop. When the orchestrator delegates, it tells each sub-agent: *honor zero-debt — fix what you
find and keep going.* The product ships complete — **no known debt, nothing "to fix later".**

## The Pipeline (the DAG)

```
  research ─► strategy ─► architecture ─┬─► copy ───┐
  (market study)                        └─► design ─┴─► build (multi-page) ─► motion ─► polish ─┐
                                                            build ─► seo ──────────────────────┴─► review ⭯ ─► deploy
```

- **Research** (Phase 0): an AUTONOMOUS market study — scrape the product + competitors, mine
  keywords/intent, profile the audience's emotional drivers, collect alive design references,
  validate positioning. **The skill LEADS; it does NOT interrogate the user.** (`landing-research`)
- **Architecture** (after strategy): the page map (multi-page) + the UNIQUE per-theme section plan.
- **Planning**: `strategy → {copy, design}`, all grounded in the research.
- **Production**: `build` (multi-page) → `motion` → `polish`, with `seo` (researched keywords) off `build`.
- **Gate**: `review` renders and critiques (5 bars incl. ALIVE); LOOPS back until it passes.
- **Deploy** (final): GitHub + Vercel — a live URL. Research, SEO and deploy are NOT optional.

## Phase → Sub-agent map

Delegate each phase to its agent via the Task/Agent mechanism. Each agent loads the deep skill it
needs (we already own them) and returns a structured artifact. Pass the prior artifacts forward.

| Phase | Sub-agent | Loads / leans on | Produces |
|-------|-----------|------------------|----------|
| 0. Research | `landing-research` | `marketing-strategy`, `seo-geo`, Firecrawl, WebSearch | `research.md` — product/competitor teardown, keywords/intent, emotional drivers, alive design refs, the GAP |
| 1. Strategy | `landing-strategy` | `marketing-strategy` | positioning, ICP/JTBD, core promise, offer (grounded in research) |
| 2. Architecture | `landing-architecture` | `site-architecture` | the page map (multi-page) + the UNIQUE per-theme section plan |
| 3. Copy | `landing-copy` | `brand-voice` | section + page copy, research-backed, human (anti-slop) |
| 4. Design | `landing-design` | `alive-not-generic`, Impeccable, `web-assets` | DESIGN.md: signature visual, real imagery, type/colour/space — NOT generic |
| 5. Build | `landing-build` | Next.js + Tailwind | the multi-page site (tokens in tailwind.config, no hardcoded) |
| 6. Motion | `landing-motion` | `motion-craft`, `animation-levels` | scroll-reactive motion at the chosen intensity, reduced-motion safe |
| 7. Polish | `landing-polish` | Impeccable, `contrast-check` | craft pass, responsive, AA contrast (measured), focus states |
| 8. SEO | `landing-seo` | `seo-geo` | meta/OG/JSON-LD/CWV/llms.txt per page, targeting the researched keywords |
| 9. Review | `landing-review` | `design-review-loop`, `contrast-check`, `alive-not-generic` | render + score the 5 bars + contrast gate → pass/fail |
| 10. Deploy | `landing-deploy` | `gh`, Vercel CLI | repo pushed + a live URL; installs the CLI if missing & guides first-time auth |

## How to run it

Detect the mode from the request; if unclear, ask once.

- **`/landing <prompt>`** → the flagship (DEEP mode). The skill **LEADS**: it researches the market
  (scrape, competitors, keywords, audience), then runs EVERY phase autonomously — research →
  strategy → architecture → copy → design → build (multi-page) → motion → polish → seo → review →
  DEPLOY — **without interrogating you**. Hands you a live, market-current, multi-page site.
- **`/landing-new <brief>`** → run Planning only (strategy → copy + design), then STOP and show the
  plan + visual direction for approval before building.
- **`/landing-build`** → run Production (build → motion → polish, + seo) on the approved plan.
- **`/landing-review`** → run the review loop and apply fixes (max 3 passes).
- **`/landing-ship <brief>`** → full auto: every phase end-to-end, stopping only if a gate fails.
- **`/landing-init`** → bootstrap the project: detect framework/tooling (Firecrawl, Vercel, gh,
  Next.js), set up `landing/`, load the style profile — so the pipeline runs informed.
- **`/landing-continue`** → resume the pipeline from the last completed phase (reads `landing/`).
- **`/landing-status`** → show pipeline progress (read-only checklist).

**Interactive vs Auto:** default to Interactive — pause after each phase, show the artifact, ask
"¿seguimos o ajustamos?". Switch to Auto only when the user asks for speed.

## Phase 0 — Lead, don't interrogate (the skill is in charge)

The user already said what they want ("quiero una landing de X"). You are the **product lead** — you
do NOT run an interview. Gather context by RESEARCHING, not by asking:

1. **Load the saved style profile** (`mem_search` `landing-craft/style-profile`): animation intensity
   (default `medium`), Next.js + Tailwind always, no hardcoded tokens. Use as defaults — don't re-ask.
2. **Infer everything you can** from the prompt; if a URL/product exists, the **research phase scrapes
   it** — never ask what you can scrape.
3. **Ask AT MOST one short thing, and only if it's genuinely blocking** (e.g. no product and no way to
   infer the offer). Anything you can reasonably decide, DECIDE IT — you're the lead.
4. Then run the **full deep pipeline autonomously, end to end** — research → strategy → architecture →
   copy → design → build (multi-page) → motion → polish → seo → review → deploy — without pausing to ask.

**Tokens are not a constraint** — deliver a complete, market-current product, not a quick HTML page.
A landing is the market study + a multi-page site, not a single file. If the user states a lasting
preference ("siempre con muchas animaciones"), `mem_save` it to the profile. Never skip research.

## Phase 9 — Deploy (hands-off; the user only opens a URL)

After review PASSES, delegate to `landing-deploy`. Goal: the user does nothing but open a live URL.

1. **GitHub** — if `gh` is authenticated, create + push the repo (`gh repo create … --source … --push`).
2. **Vercel — no terminal for the user.** If the `vercel` CLI is missing, **install it**
   (`npm i -g vercel`). Then `vercel whoami`; if not authed, run **`vercel login` in the BACKGROUND**
   — it **auto-opens the user's browser** to the device-approval page (code pre-filled; they just
   click Approve). Tell them to approve the tab that opened; the printed `Visit https://…/oauth/device`
   link is only a fallback if the browser didn't open (don't have them paste it by hand). Poll
   `vercel whoami` until it returns a user; the session then **persists forever** (every future
   deploy is fully automatic). Create + name the project first (`vercel project add <name>` — needed
   because `--project` requires an existing project), then deploy from the build dir:
   `vercel deploy --yes --cwd <build-dir> --project <name>`. `vercel --prod` to promote on approval.
3. **The public URL is the project's production `*.vercel.app` alias** — NOT the deployment-specific
   URL, which sits behind Vercel's default auth protection (401). Verify with a curl (expect 200 +
   your `<title>`) before handing it over. **Redeploy on updates:** `vercel deploy` again in the
   linked dir updates the same project. Hand back the **public URL** + the repo URL.

Never auto-promote a first draft straight to production. Preview first, prod on approval.

## Artifacts & continuity

Write each phase's output to `landing/` in the project (`strategy.md`, `copy.md`, `design.md`,
`review.md`) so phases compose and the work survives a restart. If engram is available, also save
under topic keys `landing/<name>/<phase>`. Later phases READ the earlier artifacts — pass paths,
not full content, to keep the thread thin.

## Anti-slop guardrails (enforced at every phase)

- **No section without a job.** Every block earns its place (attention, desire, proof, objection,
  action). If you can't name its job, cut it.
- **One primary CTA**, repeated; everything else is secondary/ghost.
- **Specifics over adjectives.** "Live in 60 seconds" beats "the best innovative all-in-one solution".
- **Real visual decisions** — a deliberate type scale, a real colour system, generous spacing,
  asymmetry where it helps. Never the framework defaults untouched.
- **Tailwind + Next.js, no hardcoded tokens** — design tokens live in `tailwind.config`; components
  use utility classes that reference them. Next.js is the default stack (switch only if told).
- **Motion with configurable DEPTH, not flat** — apply the user's chosen intensity
  (`subtle`/`medium`/`rich`, default medium) per `references/animation-levels.md` (Motion · GSAP ·
  Lenis · Aceternity/Magic UI: card hovers, smooth scroll, counters, magnetic/tilt at the top end).
  Never flat, never chaotic — one signal per viewport; always `prefers-reduced-motion`.
- **Accessible & fast** — AA contrast **MEASURED, not eyeballed** (run the scorer in
  `references/contrast-check.md`; it's a hard gate before deploy), focus states, semantic HTML,
  Core Web Vitals green.

## References (load on demand)

- `references/_conventions.md` — **shared rules every agent follows** (orchestrator gate, artifact
  bus, zero-debt, the 5 bars, stack defaults, models). Read this first; don't restate it per agent.
- `references/market-research.md` *(the `landing-research` agent's method)* + `seo-geo` — the study.
- `references/site-architecture.md` — multi-page map + per-theme unique sections (Architecture phase).
- `references/alive-not-generic.md` — the 5th bar: real imagery, signature visual, scroll-reactive
  motion, warmth. Load in design + motion + review.
- `references/playbook.md` — conversion architecture (hero formula, proof, CTA rules).
- `references/animation-levels.md` — subtle/medium/rich motion + library stack.
- `references/contrast-check.md` — the WCAG gate (measured, not eyeballed).

## Portability — works in Claude Code AND OpenCode

All content is plain Markdown (skills/agents/commands) — platform-agnostic. The installers place it
in `~/.claude/` for Claude Code; for OpenCode, the same skills/agents/commands load from its config
(set `CLAUDE_CONFIG_DIR` or use the OpenCode skills/command dirs). Delegation uses the host's
sub-agent primitive (`Task`/`task`), so the orchestration runs the same on both.

## Output Contract

When the workflow finishes, report: the **live URL**, the pages built (multi-page), the phases run,
the positioning angle + the gap it owns (from research), the primary CTA, the review verdict
(5 bars), and follow-ups. Never declare "done" until `landing-research` grounded it and
`landing-review` returns a pass.
