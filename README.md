<div align="center">

# 🚀 Landing Craft

**SDD, but for landing pages.** An autonomous, multi-agent workflow that **researches the market,
designs, builds, and deploys** a modern, multi-page site that converts — and does *not* look
AI-generated.

You say *"armame una landing para X"*. The skill **leads**: it runs a real market study (scrape
competitors, mine keywords, profile the audience), then research → strategy → architecture → copy →
design → build → motion → polish → SEO → review → **deploy** (GitHub + Vercel) — **without
interrogating you**. It isn't done until it **looks crafted, sells, feels alive, and is live.**

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](./LICENSE)
![Version](https://img.shields.io/badge/version-1.9.0-black.svg)
![Agents](https://img.shields.io/badge/sub--agents-12-ff5d01.svg)
![Commands](https://img.shields.io/badge/commands-8-22c55e.svg)
![Platforms](https://img.shields.io/badge/Claude·OpenCode·Cursor-cross--platform-7c3aed.svg)

</div>

<div align="center">

**Real market research** (scrapes competitors) · **multi-page** (landing + legal · blog · contact) ·
**unique sections per theme** · **alive** (real imagery + scroll-reactive motion) ·
**analytics-ready** (GA4/GTM · consent · working forms) · **zero technical debt**

</div>

---

## Install

Pick the option that matches where you are. Each is basically one step.

### 🟣 Inside Claude Code — any OS (Windows · macOS · Linux) · recommended

Run these **one at a time** in the Claude Code prompt — paste one line, press **Enter**, then the
next. **Do NOT paste all three together** (they'd concatenate into one broken command):

**1.** add the marketplace:
```text
/plugin marketplace add https://github.com/propiter/landing-craft.git
```
**2.** install the plugin:
```text
/plugin install landing-craft@landing-craft
```
**3.** activate it:
```text
/reload-plugins
```

> ⚠️ Use the full **`https://…​.git`** URL (not the short `owner/repo` form, which can fail with an
> SSH *"Host key verification failed"* error). And one command per line — pasting the three at once
> is the usual cause of a *"Malformed URL"* error.

This works the same on **Windows**. After installing, the commands are namespaced:
`/landing-craft:landing`, `/landing-craft:landing-new`, …

### 🍎 macOS / Linux — one command in your terminal

```bash
curl -fsSL https://raw.githubusercontent.com/propiter/landing-craft/main/install.sh | bash
```

### 🪟 Windows — one command in PowerShell

```powershell
irm https://raw.githubusercontent.com/propiter/landing-craft/main/install.ps1 | iex
```

The two terminal installers copy the **whole stack** — 7 skills (landing-craft + its bundled
dependencies), 12 sub-agents and 8 commands — and **auto-detect Claude Code, OpenCode and Cursor**,
installing to each (OpenCode reads `~/.claude/skills/` natively). They fetch Impeccable too. If run
in a real terminal they also **offer an optional Firecrawl setup** (URL + optional API key — the key
is *not* required for self-hosted) and write it where each tool reads it, including OpenCode (which
does **not** read `~/.claude/settings.json`). Piped non-interactively (`curl … | bash`)? It's skipped
cleanly — set `FIRECRAWL_URL` in your env later.
You get plain commands: `/landing`, `/landing-new`, … After running one, **restart Claude Code or
run `/reload-plugins`** to activate them. No admin rights, nothing runs in the background; re-run
anytime to update.

> **Which should I use?** The Claude Code plugin (first option) is the cleanest — cross-platform and
> auto-updates. The terminal scripts are handy if you'd rather one command outside Claude.

## Use it

```bash
/landing "una landing para mi SaaS"                      # ★ flagship: research → build → DEPLOY (live URL)
/landing-init                                             # detect env + tooling, bootstrap
/landing-new "a project-management app for remote teams" # planning only → review the plan
/landing-build                                            # build + motion + polish + SEO
/landing-review                                           # render @ 390/768/1440, score, fix
/landing-continue                                         # resume from the last completed phase
/landing-status                                           # where the pipeline is (read-only)
/landing-ship "<your product>"                            # full auto (no deploy)
```

You don't need to know marketing — that's the research + strategy agents' job. With **`/landing`**
you barely brief it: it **researches the market**, builds the multi-page site autonomously, and
hands you a live URL (it installs the Vercel CLI if missing and guides the one-time login).

## The pipeline

```
  research ─► strategy ─► architecture ─┬─► copy ───┐
  (market study)                        └─► design ─┴─► build (multi-page) ─► motion ─► polish ─┐
                                                            build ─► seo ──────────────────────┴─► review ⭯ ─► deploy
```

| # | Phase | Sub-agent | What it guarantees |
|---|-------|-----------|--------------------|
| 0 | Research | `landing-research` | Autonomous market study — scrape competitors, keywords, audience, alive refs, the GAP |
| 1 | Strategy | `landing-strategy` | Positioning, ICP, core promise, offer (grounded in research) |
| 2 | Architecture | `landing-architecture` | The page map (multi-page) + the UNIQUE per-theme section plan |
| 3 | Copy | `landing-copy` | Research-backed conversion copy; the 5-second test passes |
| 4 | Design | `landing-design` | A signature visual + real imagery — the anti-"made with AI" phase |
| 5 | Build | `landing-build` | Multi-page Next.js + Tailwind, mobile-first, accessible |
| 6 | Motion | `landing-motion` | Scroll-reactive motion at the chosen intensity, reduced-motion safe |
| 7 | Polish | `landing-polish` | Craft pass — type, spacing, contrast (measured), responsive, states |
| 8 | SEO | `landing-seo` | Meta, OG, JSON-LD, CWV, llms.txt per page, researched keywords |
| 9 | Review | `landing-review` | Renders & scores the 5 bars + contrast gate + a **wiring gate** (no dead CTAs, decorative forms, unread env vars, missing assets, or unmounted analytics); loops until it passes |
| 10 | Deploy | `landing-deploy` | GitHub + Vercel; installs the CLI & guides first-time login; **syncs `.env` → Vercel** so a redeploy picks up your real GA ID / form endpoint / canonical URL |

## The five bars (enforced every phase)

> 1. **NOT AI-generated**.  2. It **sells** (what/who/why/next in 5 seconds).  3. It's **intuitive**
> (one obvious action per screen).  4. It's **crafted** (real motion, type, contrast, speed, a11y).
> 5. It's **ALIVE** — real imagery, a signature visual, scroll-reactive motion, warmth (not flat).

If any bar fails, it isn't done.

## Animation depth — you pick, it remembers

Not flat, not chaotic — a **dial**. Default **medium**; ask for `menos` or `más` and it adjusts (and
remembers your preference for next time):

- **subtle** — hero reveal, scroll fades, button micro-interactions.
- **medium** *(default)* — + Lenis smooth scroll, section reveals, **card hover depth**, number counters, CTA glow.
- **rich** — + GSAP scroll-scrub/parallax, magnetic buttons, 3D-tilt cards, spotlight/beams (Aceternity / Magic UI).

Built on **Motion + GSAP (free) + Lenis**, Next.js + Tailwind, every level `prefers-reduced-motion` safe.

## Batteries included — one command installs the whole stack

Landing Craft is the **orchestrator**, and the installer bundles every skill it composes — so
**nothing fails because a dependency is missing.** You never install pieces separately.

- **Bundled** (ship with the installer, Apache-2.0): `motion-craft` (animation),
  `marketing-strategy`, `brand-voice`, `seo-geo`, `design-review-loop`, `web-assets` (image/OG/favicon
  generation). The build phase **generates the signature visual, OG card and favicons** (installs
  Playwright if missing) and only asks you for the real logo/photos.
- **Fetched on install** (optional aesthetic engine, Apache-2.0):
  [Impeccable](https://github.com/pbakaus/impeccable) by Paul Bakaus — pulled from its source so it
  stays current, not forked. Skip it with `LANDING_CRAFT_IMPECCABLE=0`.

If a piece is ever missing, the agents degrade gracefully (e.g. the design/polish phases apply the
craft rules by hand instead of calling Impeccable).

## What's inside

```
landing-craft/
├── skills/landing-craft/
│   ├── SKILL.md              the orchestrator brain — the pipeline & delegation
│   └── references/           _conventions · market-research · site-architecture · alive-not-generic
│                             · playbook · animation-levels · contrast-check · instrumentation
├── agents/                   12 specialist sub-agents (init · research → architecture → … → deploy)
├── commands/                 /landing · /landing-init · /landing-new · /landing-build · /landing-review · /landing-continue · /landing-status · /landing-ship
└── install.sh · install.ps1  cross-platform one-command install (Claude · OpenCode · Cursor)
```

## Credits

Built on the shoulders of open source (all Apache-2.0):

- [Impeccable](https://github.com/pbakaus/impeccable) by **Paul Bakaus** — the aesthetic engine,
  fetched at install time.
- Bundled skills: `motion-craft`, `marketing-strategy`, `brand-voice`, `seo-geo`,
  `design-review-loop`, `web-assets`.

## License

[Apache 2.0](./LICENSE) © propiter. Built to be used, shared, and improved.
