# Contributing

Thanks for contributing to Stock Tree! Please keep PRs small and focused.

## Workflow

Early development policy: Branches are optional; direct commits to `main` are acceptable. Please still reference the issue number in commit messages.

- When branching, use: `feat/<issue-number>-short-title` or `fix/<...>`
- Write tests for new behavior (RSpec)
- Run the full suite and linter locally before pushing
- Link your PR to the GitHub Issue and include a brief description

## Setup

- Copy environment: `cp .env.example .env` and set secrets
- Start DB (Docker): `docker compose up -d db`
- Bootstrap: `bin/setup`
- Run dev server: `bin/dev`

## Tests and lint

- Tests: `bundle exec rspec`
- Lint: `bundle exec rubocop`

## Commit hygiene

- Use conventional commits when possible (feat:, fix:, chore:)
- Keep commits scoped; avoid mixing refactors with features
