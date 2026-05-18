# Known Issues - Lab 02

| Issue | Impact | Planned handling | Owner |
|---|---|---|---|
| Full broker retry count and DLQ payload are not finalized in Lab 02. | Async delivery behavior still needs implementation-level detail. | Move to Lab 03 AsyncAPI contract. | IoT Ingestion + Core Business |
| `locationId` can be null for unmapped devices. | Core Business may need enrichment before routing alerts by room. | Keep nullable field in v1.0 and enrich by `deviceId`. | Core Business |
| Prism evidence uses a REST mock projection for an async queue contract. | The mock validates payload shape but does not prove broker behavior. | Document queue semantics in `negotiation-log.md` and finish broker contract in Lab 03. | Group 5 |
