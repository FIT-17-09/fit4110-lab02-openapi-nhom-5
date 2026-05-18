# API Versioning Strategy

## Current Version

- API Version: v1.0.0
- OpenAPI Version: 3.1.0
- Release Date: 2026-05-18

---

## Versioning Rules

- Breaking changes require a new major version.
- Non-breaking additions use a minor version update.
- Bug fixes and documentation updates use patch versions.

Example:

- v1.0.0 → Initial contract
- v1.1.0 → Add optional fields/endpoints
- v2.0.0 → Breaking schema changes

---

## REST Versioning

REST endpoints use URI versioning if needed in future:

```text
/api/v1/access/check
```

---

## Changelog

| Version | Date       | Author  | Description                           |
|---------|------------|---------|---------------------------------------|
| v1.0.0  | 2026-05-18 | Nhóm 5  | Initial contract — signed off by both parties |

---

## Sign-off

| Role                          | Đại diện | Ngày       |
|-------------------------------|----------|------------|
| Provider Pair 03 (Access Gate)  | Nhóm 5   | 2026-05-18 |
| Consumer Pair 03 (Core Business)| Nhóm 12  | 2026-05-18 |
| Provider Pair 10 (Core Business)| Nhóm 12  | 2026-05-18 |
| Consumer Pair 10 (Access Gate)  | Nhóm 5   | 2026-05-18 |