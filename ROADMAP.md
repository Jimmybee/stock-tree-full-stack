# Roadmap (Phased)

- Phase 0: Bootstrap
  - Rails 7.1 skeleton, Tailwind, Devise, Pundit, Active Storage, UUIDs
  - RSpec (or Minitest), RuboCop, Annotate, Bullet
- Phase 1: Auth + Users
  - Devise HTML + API JWT, user profile, Pundit base
- Phase 2: Teams & Folders
  - Team membership, root folder service, folder tree CRUD
- Phase 3: Products
  - Product CRUD, images, pagination/filtering
- Phase 4: Web UI
  - Hotwire UI: tree navigation, product list/detail
- Phase 5: Sync (optional)
  - Upsert API, updated_after, conflict policy
- Phase 6: Batches & Tags
  - Batch CRUD, expiry, tag management & filtering
- Phase 7: Productionization
  - S3, security headers, CORS, health checks, error reporting, docs

Each phase: tests green, policies in place, no N+1.
