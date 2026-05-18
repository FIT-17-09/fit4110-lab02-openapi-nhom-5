# Provider Analysis - Pair 03 Core Business to Access Gate

- Pair: #3 Core Business -> Access Gate
- Product: Smart Campus Operations Platform
- Provider service: Access Gate
- Consumer service: Core Business
- Author: Group 5
- Date: 2026-05-18

---

## 1. Main Resources

| Resource | Description | Required fields | Optional fields |
|---|---|---|---|
| `AccessLog` | Log lịch sử quẹt thẻ tại cổng ra/vào. | `logId`, `cardId`, `gateId`, `direction`, `timestamp`, `status` | `operatorNote`, `reasonCode` |
| `GateStatus` | Trạng thái hiện tại của cổng. | `gateId`, `status`, `lastHeartbeat` | `location`, `activeAlarm` |
| `CardInfo` | Thông tin thẻ truy cập. | `cardId`, `ownerId`, `cardStatus` | `expiresAt`, `cardType` |
| `Problem` | Chuẩn lỗi API theo Problem Details. | `type`, `title`, `status` | `detail`, `instance` |

---

## 2. Expected API Surface

| Method | Path | Purpose | Consumer uses it when |
|---|---|---|---|
| GET | `/access/logs/recent` | Trả về danh sách log quẹt thẻ gần nhất. | Core Business cần audit realtime hoặc kiểm tra sự kiện gần đây. |
| GET | `/access/logs/{logId}` | Lấy chi tiết một access log. | Core Business cần truy vết một sự kiện cụ thể. |
| GET | `/gates/{gateId}/status` | Trả về trạng thái hiện tại của gate. | Kiểm tra gate online/offline hoặc lỗi thiết bị. |
| GET | `/cards/{cardId}` | Trả về trạng thái thẻ truy cập. | Kiểm tra thẻ còn hiệu lực hoặc bị khóa. |
| GET | `/health` | Health check service. | Monitoring hoặc Prism mock evidence. |

---

## 3. Error Cases

| Status | Situation | Expected response body |
|---:|---|---|
| 400 | Request sai định dạng hoặc path param không hợp lệ. | `Problem` |
| 401 | Thiếu hoặc sai Bearer token. | `Problem` |
| 403 | Token hợp lệ nhưng không đủ quyền truy cập log/card. | `Problem` |
| 404 | Không tìm thấy log, gate hoặc card. | `Problem` |
| 409 | Dữ liệu gate đang cập nhật hoặc conflict trạng thái. | `Problem` |
| 422 | Request đúng JSON nhưng vi phạm rule nghiệp vụ. | `Problem` |
| 500 | Lỗi nội bộ Access Gate hoặc downstream timeout. | `Problem` |

---

## 4. Provider Assumptions

- `direction` sử dụng enum `IN` và `OUT`.
- Access log được lưu tối thiểu 30 ngày phục vụ audit.
- `cardStatus` hỗ trợ các trạng thái `ACTIVE`, `BLOCKED`, `EXPIRED`.
- `operatorNote` có thể null nếu log được tạo tự động.
- `timestamp` dùng chuẩn UTC ISO-8601.
- Core Business chỉ đọc dữ liệu, không được sửa log hoặc trạng thái gate.

---

## 5. Questions For Consumer

1. Core Business có cần filter log theo khoảng thời gian trong v1.0 không?
2. Consumer có cần pagination cho `/access/logs/recent` không?
3. Card bị `EXPIRED` có xử lý giống `BLOCKED` không?

---

## 6. Integration Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Direction dùng khác enum giữa hai nhóm. | Consumer parse sai dữ liệu. | Chốt enum `IN/OUT` trong `openapi.yaml`. |
| Card status không thống nhất. | Sai quyết định policy hoặc audit. | Chuẩn hóa enum trạng thái thẻ. |
| Access log quá lớn. | Timeout hoặc response chậm. | Giới hạn số lượng log recent và hỗ trợ pagination sau này. |
| Gate offline nhưng không cập nhật trạng thái kịp. | Core Business hiểu sai trạng thái cổng. | Bắt buộc có `lastHeartbeat`. |