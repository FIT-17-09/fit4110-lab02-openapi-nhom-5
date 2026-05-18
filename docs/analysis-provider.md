# Provider Analysis - Pair 05 IoT Ingestion to Core Business

- Pair: #5 IoT Ingestion -> Core Business
- Product: Smart Campus Operations Platform
- Provider service: IoT Ingestion (event producer)
- Consumer service: Core Business (event consumer)
- Author: Group 5
- Date: 2026-05-18

---

## 1. Main Resources / Events

| Resource or event | Description | Required fields | Optional fields |
|---|---|---|---|
| `sensor.reading.created` | Normal sensor reading published by IoT Ingestion. | `eventId`, `eventType`, `deviceId`, `sensorType`, `value`, `unit`, `quality`, `occurredAt`, `correlationId`, `idempotencyKey`, `source` | `locationId`, `floor` |
| `sensor.threshold.exceeded` | Sensor reading crossed a policy threshold and needs Core Business action. | `eventId`, `eventType`, `deviceId`, `sensorType`, `value`, `unit`, `thresholdId`, `thresholdValue`, `severity`, `occurredAt`, `correlationId`, `idempotencyKey`, `source` | `locationId`, `policyHint` |
| `Problem` | Standard error body for mock REST validation. | `type`, `title`, `status` | `detail`, `instance`, `errors` |

---

## 2. Expected Contract Surface

| Method / mechanism | Path or topic | Purpose | Consumer uses it when |
|---|---|---|---|
| Queue publish | `sensor.events.v1` | Primary async delivery for both event types. | IoT Ingestion has a new reading or threshold breach. |
| Queue dead-letter | `sensor.events.dlq.v1` | Store messages that Core Business cannot process after retries. | Message is invalid, stale, or repeatedly failing. |
| POST | `/sensor-events` | Lab 02 Prism mock projection for event validation. | Demonstrating payload acceptance before Lab 03 AsyncAPI. |
| GET | `/sensor-events/{eventId}` | Mock status lookup for accepted events. | Checking idempotency and processing status. |
| GET | `/sensor-events/recent` | Mock recent-event inspection. | Reviewing evidence and sample responses. |
| GET | `/event-contract` | Published metadata for topic, producer, consumer, retry and DLQ assumptions. | Confirming the negotiated v1.0 contract. |

---

## 3. Error Cases

| Status | Situation | Expected response body |
|---:|---|---|
| 400 | JSON does not match schema, for example invalid `deviceId`. | `Problem` |
| 401 | Missing or invalid Bearer token on mock REST endpoints. | `Problem` |
| 403 | Token is valid but lacks event publish/read scope. | `Problem` |
| 404 | `eventId` is not known by the mock status endpoint. | `Problem` |
| 409 | Same `idempotencyKey` appears with a different `eventId`. | `Problem` |
| 422 | Payload is syntactically valid but violates event business rules. | `Problem` |
| 500 | Core Business cannot enqueue or inspect the event. | `Problem` |

---

## 4. Provider Assumptions

- IoT Ingestion is the source of truth for `deviceId`, `sensorType`, `value`, `unit`, `quality`, and `occurredAt`.
- `eventId` is globally unique and generated before publication.
- `idempotencyKey` is stable for retries of the same device, timestamp, and metric.
- Delivery is at-least-once; Core Business must deduplicate by `idempotencyKey`.
- Events older than 15 minutes may be ignored by Core Business unless the event type is `sensor.threshold.exceeded` with severity `CRITICAL`.
- `locationId` can be null when a device has not yet been mapped to a campus room.

---

## 5. Questions For Consumer

1. Which sensor types should trigger Core Business policy evaluation in v1.0?
2. How long should Core Business keep idempotency keys for deduplication?
3. Should a missing `locationId` block policy evaluation or be accepted with a warning?

---

## 6. Integration Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Sensor units are interpreted differently. | Core Business may evaluate thresholds incorrectly. | Restrict `unit` to the enum in `openapi.yaml` and document conversion rules in Lab 03. |
| Duplicate delivery is not handled consistently. | Alerts may be created more than once. | Require `idempotencyKey` and mark delivery as at-least-once. |
| Event timestamps are delayed or clock-skewed. | Core Business may process stale readings. | Use `occurredAt` and agree on a 15-minute freshness rule. |
| Device location is unknown. | Policy evaluation may miss building or room context. | Allow nullable `locationId` and require follow-up enrichment in Core Business. |
