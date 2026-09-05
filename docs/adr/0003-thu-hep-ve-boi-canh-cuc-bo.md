# ADR-0003: Thu hẹp SPEC-AI-100 về bối cảnh thật — hai hồ sơ ngăn xếp, phạm vi nội bộ, mức tự chủ L2

- **Trạng thái:** Đã chấp nhận
- **Ngày:** 2026-09-05
- **Liên quan:** `docs/adr/0002-ai-harness-architecture.md` (điều chỉnh quyết định 4 và 7 của ADR đó),
  `docs/specs/AI-HARNESS-AND-COMPANY-SPEC.md` §A4.6.3 · §A11.1 · §B11 · §C2.4

## Bối cảnh

ADR-0002 để trạng thái **Đề xuất** với lý do ghi thẳng trong file: *chờ người dùng chốt 12 câu hỏi ở §C2.4*.
Ngày 2026-09-05 đã chốt xong 11/12 câu — **sáu câu trả lời bằng cách đọc code** repo `Claude-Agents`
(`main` = `1b34ac3`) thay vì hỏi người, bốn câu do người quyết, một câu (ngưỡng phân làn) đang là đề xuất.

Việc dò code làm lộ một mâu thuẫn mà lúc viết ADR-0002 chưa ai thấy:

| ADR-0002 giả định | Thực tế trong repo |
|---|---|
| PostgreSQL + pgvector làm nguồn sự thật | **SQLite** — sqlite_bus.py ở cả `software-company` và `Studio-creators` |
| Temporal cho vòng ngoài bền | Không có; luồng chạy trong một tiến trình |
| LangGraph cho vòng trong | Route tường minh trong orchestrator.ROUTES |
| OPA/Cedar cho chính sách | Hàm trong tiến trình — `Toolbox._path`, `write_scope` |
| gVisor/Firecracker cho sandbox | `subprocess` + hạn chế đường ghi |
| Mua token qua API | **Gói đăng ký**, giá 0, ràng buộc là quota mỗi tài khoản (ADR-0019 của repo đó) |

Không có `Dockerfile`, `docker-compose` hay `.tf` nào trong repo; gateway lắng nghe `127.0.0.1`.
Nói cách khác: ADR-0002 mô tả một hệ thống nhiều máy, còn thứ đang được xây chạy trên **một máy**.

## Quyết định

1. **Tách đôi đặc tả.** Nguyên tắc (P1–P12, ranh giới tin cậy, Tool Gateway, event sourcing, các cổng)
   **giữ nguyên ở Phần A** — chúng đúng ở mọi quy mô. Lựa chọn công nghệ tách thành hai hồ sơ ở §A11.1:
   **A11.1.a CỤC BỘ (đang áp dụng)** và **A11.1.b ĐÁM MÂY (đích)**, kèm **điều kiện chuyển** tường minh.
   ⇒ Quyết định 4 và 7 của ADR-0002 từ nay đọc là **hồ sơ đám mây**, không phải bản dựng hôm nay.
2. **Ba thứ không được cắt ở bất kỳ hồ sơ nào:** Tool Gateway (điểm nghẽn duy nhất ra ngoài) ·
   event log append-only (nguồn sự thật) · eval có cổng trong CI (phát hiện trôi). Cả ba đã có sẵn.
3. **Use case đầu tiên: `software-company`.** Ba chỉ số neo vào đó: lead time ticket, `review_catch_rate`,
   tỉ lệ `tests_red_as_expected`. Các package còn lại **không** đặt SLO trong giai đoạn này.
4. **Phạm vi tuân thủ: nội bộ, tự dùng.** Nghĩa vụ EU AI Act không gắn vào hệ thống này; §A4.6.3 thu về
   một ghi chú tham khảo **kèm điều kiện làm nó hết hiệu lực**. Minh bạch + kiểm toán vẫn giữ.
5. **Mức tự chủ mục tiêu 6 tháng: L2**, không nhắm L3.
6. **Ngưỡng "làn nhanh" là một vị từ kiểm được bằng máy, mặc định fail closed** (định nghĩa đầy đủ ở
   SPEC-AI-100 §B3.1a): hợp lấy giao của 5 điều kiện — không chạm `SECRET_FILES`/schema/`gateway/` ·
   `risk_tags` rỗng · ≤ 1 package · ≤ 150 dòng · có test phủ nhánh sửa và CI xanh. Ba nhóm **luôn** là làn
   kiến trúc bất kể kích thước: xác thực/phân quyền, thanh toán, mật mã.

## Lý do

**Vì sao tách đôi chứ không xoá hẳn phần đám mây.** Ba lối đi đã cân nhắc (§C2.4). Thu hẹp hẳn là rẻ nhất
nhưng vứt mất phần tham chiếu, mà điều kiện chuyển sang nhiều máy là chuyện có thật chứ không viển vông:
chỉ cần chạy mã do người ngoài gửi là bắt buộc phải có sandbox mức nhân. Giữ nguyên thì không tốn công sửa
nhưng mỗi lần đọc lại phải tự dịch sang hiện trạng — và người đọc sau (kể cả một phiên AI mới) rất dễ đi
dựng PostgreSQL cho một hệ thống chạy SQLite. Tách đôi trả giá bằng một lần sắp xếp lại, đổi lấy việc
**không ai còn đọc nhầm bản vẽ tương lai thành bản dựng hôm nay**.

**Vì sao ghi thẳng điểm yếu của hồ sơ cục bộ.** `subprocess` + hạn chế đường ghi **không** phải cách ly mức
nhân. Chấp nhận được vì mã chạy là của chính mình; **không** chấp nhận được nếu chạy mã người ngoài gửi.
Ghi ra để nó là một đánh đổi có ý thức, không phải một lỗ hổng bị bỏ quên.

**Vì sao nội bộ thì cắt phần rủi ro cao chứ không "thiết kế sẵn cho chắc".** ADR-0002 nói hồ sơ rủi ro cao
"phải thiết kế sẵn vì bổ sung sau rất tốn kém". Đúng khi biết chắc sẽ cần. Ở đây không có khách trả tiền và
không chạm EU, nên đó là chi phí không có người trả. Thứ thay thế rẻ hơn nhiều: một **điều kiện kích hoạt**
ghi rõ trong §A4.6.3, để lúc có khách đầu tiên thì biết phải bật cái gì.

**Vì sao ngưỡng làn nhanh phải fail closed, và vì sao có ngoại lệ cứng.** Ở L2, đây là ranh giới agent tự
merge mà **không ai xem trước** — nên một điều kiện "không đánh giá được" phải tính là trượt, chứ không phải
bỏ qua. Ngoại lệ cứng cho xác thực/thanh toán/mật mã không phải điều kiện thứ sáu mà là một loại khác: hậu
quả sai ở ba nhóm đó **không tỉ lệ với kích thước diff**. Một dòng sửa sai trong kiểm tra quyền là một lỗ
hổng, dù diff chỉ một dòng — nên không có ngưỡng dòng nào bảo vệ được, chỉ có "luôn có người".
Ngưỡng 150 dòng chọn theo **dung lượng đọc của người**, không theo độ khó; nó là con số đầu tiên, kèm sẵn
điều kiện xem lại sau 4 tuần và quy tắc nới **chỉ được nới số dòng**, không được bỏ điều kiện hay ngoại lệ.

**Vì sao L2 chứ không L3.** Điều kiện vào L3 là *8 tuần ở L2 với `change_failure_rate` ≤ đường cơ sở*.
Đường cơ sở mới bắt đầu đo tiến cứu từ T0 = 05/09 (đường cơ sở hồi cứu **không tồn tại** — xem
`docs/ops/BASELINE-2026-09-04-claude-agents.md`). Nhắm L3 lúc này là nhắm vào một ngưỡng chưa tồn tại.

## Các phương án đã cân nhắc

- **Thu hẹp hẳn về cục bộ, xoá phần đám mây.** Rẻ nhất, khớp hiện trạng 100%. Không chọn: mất phần tham
  chiếu cho lúc vượt một máy, và điều kiện vượt là chuyện thật.
- **Giữ nguyên ADR-0002 làm kiến trúc đích, không sửa gì.** Không tốn công. Không chọn: người đọc sau phải
  tự dịch sang hiện trạng mỗi lần, và đó đúng là kiểu nhầm lẫn tốn kém nhất.
- **Viết lại ADR-0002.** Không chọn vì trái quy ước của khung: không sửa ADR cũ, đổi ý thì viết ADR mới.

## Hệ quả

- **Tích cực:** đặc tả dùng được ngay mà không phải dựng thêm hạ tầng nào; ba thứ cốt lõi đã có sẵn trong repo.
- **Phải làm để L2 có nghĩa:** ngưỡng làn nhanh **đã chốt ở §B3.1a nhưng CHƯA thực thi** — phải cài vào chỗ
  chọn người review của `Claude-Agents` (`BASE_REVIEWS`/`RISK_REVIEWS`); cho tới lúc đó mọi thay đổi vẫn đi
  làn chuẩn, đúng mặc định fail closed. Kèm theo: đếm `first_pass_gate_rate` và số lần merge làn nhanh liên
  tiếp không lỗi lọt; giữ đường lùi tự động về L1 khi có lỗi lọt nghiêm trọng.
- **Nợ để lại:** hồ sơ cục bộ không có cách ly mức nhân. Ghi ở §A11.1.a. Phải xử lý trước khi chạy mã bên ngoài.
- **Điều kiện đọc lại ADR này:** có khách trả tiền hoặc người dùng EU · cần nhiều worker/nhiều máy ·
  có tenant thứ hai · phải chạy mã do người ngoài gửi.
