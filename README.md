<div align="center">

# 🚀 Landing Craft

**SDD, but for landing pages.** A phased, multi-agent workflow that ships a modern, elegant,
intuitive, **high-converting** landing — one that does *not* look AI-generated.

You say *"armame una landing para X"*. It runs strategy → copy → design → build → motion → polish
→ SEO → review, delegating each phase to a specialist sub-agent, and doesn't call it done until it
**looks crafted and sells.**

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](./LICENSE)
![Version](https://img.shields.io/badge/version-1.0.0-black.svg)
![Agents](https://img.shields.io/badge/sub--agents-8-ff5d01.svg)
![Commands](https://img.shields.io/badge/commands-4-22c55e.svg)

</div>

---

## Install

**One command** (macOS / Linux):

```bash
curl -fsSL https://raw.githubusercontent.com/propiter/landing-craft/main/install.sh | bash
```

**Or as a Claude Code plugin:**

```bash
/plugin marketplace add propiter/landing-craft
/plugin install landing-craft@landing-craft
```

The installer copies one skill, 8 sub-agents, and 4 slash-commands into `~/.claude/`. No sudo, no
global npm, nothing runs in the background. Re-run anytime to update.

## Use it

```bash
/landing-new "API de facturación DIAN para developers"   # strategy + copy + design → review the plan
/landing-build                                            # build + motion + polish + SEO
/landing-review                                           # render @ 390/768/1440, score, fix
/landing-ship "<your product>"                            # full auto, end to end
```

You don't need to know marketing — that's the strategy agent's job. Give it the product and who
it's for; it drafts the rest and you confirm.

## The pipeline

```
                ┌────────────► copy ──────┐
  brief ► strategy                         ├─► build ─► motion ─► polish ─┐
                └────────────► design ─────┘                 build ─► seo ─┴─► review ⭯
```

| # | Phase | Sub-agent | What it guarantees |
|---|-------|-----------|--------------------|
| 1 | Strategy | `landing-strategy` | Positioning, ICP, core promise, offer — the foundation |
| 2 | Copy | `landing-copy` | Anti-slop conversion copy; the 5-second test passes |
| 3 | Design | `landing-design` | A deliberate visual system — the anti-"made with AI" phase |
| 4 | Build | `landing-build` | Real code (Next.js + Tailwind by default), mobile-first, accessible |
| 5 | Motion | `landing-motion` | One hero reveal + micro-interactions, 60fps, reduced-motion safe |
| 6 | Polish | `landing-polish` | The craft pass — type, spacing, contrast, responsive, states |
| 7 | SEO | `landing-seo` | Meta, OG, JSON-LD, Core Web Vitals, `llms.txt` |
| 8 | Review | `landing-review` | Renders & scores craft + conversion; loops until it passes |

## The four bars (enforced every phase)

> 1. It does **NOT look AI-generated**.  2. It **sells** (what/who/why/next in 5 seconds).
> 3. It's **intuitive** (one obvious action per screen).  4. It's **crafted** (real motion, type,
> contrast, speed, a11y).

If any bar fails, it isn't done.

## Built on a stack, not from scratch

Landing Craft is the **orchestrator**. The deep knowledge lives in skills it composes — install
those for the full effect:

- [`motion-craft`](https://github.com/propiter/motion-craft) — animation
- `marketing-strategy` · `brand-voice` · `seo-geo` · `design-review-loop` — strategy, copy, SEO, review
- [Impeccable](https://github.com/pbakaus/impeccable) — the aesthetic engine

## What's inside

```
landing-craft/
├── skills/landing-craft/
│   ├── SKILL.md              the orchestrator brain — the pipeline & delegation
│   └── references/playbook.md the conversion architecture (sections, hero, CTA, proof)
├── agents/                   8 specialist sub-agents (one per phase)
├── commands/                 /landing-new · /landing-build · /landing-review · /landing-ship
└── install.sh                one-command install into ~/.claude
```

## License

[Apache 2.0](./LICENSE) © propiter. Built to be used, shared, and improved.
