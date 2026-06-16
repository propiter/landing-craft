---
description: Full auto — run the entire landing-craft pipeline end to end (strategy → copy → design → build → motion → polish → seo → review) and stop only if a gate fails.
argument-hint: "<product / brief>"
---

Run the **complete landing-craft** pipeline for: **$ARGUMENTS** in AUTO mode.

Load the `landing-craft` skill and execute every phase end to end, delegating each to its
sub-agent and passing artifacts forward:

`landing-strategy → {landing-copy, landing-design} → landing-build → landing-motion → landing-polish` (+ `landing-seo` off the build) `→ landing-review`.

Rules:
- If the brief is thin, draft strategy and proceed (note assumptions); don't block — but DO surface
  any assumption that materially changes positioning.
- Enforce the four bars at every phase: not AI-looking, sells, intuitive, crafted.
- Loop review → polish until PASS (max 3 passes).
- Then report: live URL, positioning one-liner, primary CTA, review verdict, and follow-ups.

Only stop early if a gate genuinely can't pass or a destructive/ambiguous decision needs me.
