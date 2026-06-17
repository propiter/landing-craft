<div align="center">

# 🚀 Landing Craft

**SDD, but for landing pages.** A phased, multi-agent workflow that ships a modern, elegant,
intuitive, **high-converting** landing — one that does *not* look AI-generated.

You say *"armame una landing para X"*. It **asks the few questions it needs**, then autonomously
runs strategy → copy → design → build → motion → polish → SEO → review — and **deploys it** (GitHub
+ Vercel). It doesn't call it done until it **looks crafted, sells, and is live.**

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](./LICENSE)
![Version](https://img.shields.io/badge/version-1.5.0-black.svg)
![Agents](https://img.shields.io/badge/sub--agents-9-ff5d01.svg)
![Commands](https://img.shields.io/badge/commands-5-22c55e.svg)

</div>

---

## Install

Pick the option that matches where you are. Each is basically one step.

### 🟣 Inside Claude Code — any OS (Windows · macOS · Linux) · recommended

Type these **in the Claude Code prompt** (not your computer's terminal):

```text
/plugin marketplace add https://github.com/propiter/landing-craft.git
/plugin install landing-craft@landing-craft
/reload-plugins
```

> ⚠️ Use the full **`https://…​.git`** URL. The short `owner/repo` form can fail with an
> *"SSH host key… Host key verification failed"* error on machines set up to clone GitHub over SSH.
> The HTTPS URL avoids that.

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

The two terminal installers copy the **whole stack** — 6 skills (landing-craft + its bundled
dependencies), 9 sub-agents and 5 commands — into your `~/.claude/` folder, and fetch Impeccable.
You get plain commands: `/landing`, `/landing-new`, … After running one, **restart Claude Code or
run `/reload-plugins`** to activate them. No admin rights, nothing runs in the background; re-run
anytime to update.

> **Which should I use?** The Claude Code plugin (first option) is the cleanest — cross-platform and
> auto-updates. The terminal scripts are handy if you'd rather one command outside Claude.

## Use it

```bash
/landing "una landing para mi SaaS de facturación"       # ★ flagship: asks → builds → DEPLOYS (live URL)
/landing-new "API de facturación DIAN para developers"   # planning only → review the plan
/landing-build                                            # build + motion + polish + SEO
/landing-review                                           # render @ 390/768/1440, score, fix
/landing-ship "<your product>"                            # full auto (no deploy)
```

You don't need to know marketing — that's the strategy agent's job. With **`/landing`** you don't
even need a brief: it asks the few questions it needs, builds autonomously, and hands you a live
URL (it installs the Vercel CLI if missing and guides the one-time login).

## The pipeline

```
  intake ─► strategy ─┬─► copy ───┐
   (ASK)              └─► design ──┴─► build ─► motion ─► polish ─┐
                                            build ─► seo ─────────┴─► review ⭯ ─► deploy
```

| # | Phase | Sub-agent | What it guarantees |
|---|-------|-----------|--------------------|
| 0 | Intake | *orchestrator* | Asks the few questions that change the output — never builds blind |
| 1 | Strategy | `landing-strategy` | Positioning, ICP, core promise, offer — the foundation |
| 2 | Copy | `landing-copy` | Anti-slop conversion copy; the 5-second test passes |
| 3 | Design | `landing-design` | A deliberate visual system — the anti-"made with AI" phase |
| 4 | Build | `landing-build` | Real code (Next.js + Tailwind by default), mobile-first, accessible |
| 5 | Motion | `landing-motion` | One hero reveal + micro-interactions, 60fps, reduced-motion safe |
| 6 | Polish | `landing-polish` | The craft pass — type, spacing, contrast, responsive, states |
| 7 | SEO | `landing-seo` | Meta, OG, JSON-LD, Core Web Vitals, `llms.txt` |
| 8 | Review | `landing-review` | Renders & scores craft + conversion; loops until it passes |
| 9 | Deploy | `landing-deploy` | Pushes to GitHub + deploys to Vercel; installs the CLI & guides first-time login |

## The four bars (enforced every phase)

> 1. It does **NOT look AI-generated**.  2. It **sells** (what/who/why/next in 5 seconds).
> 3. It's **intuitive** (one obvious action per screen).  4. It's **crafted** (real motion, type,
> contrast, speed, a11y).

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
  `marketing-strategy`, `brand-voice`, `seo-geo`, `design-review-loop`.
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
│   └── references/           playbook (conversion) · animation-levels (subtle/medium/rich) · contrast-check (WCAG gate)
├── agents/                   9 specialist sub-agents (one per phase, incl. deploy)
├── commands/                 /landing · /landing-new · /landing-build · /landing-review · /landing-ship
└── install.sh                one-command install into ~/.claude
```

## Credits

Built on the shoulders of open source (all Apache-2.0):

- [Impeccable](https://github.com/pbakaus/impeccable) by **Paul Bakaus** — the aesthetic engine,
  fetched at install time.
- Bundled skills: `motion-craft`, `marketing-strategy`, `brand-voice`, `seo-geo`,
  `design-review-loop`.

## License

[Apache 2.0](./LICENSE) © propiter. Built to be used, shared, and improved.
