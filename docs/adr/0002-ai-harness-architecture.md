# ADR-0002: Kiến trúc & ngăn xếp tham chiếu cho AI Harness

- **Trạng thái:** Đề xuất *(chờ người dùng chốt 8 câu hỏi ở SPEC-AIH-001 §13.3)*
- **Ngày:** 2026-09-04
- **Liên quan:** `docs/specs/AI-HARNESS-SPEC.md` (SPEC-AIH-001), KHUNG-3 (research-first), CLAUDE.md §3, §9

## Bối cảnh

Cần xây một **AI harness** — lớp xác định bao quanh model để đưa AI agent vào môi trường doanh nghiệp,
theo mô hình 7 cấu phần (Context · Tool · Orchestration · Evaluation · Security · Governance · AgentOps).

Ràng buộc:
- Model là thành phần **không xác định**; mọi bảo đảm về an toàn, chi phí và chất lượng phải nằm ở lớp bao quanh.
- Rủi ro số 1 của agent năm 2026 là **prompt injection / goal hijack** (OWASP ASI01) — không thể chặn bằng prompt.
- Nghĩa vụ **minh bạch và giám sát** theo EU AI Act Điều 50 đã có hiệu lực từ 02/08/2026; nghĩa vụ rủi ro cao
  (Phụ lục III) lùi tới 02/12/2027 nhưng phải thiết kế sẵn.
- Hệ sinh thái còn chuyển động: quy ước OpenTelemetry GenAI cho span agent **vẫn thử nghiệm**;
  đặc tả MCP vừa đổi lớn ở bản 2026-07-28 (lõi stateless).

## Quyết định

1. **Vòng lặp ngoài do harness sở hữu, là code xác định.** Model đề xuất hành động; harness quyết định
   có chạy hay không, chạy bao nhiêu bước, dừng khi nào.
2. **Event sourcing append-only (`run_events`) làm nguồn sự thật duy nhất**, có hash chain.
   Evaluation, Governance và AgentOps đều đọc từ đây thay vì tự dựng log riêng.
3. **Tool Gateway là điểm nghẽn duy nhất** cho mọi tác động ra ngoài, với chuỗi 9 bước cố định
   (schema → authz OBO → policy → hạn mức → HITL → sandbox → lọc đầu ra → ghi sự kiện).
4. **Kiến trúc hai tầng điều phối:** workflow bền (Temporal) cho vòng ngoài dài hạn + agent graph
   (LangGraph) cho vòng trong suy luận-gọi công cụ.
5. **Ngăn xếp tham chiếu** (đã xác minh phiên bản qua PyPI/npm ngày 2026-09-04):
   Python + FastAPI 0.141.1 + Pydantic 2.13.5 · LangGraph 1.2.11 · temporalio 1.32.0 ·
   MCP spec 2026-07-28 (SDK `mcp` 2.1.1) · OpenTelemetry SDK 1.44.0 · Langfuse 4.15.1 *hoặc*
   Arize Phoenix 20.7.0 · DeepEval 4.2.1 · PostgreSQL + pgvector · OPA/Cedar · gVisor/Firecracker.
6. **Định tuyến model:** `claude-opus-5` cho lập kế hoạch, `claude-sonnet-5` cho thực thi,
   `claude-haiku-4-5` cho việc phụ; ưu tiên hạ `effort` trên model mạnh trước khi hạ cấp model
   (đổi model làm mất tái dùng cache).
7. **Không có eval thì không deploy:** cổng CI ba tầng (đơn vị · quỹ đạo · kết quả) + red team
   ánh xạ ASI01–ASI10, judge phải hiệu chuẩn với nhãn người (κ ≥ 0.6).

## Lý do

- **Vòng lặp xác định (1)** là điều kiện cần của cả ba thứ doanh nghiệp đòi hỏi: đo được, chặn được,
  tái hiện được. Để model tự quyết vòng lặp thì không có cái nào đạt.
- **Event sourcing (2)** khiến "gỡ lỗi", "đánh giá" và "kiểm toán" trở thành **ba khung nhìn của một dữ liệu**
  thay vì ba hệ thống rời — giảm mạnh chi phí xây và giữ nhất quán.
- **Một cổng duy nhất (3)** là cách duy nhất khiến câu "least privilege" thành hiện thực kiểm chứng được:
  có thể chứng minh bằng test chặn egress rằng không tồn tại đường vòng.
- **Hai tầng điều phối (4)**: LangGraph mạnh ở vòng lặp có chu trình và checkpoint theo bước nhưng không
  thay được một workflow engine cho tiến trình nhiều ngày, chờ người, có bù trừ; Temporal thì ngược lại.
  Mẫu ghép này đang là mẫu production phổ biến năm 2026.
- **Ngăn xếp (5)** cân bằng độ phổ biến ↔ năng lực (KHUNG-3 §B2): mọi thành phần đều có bản mã nguồn mở
  tự host được, tránh khoá cứng ở tầng dữ liệu và tầng quan sát.
- **Định tuyến model (6)** phản ánh dữ kiện giá thực tế và đặc tính cache theo model.

## Các phương án đã cân nhắc

- **A. Dùng một khung agent "trọn gói" (all-in-one) làm luôn cả eval/observability/policy.**
  Nhanh lúc đầu; nhược: khoá cứng, khó thay từng mảnh, phần bảo mật thường chỉ là guardrail bằng model —
  không đạt P1. Không chọn.
- **B. Chỉ dùng LangGraph, bỏ workflow bền.** Đơn giản hơn; nhược: run dài/chờ người không sống sót
  qua restart, không có bù trừ chuẩn. **Chấp nhận được cho đội nhỏ, 1 use case** (ghi ở SPEC §11.3),
  không chọn làm mặc định.
- **C. Guardrail dựa trên model làm hàng rào chính.** Rẻ, dễ; nhược: bộ phân loại có tỉ lệ lọt,
  và chính nó cũng bị injection. Chỉ dùng làm **vòng 1/vòng 4** giảm nhiễu, không làm hàng rào.
- **D. Toàn TypeScript.** Hợp nếu đội thuần TS; nhược: hệ sinh thái eval mỏng hơn ⇒ tự xây nhiều hơn.
  Giữ làm phương án thay thế, chờ câu trả lời §13.3 câu 2.

## Hệ quả

**Tích cực**
- Một run bất kỳ có thể dựng lại sau nhiều tháng: cấu hình, ngữ cảnh, quyết định, người duyệt.
- Thay model/nhà cung cấp/backend quan sát không đụng mã nghiệp vụ.
- Bảo mật là thuộc tính kiến trúc (một cổng, quyền theo bước), không phải câu chữ trong prompt.

**Đánh đổi phải chấp nhận**
- Chi phí xây ban đầu cao hơn "gọi thẳng API model": phải có M1 (gateway) và M3 (eval) trước khi có giá trị rõ.
- Thêm một điểm phụ thuộc vận hành (workflow engine) — cần người biết vận hành nó.
- Phụ trội độ trễ ~150 ms/lượt do các lớp kiểm tra.
- Quy ước OTel GenAI còn đổi ⇒ phải duy trì một lớp adapter.

**Việc cần làm tiếp**
1. Người dùng chốt 8 câu hỏi ở SPEC-AIH-001 §13.3 (đặc biệt: use case đầu tiên, ngôn ngữ, phạm vi tuân thủ).
2. Mở tài liệu gốc OWASP Agentic Top 10 để xác nhận nguyên văn ASI01–ASI10 (phiên này bị egress proxy chặn).
3. Xác minh lại phiên bản Python/PostgreSQL/Redis/OPA/sandbox bằng nguồn sống khi khởi tạo dự án.
4. Chạy `/bootstrap` dựng nền theo mốc M0 sau khi ADR này được chấp nhận.
