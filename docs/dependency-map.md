# Smart Campus Dependency Map

Dưới đây là bản đồ phụ thuộc đầy đủ (10 cặp) cho hệ thống Smart Campus.
Mỗi cặp được ký hiệu là: Consumer -> Provider — giao tiếp sync (REST) cho Lab 02, và async (Queue) cho Lab 03.

1. Student Service -> Access Control Service — REST (Lab 02); Queue (Lab 03)
2. Access Control Service -> Camera Service — REST (Lab 02); Queue (Lab 03)
3. Camera Service -> Camera AI/Recognition Service — REST (Lab 02); Queue (Lab 03)
4. Camera AI/Recognition Service -> Analytics Service — REST (Lab 02); Queue (Lab 03)
5. IoT Gateway -> IoT Core Service — REST (Lab 02); Queue (Lab 03)
6. IoT Core Service -> Sensor Data Store — REST (Lab 02); Queue (Lab 03)
7. Notification Service -> Email/SMS Provider — REST (Lab 02); Queue (Lab 03)
8. Core API (Business) -> Policy/Authorization Service — REST (Lab 02); Queue (Lab 03)
9. Analytics Service -> Data Warehouse / Reporting — REST (Lab 02); Queue (Lab 03)
10. Access Core -> Notification Service — REST (Lab 02); Queue (Lab 03)

Ghi chú:
- Lab 01: sinh viên hoàn thiện `service-boundary.md` (rõ ràng consumer/provider và các tài nguyên).
- Lab 02: chuyển từng `service-boundary` thành hợp đồng API (`openapi.yaml`) cho giao tiếp REST sync.
- Lab 03: bổ sung cơ chế async (message queue) cho các luồng cần decoupling.

Hướng dẫn ngắn cho sinh viên:
- Chọn một cặp đàm phán (Consumer/Provider) từ danh sách trên.
- Consumer và Provider phải đàm phán trước khi author OpenAPI.
- Đảm bảo các endpoint, schema, và responses được nêu rõ trong `openapi.yaml`.
