# Stock Tree Design System

Use these tokens and conventions when implementing UI in Rails views (ERB), Stimulus, and Tailwind CSS. Keep styles semantic and prefer utility classes combined with these tokens.

## Colors

- Primary: `#2d5016` (CSS var: `--color-primary`)
- Success: `#4a7c3c` (CSS var: `--color-success`)
- Warning: `#f59e0b` (CSS var: `--color-warning`)
- Background: `#ffffff` (CSS var: `--color-bg`)
- Sidebar: `#f5f5f5` (CSS var: `--color-sidebar`)
- Borders: `#e5e7eb` (CSS var: `--color-border`)

## Typography

- Sans-serif font (Inter or system font) via `--font-sans`
- Headers weight: `600` via `--font-weight-header`
- Body weight: `400` via `--font-weight-body`
- Small text: `14px` via `--font-size-small`

## Spacing

- 8px grid tokens: `--space-1` (8px), `--space-2` (16px), `--space-3` (24px)
- Card padding: `--card-padding` (16px)
- Section gap: `--section-gap` (24px)

## How to use

- CSS variables are defined in `app/assets/tailwind/tokens.css`.
- Imported in `app/assets/tailwind/application.css` before `components.css`.
- Prefer semantic classes in `components.css` that reference tokens; keep component names like `.card`, `.btn`, `.sidebar`.
- In ERB, prefer Tailwind utilities for layout and spacing, but rely on `.card`, `.btn-…`, `.badge-…` for consistent look.

## Examples

- Button: `<button class="btn btn-primary">Save</button>`
- Card: `<div class="card"><div class="card-header">Title</div><div class="card-body">Content</div></div>`
- Input: `<input class="input" />`

## Notes

- Adjust or extend tokens in `tokens.css` as the design evolves.
- Keep this document and tokens in sync; Copilot will suggest consistent code when these are canonical.
