# Negotiation Log - Sensor Event Contract

- Pair: #5 IoT Ingestion -> Core Business
- Product: Smart Campus Operations Platform
- Provider / producer: IoT Ingestion
- Consumer: Core Business
- Session: v1.0
- Date: 2026-05-18

---

## Issue #1 - Event names and topic

- Raised by: Consumer
- Endpoint/topic: `sensor.events.v1`
- Concern: Core Business needs stable event names for routing and alert policy.
- Proposal: Use `sensor.reading.created` for normal readings and `sensor.threshold.exceeded` for threshold breaches.
- Resolution: Accepted
- Rationale: The names are domain specific, versionable through the topic name, and map directly to the two Lab 02 user story events.
- Impact: `eventType` is the discriminator in `openapi.yaml`; AsyncAPI in Lab 03 must keep the same names.

---

## Issue #2 - Minimum payload and nullable location

- Raised by: Provider
- Endpoint/topic: `sensor.events.v1`
- Concern: Some devices may not have a room mapping at publication time.
- Proposal: Require device and metric fields, but allow `locationId` and `floor` to be null.
- Resolution: Modified
- Rationale: Core Business can still deduplicate and audit by `deviceId`; room enrichment can happen later.
- Impact: `locationId` uses OpenAPI 3.1 union type with `null`; business logic must not reject only because location is missing.

---

## Issue #3 - Units and sensor type enum

- Raised by: Consumer
- Endpoint/topic: `sensor.events.v1`
- Concern: Unit mismatch can cause wrong threshold evaluation.
- Proposal: Restrict `sensorType` and `unit` to enums for v1.0.
- Resolution: Accepted
- Rationale: A small enum reduces ambiguity and makes mock validation useful.
- Impact: v1.0 supports temperature, humidity, smoke, pm25, co2, and motion with units celsius, percent, ppm, ugm3, and boolean.

---

## Issue #4 - Idempotency and duplicate delivery

- Raised by: Consumer
- Endpoint/topic: `sensor.events.v1`
- Concern: Queue delivery is at-least-once, so retries can create duplicate alerts.
- Proposal: Require `idempotencyKey` and have Core Business deduplicate on that key.
- Resolution: Accepted
- Rationale: `eventId` identifies a message, while `idempotencyKey` identifies the business reading across retries.
- Impact: Duplicate keys with different event ids return `409` in the mock projection and route to DLQ in Lab 03.

---

## Issue #5 - Timestamp freshness

- Raised by: Provider
- Endpoint/topic: `sensor.events.v1`
- Concern: Offline devices can replay old readings after reconnecting.
- Proposal: Core Business ignores non-critical readings older than 15 minutes, but still audits them.
- Resolution: Accepted
- Rationale: This prevents stale readings from driving live policy decisions while keeping traceability.
- Impact: Core Business may produce `IGNORED_TOO_OLD` in status responses; Lab 03 should document retry and replay behavior.

---

## Issue #6 - Threshold ownership

- Raised by: Consumer
- Endpoint/topic: `sensor.threshold.exceeded`
- Concern: IoT Ingestion and Core Business may evaluate thresholds differently.
- Proposal: Threshold events must include `thresholdId`, `thresholdValue`, and `severity`.
- Resolution: Accepted
- Rationale: Core Business can trust the producer signal while still auditing which rule produced it.
- Impact: `sensor.threshold.exceeded` has stricter required fields than `sensor.reading.created`.

---

## Issue #7 - Retry and dead-letter assumption

- Raised by: Provider
- Endpoint/topic: `sensor.events.dlq.v1`
- Concern: Lab 02 does not define the broker implementation, retry interval, or DLQ format.
- Proposal: Record at-least-once delivery and reserve `sensor.events.dlq.v1` for Lab 03.
- Resolution: Modified
- Rationale: This gives enough agreement for Lab 02 without pretending the AsyncAPI details are final.
- Impact: `event-contract` response documents retry as `at-least-once`; full retry count and DLQ schema move to Lab 03.

---

# Contract Sign-Off v1.0

Provider sign-off: IoT Ingestion representative - accepted 2026-05-18
Consumer sign-off: Core Business representative - accepted 2026-05-18
Witness (GV/TA): Pending classroom review
Date: 2026-05-18

---

## Spectral Warning Notes

| Warning | Temporary acceptance reason | Fix plan |
|---|---|---|
| None at local review time | Not applicable | Keep `npm run lint` passing before submission. |
