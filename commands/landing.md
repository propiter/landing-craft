---
description: The flagship — one prompt to a deployed landing. Asks what it needs, then autonomously runs every phase and deploys. Hands you a live URL.
argument-hint: "<lo que querés, ej: 'una landing para mi SaaS'>"
---

Run the full **landing-craft** flagship flow for: **$ARGUMENTS**

Load the `landing-craft` skill and execute end to end:

**Phase 0 — Intake (ASK first).** Before building anything, use `AskUserQuestion` (one round, 3–5
questions) to get what actually changes the output: producto, audiencia, la acción que querés,
tono/marca (o "inferilo"), framework (Next.js default), prueba/assets, y si despliego a Vercel al
terminar. If a URL/existing site was given, scrape it first and only ask what you can't infer.

**Then run autonomously, no pausing:**
`landing-strategy → {landing-copy, landing-design} → landing-build → landing-motion → landing-polish` (+ `landing-seo` off the build) `→ landing-review` (loop to polish until PASS, max 3).

**Phase 9 — Deploy.** Once review PASSES, delegate to `landing-deploy`: push to GitHub (gh) and
deploy to Vercel — installing the Vercel CLI if missing and guiding the one-time `vercel login`
(with the link). Deploy a **preview URL** by default.

Enforce the four bars at every phase (not AI-looking, sells, intuitive, crafted). SEO and deploy
are NOT optional in this flow. Finish by handing the user the **live preview URL** + repo URL, and
"approve → promuevo a producción". Then the user requests changes and we iterate.
