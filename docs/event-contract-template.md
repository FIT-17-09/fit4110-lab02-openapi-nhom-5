# Event Contract sơ bộ — Pair 09 Access Gate to Analytics

## 1. Thông tin dependency

- Dependency số: 09
- Producer: Access Gate
- Consumer: Analytics
- Cơ chế: Queue async
- Event/topic dự kiến: `access.events.v1`
- Người ghi: Group 5
- Ngày: 2026-05-18

## 2. Mục đích nghiệp vụ

Access Gate publish log ra/vào để Analytics thống kê lưu lượng, giờ cao điểm và tỷ lệ deny.

## 3. Event name / topic

| Mục | Giá trị |
|---|---|
| Event name | `access.log.created` |
| Topic/queue | `access.events.v1` |
| Producer | `Access Gate` |
| Consumer | `Analytics` |

| Mục | Giá trị |
|---|---|
| Event name | `access.denied` |
| Topic/queue | `access.events.v1` |
| Producer | `Access Gate` |
| Consumer | `Analytics` |

## 4. Payload tối thiểu

```json
{
  "eventId": "uuid",
  "eventType": "access.log.created",
  "occurredAt": "2026-05-18T08:30:00Z",
  "correlationId": "uuid",
  "source": "access-gate",
  "data": {
    "cardId": "RFID-001",
    "gateId": "GATE-01",
    "direction": "IN",
    "status": "ALLOW"
  }
}