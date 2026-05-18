# OpenAPI Authoring Guide

- Use OpenAPI 3.1.0
- Place schemas under `components/schemas` and reference via `$ref`.
- Include `oneOf` + `discriminator` and union types where relevant.
- Use Problem Details for error responses.
