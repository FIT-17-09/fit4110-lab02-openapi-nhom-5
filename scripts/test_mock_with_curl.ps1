$ErrorActionPreference = "Stop"

$BaseUrl = if ($env:BASE_URL) { $env:BASE_URL } else { "http://localhost:4010" }
$AuthHeader = "Authorization: Bearer test-token"

Write-Output "[Lab02] Testing Prism mock server at $BaseUrl"
Write-Output ""

$ValidPayloadPath = Join-Path $env:TEMP "lab02-sensor-event-valid.json"
$InvalidPayloadPath = Join-Path $env:TEMP "lab02-sensor-event-invalid.json"

Write-Output "[1/5] Happy path: GET /health"
curl.exe -sS -i "$BaseUrl/health"
Write-Output "`n---"

Write-Output "[2/5] Happy path: GET /event-contract"
curl.exe -sS -i "$BaseUrl/event-contract" -H $AuthHeader
Write-Output "`n---"

Write-Output "[3/5] Happy path: POST /sensor-events"
@'
{
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
}
'@ | Set-Content -Encoding ascii -Path $ValidPayloadPath
curl.exe -sS -i -X POST "$BaseUrl/sensor-events" -H $AuthHeader -H "Content-Type: application/json" --data-binary "@$ValidPayloadPath"
Write-Output "`n---"

Write-Output "[4/5] Happy path: GET /sensor-events/{eventId}"
curl.exe -sS -i "$BaseUrl/sensor-events/550e8400-e29b-41d4-a716-446655440001" -H $AuthHeader
Write-Output "`n---"

Write-Output "[5/5] Error case: POST /sensor-events invalid payload"
@'
{ "eventType": "sensor.reading.created", "deviceId": "BAD" }
'@ | Set-Content -Encoding ascii -Path $InvalidPayloadPath
curl.exe -sS -i -X POST "$BaseUrl/sensor-events" -H $AuthHeader -H "Content-Type: application/json" -H "Prefer: code=400" --data-binary "@$InvalidPayloadPath"
Write-Output ""

Remove-Item -Force -ErrorAction SilentlyContinue $ValidPayloadPath, $InvalidPayloadPath
