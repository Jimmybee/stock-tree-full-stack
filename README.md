# Stock Tree (Full-Stack)

![Ruby CI](https://github.com/Jimmybee/stock-tree-full-stack/actions/workflows/ci.yml/badge.svg)

Full-stack rebuild of Stock Tree: a team-based inventory system with a nested folder tree, products with images/tags/batches, and an integrated web UI.

## Status

New repository scaffolding. Planning and setup tracked in Issues and Project board.

## Quick links

- Issues: <https://github.com/Jimmybee/stock-tree-full-stack/issues>
- Project board (create): <https://github.com/users/Jimmybee/projects/new>

## High-level scope

- Rails 7.1 app (API + HTML) with Hotwire, Tailwind, Devise(+JWT), Pundit
- Postgres + UUIDs, Active Storage (S3 in prod)
- Domain: Teams, Folders (tree), Products, Batches, Tags
- Web UI inside Rails (Turbo/Stimulus)

See ROADMAP.md for phased delivery.

## Contributing

- Small PRs linked to Issues.
- Include tests and screenshots for UI.
- See .github templates for helpful checklists.

## Development

Prereqs: Ruby 3.3, PostgreSQL (or Docker), Node is not required (importmap), Tailwind via tailwindcss-rails.

Setup

1. Copy env and set secrets

- cp .env.example .env
- echo "DEVISE_JWT_SECRET_KEY=$(bin/rails secret)" >> .env

1. Start Postgres (Docker)

- docker compose up -d db

1. Prepare DB and run

- bin/rails db:prepare
- bin/dev

## Common issues

- Postgres connection refused: ensure Docker DB is running on port 55432 and your `.env` matches `docker-compose.yml`.
- Missing DEVISE_JWT_SECRET_KEY: generate one with `bin/rails secret` and add it to `.env`.
- Node not required: this app uses importmap and tailwindcss-rails; no npm/yarn setup needed.
