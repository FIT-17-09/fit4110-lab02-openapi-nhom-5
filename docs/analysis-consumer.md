# Consumer Analysis - Pair 05 IoT Ingestion to Core Business

- Pair: #5 IoT Ingestion -> Core Business
- Product: Smart Campus Operations Platform
- Consumer service: Core Business (event consumer)
- Provider service: IoT Ingestion (event producer)
- Author: Group 5
- Date: 2026-05-18

---

## 1. Resources / Events Consumer Needs

| Resource or event | Consumer uses it for | Required fields for Consumer | Optional fields |
|---|---|---|---|
| `sensor.reading.created` | Evaluate normal sensor readings against campus policy and historical state. | `eventId`, `deviceId`, `sensorType`, `value`, `unit`, `quality`, `occurredAt`, `correlationId`, `idempotencyKey` | `locationId`, `floor` |
| `sensor.threshold.exceeded` | Create or escalate business alerts when a threshold breach is detected. | `eventId`, `deviceId`, `sensorType`, `value`, `unit`, `thresholdId`, `thresholdValue`, `severity`, `occurredAt`, `correlationId`, `idempotencyKey` | `locationId`, `policyHint` |
| `Problem` | Standardize mock REST error handling and evidence capture. | `type`, `title`, `status` | `detail`, `instance`, `errors` |

---

## 2. Contract Surface Consumer Needs

| Method / mechanism | Path or topic | When used | Expected response or behavior |
|---|---|---|---|
| Queue subscribe | `sensor.events.v1` | Core Business consumes event payloads from IoT Ingestion. | Events are processed idempotently and correlated by `correlationId`. |
| Queue subscribe | `sensor.events.dlq.v1` | Messages cannot be processed after retries. | Core Business records reason and exposes remediation in Lab 03. |
| POST | `/sensor-events` | Lab 02 mock validates a sample event. | `202` with `SensorEventAccepted`. |
| GET | `/sensor-events/{eventId}` | Evidence checks accepted event status. | `200` with `SensorEventStatus`, or `404` `Problem`. |
| GET | `/event-contract` | Confirms event names and delivery assumptions. | `200` with `EventContract`. |

---

## 3. Error Cases Consumer Must Handle

| Status | Consumer interpretation | Consumer action |
|---:|---|---|
| 400 | Event payload is malformed or does not match JSON Schema. | Reject the event, log validation errors, and route to DLQ in Lab 03. |
| 401 | Mock request has no valid token. | Fix credentials used by test/evidence scripts. |
| 403 | Authenticated caller lacks publish/read scope. | Review token scopes and service identity. |
| 404 | Requested event status is not available. | Treat as not yet observed or expired, then inspect logs. |
| 409 | Duplicate or conflicting idempotency data. | Keep the first accepted event and ignore conflicting retries. |
| 422 | Event is valid JSON but violates business rules. | Record the rule failure and avoid creating a business alert. |
| 500 | Core Business cannot enqueue/process the event. | Retry according to queue policy and alert operators if persistent. |

---

## 4. Consumer Assumptions

- `eventType` is the discriminator and must be one of `sensor.reading.created` or `sensor.threshold.exceeded`.
- `correlationId` is mandatory for tracing across IoT Ingestion, Core Business, and later notification workflows.
- Core Business will deduplicate by `idempotencyKey`, not only by `eventId`.
- `quality = INVALID` events are accepted for audit but do not trigger policy actions.
- `sensor.threshold.exceeded` can create an alert even if `locationId` is null, but the alert should be marked for enrichment.
- v1.0 supports six sensor types: temperature, humidity, smoke, pm25, co2, and motion.

---

## 5. Questions For Provider

1. Can IoT Ingestion guarantee monotonic `occurredAt` per device?
2. Which component owns threshold calculation when both IoT Ingestion and Core Business know threshold rules?
3. What retry interval and maximum delivery attempts should be documented in the Lab 03 AsyncAPI contract?

---

## 6. Integration Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Event type names change after Core Business implementation starts. | Consumer routing breaks. | Freeze event names in `openapi.yaml` and `negotiation-log.md`. |
| `locationId` is missing for critical events. | Alert routing may lack room context. | Keep `locationId` nullable but require `deviceId` so Core Business can enrich later. |
| Duplicate events create duplicate alerts. | Operators may receive repeated alerts. | Require `idempotencyKey` and document at-least-once delivery. |
| Threshold semantics differ between teams. | Wrong severity or unnecessary alerts. | Record `thresholdId`, `thresholdValue`, and `severity` in the threshold event. |
