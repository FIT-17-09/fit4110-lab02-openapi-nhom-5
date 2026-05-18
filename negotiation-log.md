# Negotiation Log - Pair 03 Core Business to Access Gate

- Pair: #3 Core Business -> Access Gate
- Product: Smart Campus Operations Platform
- Provider: Access Gate
- Consumer: Core Business
- Session: v1.0
- Date: 2026-05-18

---

## Issue #1 - Direction enum

- Raised by: Consumer
- Endpoint: `/access/logs/recent`
- Concern: Hai bên dùng direction khác nhau (`ENTER/EXIT` vs `IN/OUT`).
- Proposal: Chuẩn hóa enum `IN` và `OUT`.
- Resolution: Accepted
- Rationale: Ngắn gọn và dễ mapping với gate hardware.
- Impact: `direction` trong schema AccessLog dùng enum `IN`, `OUT`.

---

## Issue #2 - Nullable operator note

- Raised by: Provider
- Endpoint: `/access/logs/{logId}`
- Concern: Nhiều log được tạo tự động không có ghi chú operator.
- Proposal: Cho phép `operatorNote` nullable.
- Resolution: Accepted
- Rationale: Tránh ép provider gửi string rỗng.
- Impact: Dùng union type `[string, "null"]`.

---

## Issue #3 - Card status standardization

- Raised by: Consumer
- Endpoint: `/cards/{cardId}`
- Concern: Trạng thái thẻ chưa thống nhất giữa hai nhóm.
- Proposal: Chỉ hỗ trợ `ACTIVE`, `BLOCKED`, `EXPIRED` ở v1.0.
- Resolution: Accepted
- Rationale: Đủ cho access control hiện tại.
- Impact: `cardStatus` dùng enum cố định trong schema.

---

## Issue #4 - Log retention period

- Raised by: Consumer
- Endpoint: `/access/logs/recent`
- Concern: Core Business cần audit lịch sử.
- Proposal: Access Gate giữ log tối thiểu 30 ngày.
- Resolution: Accepted
- Rationale: Phù hợp nhu cầu audit và monitoring.
- Impact: Documented trong contract assumptions.

---

## Issue #5 - Timeout behavior

- Raised by: Consumer
- Endpoint: All endpoints
- Concern: Timeout downstream gây ảnh hưởng realtime.
- Proposal: Timeout tối đa 3 giây cho REST sync.
- Resolution: Accepted
- Rationale: Tránh block Core Business quá lâu.
- Impact: Retry policy sẽ được mở rộng sau Lab 02.

---

## Issue #6 - Health endpoint authentication

- Raised by: Provider
- Endpoint: `/health`
- Concern: Monitoring cần gọi health không cần token.
- Proposal: `/health` không yêu cầu Bearer token.
- Resolution: Accepted
- Rationale: Hỗ trợ monitoring và Prism mock nhanh hơn.
- Impact: `security: []` cho `/health`.

---

# Contract Sign-Off v1.0

Provider sign-off: Access Gate representative - accepted 2026-05-18
Consumer sign-off: Core Business representative - accepted 2026-05-18
Witness (GV/TA): Pending classroom review
Date: 2026-05-18