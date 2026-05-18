# Checklist Lab 02

- [x] Da xac dinh dung cap dam phan: #5 IoT Ingestion -> Core Business.
- [x] Da doc dung user story: `user-stories/pair-05-iot-core-async.md`.
- [x] Provider da dien `docs/analysis-provider.md`.
- [x] Consumer da dien `docs/analysis-consumer.md`.
- [x] `openapi.yaml` khai bao `openapi: 3.1.0`.
- [x] Co toi thieu 4 path: `/health`, `/sensor-events`, `/sensor-events/recent`, `/sensor-events/{eventId}`, `/event-contract`.
- [x] Moi operation co `operationId`, `summary`, `description`, `tags`.
- [x] Schema lon da dua vao `components/schemas`.
- [x] Co `oneOf` + `discriminator` cho `SensorEvent`.
- [x] Co union type voi `null`, khong dung `nullable: true`.
- [x] Co `Problem` schema cho response loi.
- [x] `spectral lint` khong co severity error.
- [x] Da luu `evidence/buoi-02/spectral-report.txt`.
- [x] Prism mock server chay duoc o port 4010.
- [x] Co 5 anh request mau trong `mock-screenshots/`.
- [x] `negotiation-log.md` co toi thieu 6 issue.
- [x] Co sign-off Provider, Consumer, Witness.
- [x] Da hoan thien `VERSIONING.md` cho bai tap ve nha.

Ghi chu Lab 02:
- Lab 02 noi tiep Lab 01: chuyen service boundary thanh `openapi.yaml`.
- Da tham chieu dependency map/pairing matrix de chon cap dam phan #5.
