# Contract Versioning

## Current Version

- Contract version: `1.0.0`
- Pair: #5 IoT Ingestion -> Core Business
- Scope: sensor event payload, REST mock projection, Problem Details error model, and Lab 02 negotiation decisions.
- Status: signed off for Lab 02 mock validation.

## Versioning Rule

This contract follows semantic versioning:

| Change type | Version bump | Examples |
|---|---|---|
| Breaking change | Major | Rename `eventType`, remove a required field, change enum meaning, change idempotency semantics. |
| Backward-compatible feature | Minor | Add an optional field, add a new event type, add a new response example. |
| Documentation or example fix | Patch | Clarify descriptions, fix typos, improve examples without changing schema behavior. |

## Compatibility Policy

- Consumers must accept unknown optional fields only after the Lab 03 AsyncAPI compatibility rule is finalized.
- Required fields in v1.0 cannot be removed without a major version bump.
- New event types require a minor version bump and an updated discriminator mapping.
- Queue topic versioning uses the topic suffix, for example `sensor.events.v1`.
- Problem Details fields remain stable across all v1.x versions.

## Change Log

| Version | Date | Changes |
|---|---|---|
| 1.0.0 | 2026-05-18 | Initial Lab 02 contract for `sensor.reading.created` and `sensor.threshold.exceeded`, with Prism mock paths and negotiated retry/idempotency assumptions. |

## Lab 03 Follow-Up

- Convert the event contract to AsyncAPI.
- Define broker, retry count, retry interval, and DLQ payload.
- Decide how long Core Business stores idempotency keys.
- Add schema examples for DLQ remediation events.
