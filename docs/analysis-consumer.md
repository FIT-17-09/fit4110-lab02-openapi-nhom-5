# Consumer Analysis - Pair 03 Core Business to Access Gate

- Pair: #3 Core Business -> Access Gate
- Product: Smart Campus Operations Platform
- Consumer service: Core Business
- Provider service: Access Gate
- Author: Group 5
- Date: 2026-05-18

---

## 1. Resources Consumer Needs

| Resource | Consumer uses it for | Required fields for Consumer | Optional fields |
|---|---|---|---|
| `AccessLog` | Audit lịch sử quẹt thẻ và kiểm tra hoạt động ra/vào. | `logId`, `cardId`, `gateId`, `direction`, `timestamp`, `status` | `operatorNote`, `reasonCode` |
| `GateStatus` | Kiểm tra trạng thái cổng trước khi xử lý policy. | `gateId`, `status`, `lastHeartbeat` | `location`, `activeAlarm` |
| `CardInfo` | Xác minh trạng thái thẻ truy cập. | `cardId`, `ownerId`, `cardStatus` | `expiresAt`, `cardType` |
| `Problem` | Chuẩn hóa xử lý lỗi API. | `type`, `title`, `status` | `detail`, `instance` |

---

## 2. API Consumer Needs

| Method | Path | When used | Expected response |
|---|---|---|---|
| GET | `/access/logs/recent` | Core Business cần lấy log mới nhất để audit. | `200` với danh sách `AccessLog`. |
| GET | `/access/logs/{logId}` | Truy vấn chi tiết một log cụ thể. | `200` với `AccessLog` hoặc `404 Problem`. |
| GET | `/gates/{gateId}/status` | Kiểm tra trạng thái cổng realtime. | `200` với `GateStatus`. |
| GET | `/cards/{cardId}` | Kiểm tra trạng thái thẻ người dùng. | `200` với `CardInfo`. |
| GET | `/health` | Kiểm tra service hoạt động. | `200` với `HealthStatus`. |

---

## 3. Error Cases Consumer Must Handle

| Status | Consumer interpretation | Consumer action |
|---:|---|---|
| 400 | Request sai schema hoặc path param invalid. | Ghi log lỗi và sửa request. |
| 401 | Thiếu hoặc sai token. | Refresh hoặc cấu hình lại token. |
| 403 | Không có quyền đọc dữ liệu access gate. | Báo lỗi quyền truy cập. |
| 404 | Không tìm thấy log, gate hoặc card. | Hiển thị trạng thái không tồn tại. |
| 409 | Dữ liệu đang conflict hoặc cập nhật. | Retry request với backoff. |
| 422 | Dữ liệu hợp lệ JSON nhưng sai rule nghiệp vụ. | Hiển thị lý do cụ thể cho operator. |
| 500 | Access Gate lỗi nội bộ hoặc timeout. | Retry và cảnh báo monitoring. |

---

## 4. Consumer Assumptions

- `direction` luôn dùng `IN` hoặc `OUT`.
- `status` của access log hỗ trợ `ALLOW`, `DENY`, `ERROR`.
- `cardStatus` hỗ trợ `ACTIVE`, `BLOCKED`, `EXPIRED`.
- `operatorNote` có thể null.
- Core Business chỉ dùng API để đọc/audit, không thay đổi dữ liệu gate.

---

## 5. Questions For Provider

1. Access log sẽ lưu bao lâu trước khi archive?
2. `/access/logs/recent` có giới hạn số lượng record không?
3. Khi gate offline thì `status` trả giá trị gì?

---

## 6. Integration Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Enum direction khác nhau giữa hai service. | Parse lỗi hoặc audit sai. | Chuẩn hóa enum `IN/OUT`. |
| Card status không đồng bộ. | Policy decision sai. | Chốt enum card status trong contract. |
| Access log trả quá nhiều dữ liệu. | Consumer timeout hoặc chậm. | Giới hạn page size mặc định. |
| Timestamp khác timezone. | Audit sai thời gian thực tế. | Dùng ISO-8601 UTC cho tất cả timestamp. |