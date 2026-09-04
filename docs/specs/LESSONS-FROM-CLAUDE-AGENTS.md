# TỔNG HỢP ĐIỂM TỐT — repo `seeker19110/Claude-Agents` (X-Agents)

> **Mã:** SYNTH-001 · **Ngày:** 2026-09-04 · **Đọc tại commit** `a3544c1`
> **Đối tượng đọc:** người đang xây theo `docs/specs/AI-HARNESS-SPEC.md` (SPEC-AIH-001) và
> `docs/specs/AI-SOFTWARE-COMPANY-SPEC.md` (SPEC-ASC-002).
> **Mục đích:** rút cơ chế đáng học từ một triển khai **đã chạy thật**, nạp ngược vào hai đặc tả,
> và nói rõ chỗ nào đặc tả đã sai.

---

## 0. Đã đọc gì

| Thành phần | Quy mô (theo README + kiểm đếm file) |
|---|---|
| `software-company/` | 20 agent · 45 skill · 18 topic có JSON Schema · 14 template · 5 loại human gate · ADR 0001–0025 |
| `Studio-creators/` | 14 agent · 24 skill · 19 topic · 4 human gate · ADR 0001–0008 — **cùng bộ khung, khác lĩnh vực** |
| `gateway/` | Proxy OpenAI-compatible cục bộ, xoay vòng nhiều tài khoản |
| `console/` | Trực ban hợp nhất, chỉ đọc mặc định |
| Đã đọc kỹ | `docs/architecture.md`, `gates/checklists.md`, `topics/README.md`, `docs/DIEU-PHOI-MODEL.md`, ADR 0008/0010/0012/0015/0016/0020/0021/0022, `agents/quality/reviewer.md`, `skills/code-review.md`, `gates.py`, `stacks.py`, `evals/` |

---

## 1. Kết luận trong năm câu

1. Repo này **đã đi xa hơn SPEC-ASC-002 ở tầng cơ chế**: những thứ đặc tả của tôi mô tả bằng lời
   ("hợp đồng bàn giao", "cổng", "phân quyền") thì ở đây là **JSON Schema được bus từ chối nếu sai**,
   là **PermissionError trong `gates.py`**, là **job CI đỏ**.
2. Phát hiện đắt giá nhất: **bằng chứng chất lượng phải do CODE điền, không phải model khai** — một
   nguyên tắc mà đặc tả của tôi **vi phạm** (§3.1).
3. Repo có ba tầng mà đặc tả tôi **không có**: **tầng skill** tách khỏi agent, **blackboard có chủ theo
   namespace**, và **quét tài sản prompt của chính repo** như một chuỗi cung ứng.
4. Repo giải bài toán chi phí theo hướng khác hẳn: **chạy bằng gói đăng ký, không mua token** — làm
   toàn bộ §8 của SPEC-ASC-002 (tính giá theo token API) trở thành một trong hai lựa chọn, không phải mặc định.
5. Ngược lại, hai luật mạnh nhất của SPEC-ASC-002 — **test viết mù từ spec (L2)** và **reviewer không đọc
   lời biện hộ của coder (L3)** — repo chưa có, và ADR-0021 vừa làm rủi ro đó tăng lên (§4).

---

## 2. Mười tám điểm tốt

### Nhóm A — Hợp đồng được máy cưỡng chế

**A1. Topic có JSON Schema, bus từ chối message sai.**
18 file trong `topics/schemas/`, bus validate trước khi ghi. Bảng route trong `orchestrator.py` **phải khớp
front matter `reads`/`writes`** của agent, kiểm ngay lúc khởi tạo, và có test đối chiếu.
→ *Vì sao đắt giá:* hợp đồng bàn giao viết bằng YAML trong tài liệu thì trôi sau ba tháng; hợp đồng là schema
thì không trôi được. Đây là hiện thực đúng nghĩa của §5 SPEC-ASC-002.
→ **Nạp vào:** ASC §5 — mọi artifact phải có schema máy đọc + test nhất quán registry↔front matter.

**A2. Blackboard có chủ theo namespace.**
`shared-context` chia namespace (`prd`, `threat-model`, `api-contract`, `schema`, `infra`, `knowledge`,
`contract`…); **mỗi namespace đúng một agent được ghi, ai cũng đọc**. Bảng `NAMESPACE_OWNERS` là nguồn sự thật,
test kiểm khớp với front matter.
→ *Vì sao đắt giá:* đặc tả của tôi chỉ phân quyền **ghi file/branch**. Còn thiếu phân quyền **ghi tri thức** —
mà tri thức sai lan xa hơn code sai. Chi tiết hay: `api-contract` do delivery-lead khởi tạo, các version sau
do backend cập nhật — quyền sở hữu **đổi theo giai đoạn**, không cố định.

**A3. Key = ticket ID, message cùng ticket đi cùng partition, giữ thứ tự.**
→ Giải quyết đúng cái mà "concurrent modification và merge conflict" gây ra trong hệ đa agent.

### Nhóm B — Bằng chứng, không phải lời khai

**B1. `verified_by: workspace` — bằng chứng do code điền.** *(ADR-0010 — điểm tốt nhất của repo)*
Sau vòng tool, runner chạy lint/test **thật** trên worktree, commit, rồi **ghi đè** `branch`, `pr_ref`,
`local_checks`, `impact.files`. Model khai gì ở các trường đó cũng bị thay. Worktree không đổi ⇒ `invalid_output`
(không có PR rỗng). Không có `--repo` ⇒ `local_checks = {"unverified": true}` — **nói thẳng là chưa kiểm chứng
thay vì giả vờ xanh**.
→ *Vì sao đắt giá:* trước ADR-0010, hệ thống "sinh ra bằng chứng chất lượng giả — tệ hơn là không có tính năng".
Câu đó đáng dán lên tường.

**B2. Kiểm tra theo stack thật.** *(`stacks.py`)*
`run_checks` từng cứng `ruff` + `pytest`, nên PR của frontend/mobile/platform mang `local_checks` do một lệnh
**không liên quan đến code của họ** sinh ra. Nay tự nhận stack; không nhận ra stack nào thì nói thẳng là không
chạy được.
→ *Vì sao đắt giá:* một cổng xanh sai còn nguy hiểm hơn không có cổng.

**B3. Eval ghi/phát lại, bắt buộc, chạy offline.** *(ADR-0010, ADR-0015)*
`evals/recordings/*.json` + `REQUIRED.txt`. CI chạy `evals all --replay --strict` **không gọi model**.
Agent có tên trong danh sách mà thiếu bản ghi, **hoặc bản ghi tạo ở phiên bản prompt cũ hơn agent hiện tại**,
thì CI đỏ. Tại commit đã đọc, danh sách có **đủ 20 agent**, ghi ngày 2026-09-03 bằng model thật.
→ *Vì sao đắt giá:* đây là cách duy nhất tôi thấy khiến luật "đổi prompt phải chạy eval" **được máy cưỡng chế**
mà không đốt tiền model trong CI. SPEC-ASC-002 §9.5 chỉ nói "cổng CI" — không có cơ chế này thì cổng đó là lời hứa.

**B4. Golden test cho prompt.** Job `golden-check` chạy `make golden` rồi `git diff --exit-code`: đổi agent/skill
mà quên tái sinh snapshot ⇒ CI đỏ. Prompt trở thành thứ **nhìn thấy được trong diff**.

### Nhóm C — Tài sản prompt là bề mặt tấn công

**C1. `assetscan` — quét chính `agents/ skills/ templates/ gates/ topics/`.** *(ADR-0022)*
Lập luận trong ADR sắc: `guard.py` canh **dữ liệu chạy qua**, nhưng không bao giờ nhìn thứ **đứng trước nó
trong prompt**. Một chuỗi "bỏ qua hướng dẫn trước" trong payload chỉ hỏng một event; cùng chuỗi ấy nằm trong
`skills/testing.md` thì hỏng **mọi agent nạp skill đó, ở mọi ticket, mãi mãi** — và nó vào repo theo đúng đường
hợp lệ: một PR, một merge, một đoạn copy từ tài liệu ngoài.
Bốn rule nặng: `injection` (**dùng chung `guard.PATTERNS` — một nguồn sự thật cho cả hai lớp**), `hidden-char`
(zero-width, bidi override, file không phải UTF-8 — *mắt người không thấy trong diff*), `dangerous-command`,
`secret-literal`; một rule cảnh báo `remote-fetch`.
Waiver **bắt buộc có lý do**, và waiver không còn khớp gì thì bị báo `waiver-unused` để dọn.
→ **Đây là lỗ hổng thật trong SPEC-AIH-001:** đặc tả của tôi chỉ nói ghim hash máy chủ MCP **bên thứ ba** (ASI04),
không hề nói tới tài sản prompt của **chính mình**.

**C2. Ngân sách prompt tĩnh là một cổng CI.** `assetscan budget` so prompt tĩnh (thân agent + toàn văn skill)
với `budget_tokens_per_task` khai trong front matter; **vượt 50% là đỏ**; skill khai mà không tồn tại cũng đỏ.

**C3. Chính sách chống injection phân biệt theo nguồn.** *(`guard.py`)*
Payload từ **agent nội bộ** khớp mẫu ⇒ **từ chối chạy**. Payload từ **khách/người dùng/web** hoặc trường không
tin cậy (`diff`, `text`) ⇒ **thay đoạn khớp bằng nhãn rồi đi tiếp**, ghi audit `injection_sanitized`.
→ *Vì sao đắt giá:* ADR-0012 ghi thẳng sai lầm cũ: "phản hồi của khách chứa lệnh thì bị từ chối xử lý, **trong khi
đó chính là việc phải làm**". Nhãn `untrusted` một-kích-cỡ của tôi (C1-FR-06) không đủ tinh: cùng mức tin cậy
nhưng **hành động khác nhau** tuỳ nguồn.

**C4. Kết quả tool cũng là dữ liệu ngoài.** `guard.sanitize_tool_output`: `read_file`/`search`/`run` trả nội dung
repo khách nên đi qua **đúng bộ lọc injection như web** — cả trong vòng tool của runner lẫn qua cầu MCP.

### Nhóm D — Ngữ cảnh và chi phí, đo bằng số thật

**D1. Tầng skill tách khỏi agent, nạp hai mức.** *(ADR-0008)*
Số đo thật: 38 skill ở mức đầy đủ ⇒ system prompt **~524.000 ký tự (~175.000 token)**; một ticket qua 6 agent
tốn **~60.000 token system prompt trước khi đọc dòng dữ liệu nào**. Nguyên nhân không phải số agent mà là
**nhân bản skill** (`testing` trong 8 agent, `observability` trong 9).
Giải: `skills` (toàn văn, cho agent **chủ quản**) vs `skills_core` (H1 + Quy trình + Checklist, **~23% độ dài**,
cho agent chỉ phải **tuân thủ**).
→ Câu hay nhất trong ADR: *"biến giới hạn token thành ranh giới trách nhiệm rõ hơn"*.

**D2. Skill mồ côi là lỗi khởi động.** *(ADR-0016)* Mỗi file trong `skills/` phải có ≥ 1 agent nạp **đầy đủ**.
Trước đó 10 skill chỉ tồn tại ở mức rút gọn — phần Quy tắc/Ví dụ **chưa bao giờ tới tay model nào**.
"Skill viết ra nhưng không ai đọc là tài liệu chết."

**D3. Ngữ cảnh theo vai, có số đo.** *(ADR-0020)* `context_namespace_read` + `max_input_chars` **theo từng agent**
(review/QA/ops 30–70k, engineer 100k). Namespace ngoài danh sách chỉ còn `summary` + **`content_omitted`** — agent
**biết mình đang thiếu** nên đi hỏi, không đoán. Kết quả: lượt review giảm ~60% ký tự, ticket 4 lượt từ ~140k
xuống ~70k token.

**D4. Cắt vai bằng dữ liệu, không bằng cảm tính.** *(ADR-0021)* Đo được rằng finding của QA ở bước PR **trùng
reviewer ở 6/6 ticket** và phần lớn là nit ⇒ bỏ QA khỏi PR, giữ QA cho hồi quy/perf/a11y trên staging.
Kèm chỉ số theo dõi ngược: `review_catch_rate` giảm rõ thì nâng reviewer về `strong` **trước khi** mở lại QA ở PR.
→ Đây chính là luật L5 của SPEC-ASC-002 ("vai không bắt được lỗi thì xoá") **được thi hành bằng số đo**.

**D5. Chạy bằng gói đăng ký, không mua token.** *(ADR-0019, `docs/DIEU-PHOI-MODEL.md`)*
Ba tier `strong/standard/light`; nhiều backend (Claude Pro/Max qua CLI, ChatGPT qua Codex CLI, Google Antigravity
qua gateway xoay vòng tài khoản, model local); gói hết hạn mức thì tự nghỉ, lượt đó đi gói kế.
Quy tắc tinh: **không bao giờ hạ tier của yêu cầu — chỉ nâng khi không còn lựa chọn.**

**D6. Bảng agent → tier có lý do, và ghi lại cả lần đảo ngược.**
Ví dụ `researcher`: hạ standard rồi **đưa về strong**, kèm bằng chứng eval cụ thể (ca
`de-bai-day-du-phai-ra-4-muc-co-nguon` đòi ≥3 glossary, ≥2 persona, ≥1 flow, ≥1 option kỹ thuật, trích đúng số hiệu
văn bản — không model standard nào đạt; sonnet-5 và opus-5 pass 2/2), kèm lý do vì sao không cứu được ở bước sau
("synthesizer khử mâu thuẫn chứ không đi nghiên cứu lại").
→ Mẫu mực về cách ghi một quyết định định tuyến model.

### Nhóm E — Cổng và con người

**E1. Checklist gate tách hai phần.** Mỗi gate ghi rõ **"Code gửi kèm"** (đúng tên khoá trong `GateRequest.checklist`,
máy dựng, hiện lên trong `gate_cli list`) và **"Người tự kiểm thêm"** (không có tên khoá, người duyệt phải tự đọc).
→ Cải tiến trực tiếp cho bảng cổng §6.1 của SPEC-ASC-002: nói thẳng **máy kiểm được gì, người phải tự làm gì** —
thay vì để cả hai lẫn vào nhau rồi không ai làm phần khó.

**E2. Four-eyes cưỡng chế bằng code.** `gates.py` ném `PermissionError("người duyệt phải khác người tạo")`.
Ở gate nghiệm thu, `signed_by` **phải khác `account-manager`** — công ty không tự ký thay khách.

**E3. Timeout 24h, nhắc ở 12h, quá hạn KHÔNG tự đi tiếp.** Quá hạn thì supervisor escalate.
→ SPEC-ASC-002 có hạn chờ nhưng để mặc định là *huỷ*; ở đây mặc định là *dừng và gọi người* — an toàn hơn.

**E4. Nghiệm thu của khách là gate thật.** Gate 4 `acceptance` có trong `gate_cli`, có hạn, có nhắc, và **chính chữ
ký của khách đóng gate**; `conditional` đóng gate dạng `request_changes`, phần còn lại đi qua `change-requests`;
ticket chỉ `closed` khi khách accepted.
→ **Khoảng trống lớn của SPEC-ASC-002:** tôi thiết kế một đội phát triển nội bộ, không phải một công ty **có khách
hàng**. Thiếu hẳn SOW, UAT, change request, biên bản nghiệm thu — mà đó mới là thứ làm nó thành "công ty".

**E5. Gate `escalation` là một loại gate, không phải ngoại lệ.** Ticket `blocked` (hết retry) hoặc bị supervisor
escalate thì **mở gate** — approve = mở lại kèm hint, reject = đóng. Việc bế tắc có đường đi chính thức.

**E6. Ticket bị bỏ không thoả `depends_on`.** Ticket bị người `reject` vào `closed` **nhưng nằm trong
`abandoned`**; ticket đang `waiting` vì nó chuyển `blocked` thay vì được dispatch **trên nền thiếu code**.
→ Loại lỗi tinh vi mà chỉ triển khai thật mới lộ ra.

### Nhóm F — Vận hành

**F1. Ước lượng trước dispatch là điều kiện cứng.** Ticket không có `estimate_tokens` **không được dispatch**;
`budget_tokens ≥ estimate × 1.5`. Ticket ≤ 1 ngày / ≤ 200k token.

**F2. `risk_tags` là trường dữ liệu, không phải phán đoán.** Tag ∈ {auth, payment, pii, crypto, upload, admin,
external-api} ⇒ bắt buộc thêm review của security-engineer trước khi tạo release candidate.
→ SPEC-ASC-002 nói "diff chạm auth/payment…" bằng lời; ở đây nó là **trường có schema, máy kiểm được**.

**F3. Nhánh tích hợp riêng, `main` của khách không bị chạm.** *(ADR-0011)* Ticket rẽ từ `company/integration`;
RC `merge --no-ff` vào đó trước khi release-engineer chạy; xung đột ⇒ RC huỷ, ticket làm lại **trên nền mới**.
→ Tốt hơn "hàng đợi merge FIFO" của tôi: FIFO giải thứ tự, nhánh tích hợp giải **nền để kiểm chứng**.

**F4. Đo tiền, không chỉ đo token.** `Pricing` quy mỗi lượt gọi ra `audit-log.cost_usd`; supervisor cắt theo
`Task.budget_usd` và **pause cả dự án** theo ngân sách dự án. Metrics xuất Prometheus không cần hạ tầng ngoài.

**F5. Trực ban chỉ đọc mặc định.** Console phải bật cờ riêng mới mở được quyền: `--allow-decide` (duyệt gate),
`--allow-config` (ghi `llm.yaml`, giữ `.bak`), `--allow-submit` (giao việc mới); token mỗi lần chạy.
→ Least privilege áp cho cả **giao diện vận hành**, không chỉ cho agent.

**F6. Ngưỡng coverage đặt ở mức đang đạt để chặn tụt lùi** (90/84/73/84), và **tên job CI `quality` là bất biến**
vì là required status check — thêm job con phải nối vào `needs` của nó.

---

## 3. Bốn chỗ SPEC-ASC-002 / SPEC-AIH-001 đã sai — repo chứng minh ngược

### 3.1 Sai nặng nhất: để model tự khai bằng chứng
SPEC-ASC-002 §5.4 định nghĩa `ChangeSet.self_check: {build: pass, types: pass, lint: pass, …}` —
**do agent lập trình tự điền**. Đó đúng là cái ADR-0010 gọi là "bằng chứng chất lượng giả".
Nếu R3 tự khai `lint: pass`, thì cổng G3a không kiểm được gì; cả chuỗi G4/G5/G6 phía sau đứng trên một lời khai.

> **Sửa:** trường bằng chứng phải do **runner** ghi đè sau khi chạy thật, kèm `verified_by`;
> không chạy được thì ghi `unverified: true`, **không** để trống và **không** để model điền.

### 3.2 Thiếu tầng skill — nên đặc tả không có chỗ nào chặn prompt phình
SPEC-ASC-002 gắn năng lực thẳng vào vai. Repo cho thấy chi phí thật của cách đó: **~175k token system prompt**
khi nhân bản năng lực qua nhiều vai. Không có tầng skill thì cũng không có `skills_core`, không có chủ quản,
không có cổng ngân sách prompt tĩnh.

### 3.3 Thiếu phân quyền ghi **tri thức**
Ma trận §3.4 của tôi phân quyền đọc/ghi **repo**. Nhưng trong một công ty agent, thứ lan xa nhất là **artifact
tri thức** (PRD, threat model, API contract, schema). Repo phân quyền theo **namespace của blackboard**,
mỗi namespace một chủ ghi — và quyền sở hữu **đổi theo giai đoạn** (`api-contract`: delivery-lead khởi tạo →
backend cập nhật).

### 3.4 Nhãn `untrusted` một-kích-cỡ là quá thô
C1-FR-06 của SPEC-AIH-001 nói nội dung `untrusted` không bao giờ nâng thành mệnh lệnh — đúng nhưng chưa đủ.
Repo phân biệt **hành động theo nguồn**: nội bộ khớp mẫu ⇒ **từ chối**; khách/web ⇒ **khử rồi đi tiếp**,
vì xử lý phản hồi của khách chính là công việc. Từ chối tất cả là làm hỏng chức năng nhân danh an toàn.

---

## 4. Ba chỗ đặc tả mạnh hơn — đề xuất ngược lại cho repo

### 4.1 Không có agent viết test độc lập (luật L2)
Trong repo, engineering agent tự viết test cho code của chính nó; reviewer chấm *chất lượng* test theo Gherkin.
Đó vẫn là **cùng một tác nhân sinh ra cả code lẫn tiêu chí kiểm tra code**. ADR-0021 làm rủi ro này tăng thêm một
bậc: với ticket thường, reviewer là **lượt kiểm thử duy nhất** trước release, và tier vừa bị hạ xuống `standard`.

> **Đề xuất:** thêm một vai `test-author` nhận `approved-specs` + `tasks` (**không** nhận `pull-requests` ở lượt
> đầu), ghi **chỉ** thư mục test, phát `test-suites`; engineering agent **không có quyền ghi** vào thư mục test đó.
> Chi phí: thêm 1 lượt/ticket. Đổi lại: bộ test không thể bị uốn theo cách cài đặt. Có thể thử trên nhánh và đo
> bằng chính `review_catch_rate` + `escaped_defect_rate` mà repo đã có thói quen theo dõi.

### 4.2 Reviewer đọc phần mô tả do chính agent viết code soạn (luật L3)
`pull-requests.summary` do model của engineering agent viết, và reviewer đọc nó. Prompt reviewer có phòng thủ tốt
("chấm trên thông tin có trong PR", "không biến *tôi chưa xác minh được* thành finding block"), nhưng cấu trúc vẫn
cho phép một mô tả thuyết phục làm dịu một diff xấu.
> **Đề xuất:** tách `summary` (cho người) khỏi phần reviewer nhận; reviewer nhận `diff`, `changed_files`,
> `local_checks` (đã `verified_by`), Gherkin của ticket và contract — đủ để chấm, không có phần biện hộ.

### 4.3 Chưa có khái niệm mức tự chủ tăng dần & đường cơ sở
Repo có gate cố định (tốt) nhưng không có lộ trình **L0→L4 có điều kiện đo được** để nới quyền theo thời gian,
cũng chưa thấy đường cơ sở DORA/`escaped_defect_rate` của quy trình người để so sánh.
Không có đường cơ sở thì không trả lời được câu quan trọng nhất: *hệ này có thật sự tốt hơn cách cũ không?*

---

## 5. Đã áp vào hai đặc tả (v1.1)

| Nguồn | Nạp vào | Nội dung |
|---|---|---|
| B1, B2 | **ASC §5.4, §6.1 (G3a)** | `ChangeSet.evidence` do runner ghi, có `verified_by`; `unverified: true` khi không chạy được; kiểm theo stack thật |
| A1, A2 | **ASC §5, §3.4** | Artifact phải có schema máy đọc; thêm ma trận **chủ ghi tri thức** theo namespace |
| C1, C2 | **AIH §4.5 (C5-FR-12/13)** | Quét tài sản prompt của chính repo; ngân sách prompt tĩnh là cổng CI |
| C3, C4 | **AIH §4.1 (C1-FR-06 mở rộng)** | Chính sách chống injection **phân biệt theo nguồn**; kết quả tool đi qua cùng bộ lọc như web |
| D1, D2, D3 | **ASC §4 (tầng skill mới)** | `skills` / `skills_core`, skill phải có chủ quản, ngữ cảnh theo vai |
| D5, D6 | **ASC §8.3** | Định tuyến theo tier + gói đăng ký là lựa chọn ngang hàng với API trả token |
| E1 | **ASC §6.1** | Mỗi cổng tách "máy kiểm" và "người tự kiểm" |
| E3, E4 | **ASC §6, §3.1** | Quá hạn gate ⇒ dừng và gọi người (không huỷ); thêm **gate nghiệm thu khách hàng** |
| F1, F2, F3 | **ASC §6.3, §4.7, §4.8** | Ước lượng là điều kiện dispatch; `risk_tags` thành trường dữ liệu; nhánh tích hợp |

---

## 6. Quan sát trung thực về rủi ro còn mở trong repo

1. **Người viết test = người viết code** (§4.1) — rủi ro lớn nhất còn lại, và vừa bị ADR-0021 khuếch đại.
2. **ADR-0015 ghi "danh sách còn trống — cơ chế đã có răng nhưng chưa cắn ai"; điều đó KHÔNG còn đúng**:
   tại commit đã đọc, `REQUIRED.txt` có **đủ 20 agent**, ghi ngày 2026-09-03 bằng model thật.
   → **Nên cập nhật phần "Hệ quả" của ADR-0015**, kẻo người đọc sau tin vào một cảnh báo đã lỗi thời.
3. **Coverage `fail_under` 73 cho `gateway`** thấp hơn hẳn ba package còn lại — mà đây lại là thành phần cầm
   **thông tin xác thực nhiều tài khoản**. Đáng nâng trước, hoặc ghi rõ vì sao chấp nhận.
4. **`cli_tools: true` (ADR-0023) tự nhận là "hàng rào yếu hơn một bậc"** so với cầu MCP (ADR-0024) — nên
   có cổng CI hoặc cảnh báo khởi động khi cấu hình thật đang bật chế độ yếu, không chỉ ghi trong tài liệu.
5. **Chưa có đường cơ sở người** để chứng minh hiệu quả (§4.3).

---

## 7. Chỉ mục nguồn trong repo (để tra lại)

| Chủ đề | Đường dẫn trong `seeker19110/Claude-Agents` |
|---|---|
| Kiến trúc công ty, vòng đời ticket, thành phần dùng chung | `software-company/docs/architecture.md` |
| Checklist từng gate (máy kiểm vs người kiểm) | `software-company/gates/checklists.md` |
| Bảng topic ↔ producer/consumer, chủ ghi namespace | `software-company/topics/README.md` |
| Tool có ranh giới, bằng chứng do code điền, eval replay | `software-company/docs/adr/0010-tool-boundary-eval-replay.md` |
| Bản ghi eval bắt buộc | `software-company/docs/adr/0015-eval-recordings-required.md` + `evals/recordings/REQUIRED.txt` |
| Skill hai mức | `software-company/docs/adr/0008-skill-tiering.md` |
| Skill phải có chủ quản | `software-company/docs/adr/0016-skill-must-have-owner.md` |
| Ngữ cảnh theo vai | `software-company/docs/adr/0020-context-by-role.md` |
| Cắt vai bằng dữ liệu | `software-company/docs/adr/0021-review-lean.md` |
| Quét tài sản prompt | `software-company/docs/adr/0022-quet-tai-san-prompt.md` |
| Blackboard toàn văn, guard theo nguồn, ngân sách tiền | `software-company/docs/adr/0012-content-context-cost-parallel.md` |
| Nhánh tích hợp | `software-company/docs/adr/0011-integration-branch.md` |
| Định tuyến theo gói đăng ký + bảng agent→tier | `docs/DIEU-PHOI-MODEL.md`, `software-company/docs/adr/0019-subscription-routing.md` |
| Four-eyes, timeout gate | `software-company/src/company/gates.py` |
| Kiểm theo stack thật | `software-company/src/company/stacks.py` |
| Mẫu agent (front matter đầy đủ) | `software-company/agents/quality/reviewer.md` |
| Mẫu skill (Quy trình + Checklist bắt buộc) | `software-company/skills/code-review.md` |

---

**Hết SYNTH-001.**
