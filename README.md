# MAST Designs Monorepo

All design variant portfolios for M4ST (Anuj) — one repo, multiple Vercel projects. Zero-cost, always-on, self-hosted single-page HTML.

## Live Network (14 sites)

| # | Project | URL | Style |
|---|---------|-----|-------|
| 01 | m4stanuj | [m4stanuj.vercel.app](https://m4stanuj.vercel.app) | Main portfolio |
| 02 | mast-anuj | [mast-anuj.vercel.app](https://mast-anuj.vercel.app) | Variant |
| 03 | mast-anuj-site | [mast-anuj-site.vercel.app](https://mast-anuj-site.vercel.app) | Variant |
| 04 | m4st | [m4st.vercel.app](https://m4st.vercel.app) | **Synthwave** (hub) |
| 05 | mastanuj-royal | [mastanuj-royal.vercel.app](https://mastanuj-royal.vercel.app) | Royal |
| 06 | mastanuj-elite | [mastanuj-elite.vercel.app](https://mastanuj-elite.vercel.app) | Elite |
| 07 | mastanuj-prism | [mastanuj-prism.vercel.app](https://mastanuj-prism.vercel.app) | Prism |
| 08 | mastanuj-pixel | [mastanuj-pixel.vercel.app](https://mastanuj-pixel.vercel.app) | Pixel |
| 09 | mastanuj-v1 | [mastanuj-v1.vercel.app](https://mastanuj-v1.vercel.app) | V1 |
| 10 | mastanuj-retro | [mastanuj-retro.vercel.app](https://mastanuj-retro.vercel.app) | Retro |
| 11 | mastanuj-command | [mastanuj-command.vercel.app](https://mastanuj-command.vercel.app) | Command |
| 12 | mastanuj-dossier | [mastanuj-dossier.vercel.app](https://mastanuj-dossier.vercel.app) | Dossier |
| 13 | mastanuj-comic | [mastanuj-comic.vercel.app](https://mastanuj-comic.vercel.app) | Comic |
| 14 | mastanuj-core | [mastanuj-core.vercel.app](https://mastanuj-core.vercel.app) | Core |

## Variant folders

Each folder is a self-contained single-page HTML design, synced to the live network:

- `m4stanuj/` — main portfolio.
- `m4st-synthwave/` — the flagship hub: animated neon sun, perspective grid floor, starfield, boot screen, live terminal log, scrollspy + side rail, count-up stats, per-site network cards, hero typing effect.
- `mast-anuj-site/` — personal site variant (serves both `mast-anuj.vercel.app` and `mast-anuj-site.vercel.app`).
- `mastanuj-core/`, `mastanuj-prism/`, `mastanuj-royal/`, `mastanuj-elite/`, `mastanuj-pixel/`, `mastanuj-comic/`, `mastanuj-dossier/`, `mastanuj-command/`, `mastanuj-retro/`, `mastanuj-v1/` — design variants.
- Legacy folders (`mast-agent`, `mast-arcade`, `mast-brutal`, `mast-casefile`, `mast-glass`, `mast-luxury`, `mast-manga`, `mast-vhs`, `m4st-v1`, `m4st-premium`) — archived, no longer deployed.

## Tooling

- `build-footer.ps1` — regenerates the 14-site cross-link footer across variants.
- `health-check.ps1` — verifies all 14 sites are live and links resolve.
- `seo-audit.ps1` — audits meta / robots / sitemap / IndexNow keys.
- `sites.json` — machine-readable registry of the live network.

## Stack

Single-file HTML + CSS + JS, deployed free on Vercel. No build step, no framework, no cost.