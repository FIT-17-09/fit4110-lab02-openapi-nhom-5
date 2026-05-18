# API Versioning Strategy

## Current Version

- API Version: v1.0.0
- OpenAPI Version: 3.1.0

---

## Versioning Rules

- Breaking changes require a new major version.
- Non-breaking additions use a minor version update.
- Bug fixes and documentation updates use patch versions.

Example:

- v1.0.0 -> Initial contract
- v1.1.0 -> Add optional fields/endpoints
- v2.0.0 -> Breaking schema changes

---

## REST Versioning

REST endpoints use URI versioning if needed in future:

```text
/api/v1/access/check