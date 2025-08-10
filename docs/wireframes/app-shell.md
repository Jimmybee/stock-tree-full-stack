# App Shell Wireframe

This is a rough wireframe of the current app shell (header/sidebar/content) and a couple of API-driven screens.

## Dashboard (Signed-in)

```txt
+----------------------------------------------------------------------------------+
| Stock Tree                                            [email] [Sign out]          |
+----------------------------------------------------------------------------------+
| Nav (left)                                 | Content (right)                      |
|--------------------------------------------+--------------------------------------|
| - Team switcher (placeholder)              | Dashboard                            |
| - Folders                                  |  - Welcome message                   |
| - Products                                 |  - Quick links (future)              |
|                                            |                                      |
+----------------------------------------------------------------------------------+
```

## Folder view

```txt
+----------------------------------------------------------------------------------+
| Stock Tree                                            [email] [Sign out]          |
+----------------------------------------------------------------------------------+
| Nav (left)                                 | Folder: Root                         |
|--------------------------------------------+--------------------------------------|
| - Team switcher (placeholder)              | Subfolders:                          |
| - Folders                                  |  - Office                            |
| - Products                                 |  - Warehouse                         |
|                                            | Products:                            |
|                                            |  - Widget A                          |
|                                            |  - Widget B                          |
+----------------------------------------------------------------------------------+
```

## Product list

```txt
+----------------------------------------------------------------------------------+
| Stock Tree                                            [email] [Sign out]          |
+----------------------------------------------------------------------------------+
| Nav (left)                                 | Products                             |
|--------------------------------------------+--------------------------------------|
| - Team switcher (placeholder)              | Filters: [q____] [Folder ▼]          |
| - Folders                                  | ----------------------------------   |
| - Products                                 |  - Product row (name, qty, tags)     |
|                                            |  - Product row                        |
|                                            |  Pagination: < 1 2 3 >               |
+----------------------------------------------------------------------------------+
```

## Notes

- API uses jsonapi-serializer; responses are wrapped like `{ products: [...], meta }` or `{ folder }`.
- Auth: Devise (web) + JWT for API.
- Authorization: Pundit (team membership).
- Images via Active Storage (product_image) with type/size validation.
