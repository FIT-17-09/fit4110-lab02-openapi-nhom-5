#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:4010}"
AUTH_HEADER="Authorization: Bearer test-token"

echo "[Lab02] Testing Prism mock server at $BASE_URL"
echo

echo "[1/5] Happy path: GET /health"
curl -sS -i "$BASE_URL/health"
echo "
---"

echo "[2/5] Happy path: GET /event-contract"
curl -sS -i "$BASE_URL/event-contract" -H "$AUTH_HEADER"
echo "
---"

echo "[3/5] Happy path: POST /sensor-events"
curl -sS -i -X POST "$BASE_URL/sensor-events" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d '{
    "eventType": "sensor.reading.created",
    "eventId": "550e8400-e29b-41d4-a716-446655440001",
    "deviceId": "SENSOR-101",
    "sensorType": "temperature",
    "value": 38.6,
    "unit": "celsius",
    "locationId": "B1-F02-R204",
    "floor": "F02",
    "quality": "NORMAL",
    "occurredAt": "2026-05-18T01:25:00Z",
    "correlationId": "550e8400-e29b-41d4-a716-446655440101",
    "idempotencyKey": "SENSOR-101:2026-05-18T01:25:00Z:temperature",
    "source": "iot-ingestion"
  }'
echo "
---"

echo "[4/5] Happy path: GET /sensor-events/{eventId}"
curl -sS -i "$BASE_URL/sensor-events/550e8400-e29b-41d4-a716-446655440001" -H "$AUTH_HEADER"
echo "
---"

echo "[5/5] Error case: POST /sensor-events invalid payload"
curl -sS -i -X POST "$BASE_URL/sensor-events" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -H "Prefer: code=400" \
  -d '{ "eventType": "sensor.reading.created", "deviceId": "BAD" }'
echo
