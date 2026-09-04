# PROGRESS.md — Trạng thái dự án

> Cập nhật sau mỗi mốc đáng kể. AI đọc file này để biết đang ở đâu.

## Giai đoạn hiện tại
- GĐ 7 — Hoàn thiện công cụ/khung (tối ưu cấu hình, hướng dẫn tích hợp)

## Đã xong
- ✅ Tạo cấu hình Opusplan tiêu chuẩn (`.claude/settings-shared-opusplan.json`) — dùng chung cho mọi dự án
- ✅ Cập nhật `copy-framework.sh` để copy cấu hình Opusplan vào `_framework-dropins/`
- ✅ Cập nhật `copy-framework.ps1` tương tự cho Windows
- ✅ Viết hướng dẫn chi tiết (`CONG-CU-OPUSPLAN-CHO-DU-AN.md`) về cách sử dụng & tuỳ chỉnh cấu hình
- ✅ **Copy thẳng:** Cấu hình tự động copy vào `.claude/settings.json` (không cần chọn merge)
- ✅ **Chốt chiến lược tối ưu token:** giữ **opusplan** (Opus lập kế hoạch, Sonnet code, Haiku phụ)
      — KHÔNG dùng Fable 5 thuần (đắt, "dao mổ trâu"); Fable/Opus chỉ nâng có chọn lọc lúc cần
- ✅ Push lên nhánh `claude/opusplan-shared-config-rm5ru6`, PR #19
- ✅ **Thêm subagent Sonnet `thuc-thi`** (`.claude/agents/thuc-thi.md`) — nhận việc RÕ PHẠM VI đã bóc tách
      (viết test theo spec, boilerplate, cập nhật docs, sửa cơ học nhiều file) để rút tải khỏi main Opus.
      Đồng bộ mô tả trong CHON-MODEL, TU-DONG-tong-quan, CONG-CU-OPUSPLAN, copy-framework.sh/.ps1, /tu-dong.

- ✅ **Gộp 3 doc model/tự động → 1** (`docs/framework/MODEL-va-TU-DONG.md`): gộp CHON-MODEL +
      CONG-CU-OPUSPLAN + TU-DONG-tong-quan, khử trùng lặp (594→~360 dòng, −2 file). Cập nhật mọi
      tham chiếu: CLAUDE.md, `/adr` `/su-co` `/tu-van` `/tu-dong`, session-guide.sh.
- ✅ **Quyết định giữ scaffold web** (Next.js+Supabase) làm hồ sơ mặc định — không tách/xóa.
- ✅ PR #21 đã merge vào `main` (`main` = branch, 0/0).
- ✅ **Codify quy trình PR → merge tự động** vào CLAUDE.md §8: sau khi tạo PR thì đăng ký theo dõi + đặt lịch 3 phút, CI xanh thì squash-merge vào `main`, luôn quay về `main`, **FIFO không nhảy cóc** (PR tạo trước merge trước).
- ✅ **Thêm tính năng audit toàn diện** (`/audit-toan-dien`, khác `/audit-toi-uu` chỉ tối ưu mã nguồn):
      - `docs/ops/audit-toan-dien-prompt.md` — playbook 11 nhóm (kiến trúc, bảo mật, chất lượng mã/
        chống lỗi logic, test/coverage, hiệu năng, a11y/UI-UX, dependency, CI/CD/vận hành, tài liệu
        đồng bộ, dữ liệu/migration, cấu hình & bí mật), quy trình 2 giai đoạn (quét → dừng chờ duyệt
        → xử lý qua `/cong`).
      - `.claude/commands/audit-toan-dien.md` — slash command, có bước bắt buộc hỏi người dùng
        "quét lại từ đầu hay tiếp tục" dựa vào `docs/ops/AUDIT-TOAN-DIEN-TRANG-THAI.md` (file trạng
        thái tạo tại dự án đích, cập nhật ngay sau mỗi nhóm để resume được qua nhiều phiên).
      - Cập nhật `CLAUDE.md` §1 (TRIGGER mới), `copy-framework.sh`/`.ps1` (liệt kê lệnh mới khi copy khung).
- ✅ PR #23 tạo (draft) cho nhánh `claude/project-audit-feature-2jyw07`.
- ✅ **Bổ sung "Bước -1" vào `audit-toan-dien-prompt.md` + slash command:** trước khi quét, AI phải
      xác nhận đây là **dự án cụ thể đã phát triển** (tính năng + công nghệ đã chọn/triển khai thật),
      không phải bộ khung/template còn trống — repo `project-template` này hiện chính là khung trống
      (PROJECT.md chưa điền, `app/` chỉ có file scaffold hệ thống). Nếu vẫn là khung trống → AI phải
      DỪNG và giải thích rõ, không bịa kế hoạch/phát hiện audit cho tính năng chưa tồn tại (đúng
      nguyên tắc chống ảo giác CLAUDE.md §4). Ghi nhận từ phản hồi người dùng: khung này dùng để áp
      lên dự án khác hoặc phát triển tiếp từ đây — audit toàn diện chỉ có ý nghĩa khi đã có dự án cụ thể.

- ✅ **Tái cấu trúc repo — tên file sang TIẾNG ANH** (nội dung vẫn tiếng Việt), người dùng chốt:
      - `docs/framework/`: KHUNG-1/2/3 → `01-process-and-standards.md` / `02-ai-rules-and-project-template.md`
        / `03-tech-selection-and-proactive-advice.md`; KHOI-TAO → `new-project-runbook.md`;
        AP-DUNG → `existing-project-adoption.md`; BO-SUNG → `quality-supplements.md`;
        MODEL-va-TU-DONG → `models-and-automation.md`. Thêm `docs/framework/README.md` (chỉ mục + bản đồ tên cũ→mới).
      - `docs/ops/`: audit-toan-dien-prompt → `comprehensive-audit-prompt.md`; audit-toi-uu-prompt →
        `code-optimization-audit-prompt.md`; file trạng thái sinh tại dự án đích: `COMPREHENSIVE-AUDIT-STATUS.md`.
      - Slash commands: `/tu-van`→`/consult` · `/cong`→`/gate` · `/khoi-tao`→`/bootstrap` · `/tu-dong`→`/auto`
        · `/audit-toan-dien`→`/audit-full` · `/audit-toi-uu`→`/audit-optimize` · `/su-co`→`/incident`.
      - Subagents: `tra-cuu`→`lookup` · `kiem-tra-phien-ban`→`version-check` · `thuc-thi`→`executor`.
      - ADR: `0001-chon-stack.md` → `0001-stack-selection.md`. Toàn bộ tham chiếu chéo đã cập nhật
        (đã grep xác minh 0 sót, mọi đường dẫn docs/ được nhắc đều tồn tại).
- ✅ **Lấp 4 gap "hoàn thiện dự án"** (từ phân tích gap theo yêu cầu người dùng):
      - **`docs/framework/project-completion.md` + `/completion`** — playbook 5 pha: dò hiện trạng
        (bản đồ tính năng `docs/FEATURE-MAP.md` + sổ quy ước `docs/CONVENTIONS.md`) → audit 12 nhóm →
        **kế hoạch hoàn thiện chi tiết** (`docs/ops/COMPLETION-PLAN.md`, truy vết F-xxx→W-xxx→PR→bằng chứng,
        dừng chờ duyệt) → thực thi từng đợt qua `/gate` (bug có test tái hiện trước khi sửa) →
        **re-audit hội tụ** (0 phát hiện Cao mở; Trung/Thấp có quyết định ghi nhận) + nghiệm thu theo
        **Definition of Complete** cấp dự án.
      - **Nhóm 12 — Thống nhất chéo tính năng** thêm vào `comprehensive-audit-prompt.md` (logic trùng lặp
        phân kỳ, validation/API/phân quyền/trạng thái UI/quy ước không đồng nhất) + mẫu trạng thái 12 dòng.
      - `existing-project-adoption.md`: Bước 0 thêm FEATURE-MAP + CONVENTIONS; thêm **Bước 4 — hoàn thiện**
        (trỏ `/completion`); cổng "áp khung xong" thêm 2 file này.
      - CLAUDE.md §1 thêm TRIGGER `/completion`; cập nhật session-guide.sh, copy-framework.sh/.ps1,
        README.md, consult.md, models-and-automation.md (bảng model thêm `/audit-full` + `/completion`).
- ✅ **Rà toàn diện template + sửa & bổ sung** (nhánh `claude/template-review-k4lpfy`):
      - **Fix copy-framework.sh/.ps1:** copy kèm `scripts/` (dev-task, usage-estimate) + 2 file
        `.example.sh` — trước đây hook sang dự án đích bị no-op âm thầm (mất auto-format/gate/quota).
        Bản `.sh` sửa thêm lỗi copy thư mục LỒNG khi chạy lại lần 2 (`docs/framework/framework`…);
        đã test đầu-cuối 2 lần chạy trên thư mục scratch.
      - **PROGRESS.template.md (mới):** dự án đích nhận bản mẫu SẠCH, không nhận nhật ký của khung.
      - **Sửa 4 tham chiếu lỗi thời:** "CLAUDE.md §3 mục 10/nguyên tắc 10" → mục 7 (3 chỗ);
        "HUONG-DAN Bước 11" → "Phần D Bước 11" (runbook).
      - **Đồng bộ:** `settings.json` thêm `effortLevel: medium` (khớp bản shared); cả 2 settings
        deny thêm `git push --force-with-lease`; KHUNG-2 Phần B thêm mục "0. Loại dự án & Hồ sơ"
        (khớp PROJECT.md); KHUNG-1 GĐ 1 thêm khối **DoR** cạnh DoD (trả lời ghi chú cũ ở
        quality-supplements Nhóm 1 mục 7); runbook Phần 0 thêm `.claude/` + `scripts/` vào cây.
      - **CI cho chính khung (mới):** job `framework-lint` trong `ci.yml` chạy CẢ khi chưa có app —
        bash -n + shellcheck (error) + jq validate settings/config JSON + `scripts/check-docs-links.sh`
        (script mới: mọi đường dẫn nhắc trong *.md phải tồn tại; allowlist file sinh tại dự án đích;
        bỏ qua PROGRESS/CHANGELOG/bảng ánh xạ tên cũ).
      - models-and-automation.md: ghi chú hook cần Git Bash trên Windows; cập nhật mô tả copy.

- ✅ PR #24 (tái cấu trúc tên file) và PR #25 (hỏi rõ phạm vi "tối ưu"/"kiểm tra lỗi") đã merge vào `main`.
- ✅ **Rà hoàn thiện chính bộ khung (đợt 2026-07-02):** sửa 1 tham chiếu mồ côi "HUONG-DAN Bước 11"
      (không khớp file nào hiện có) trong `new-project-runbook.md`; cập nhật lại mục Đang làm/Tiếp theo
      của chính PROGRESS.md cho khớp thực tế (trước đó bị stale so với PR đã merge — vi phạm CLAUDE.md §2).

- ✅ **`scripts/check-docs-consistency.sh`** + job `docs-consistency` trong `ci.yml` (luôn chạy, không cần
      `package.json`): quét link gãy trong backtick + tên file/lệnh cũ còn sót ngoài bảng ánh xạ.
- ✅ **`scripts/test-copy-framework.sh`** + job `copy-framework-smoke` trong `ci.yml`: chạy THẬT
      `copy-framework.sh`/`.ps1` vào thư mục scratch, xác nhận cấu trúc copy đúng + KHÔNG đè file đã có.
      Bắt được **lỗi thật**: bước "[2/3] Cấu hình Claude Code" của cả 2 script ghi đè không điều kiện
      `.claude/settings.json`/`hooks`/`agents` — trái cam kết "KHÔNG đè" của chính script. Đã vá theo
      đúng mẫu `copy_if_absent` (như `CLAUDE.md`); có test hồi quy bảo vệ.
- ✅ **Case-study chạy thật đầu-cuối** (`docs/framework/case-study-greenfield-dry-run.md`): scaffold
      `create-next-app@latest` thật (Next 16.2.10) → `copy-framework.sh` → cài đủ gói → chạy 5 cổng
      (lint/type-check/format:check/test/build) → thử hook pre-commit + commit-msg thật. Tìm thêm 2 lỗi
      thật:
      - **`eslint.config.mjs` crash hoàn toàn** trên `eslint-config-next` hiện tại (dùng `FlatCompat` cũ,
        lỗi "Converting circular structure to JSON") — đã vá sang import subpath flat-config trực tiếp
        (khớp cách `create-next-app@latest` tự sinh), có kiểm chứng lại `npx eslint . --max-warnings 0` = 0 lỗi.
      - Thiếu bước bắt buộc "chạy `npm run format` một lần" sau khi cài Prettier → `format:check` đỏ ngay
        từ commit đầu dù không có lỗi thật — đã thêm vào cuối Bước 3 runbook.
      - Phát hiện cấu trúc: `_framework-dropins/` tự chứa bản sao `.lintstagedrc.json` của chính nó →
        vá glob từng công cụ (eslint ignore/tsconfig exclude/lint-staged pattern) không triệt để, còn gây
        crash thật ("Task killed") khi commit. Vá đúng gốc: bắt buộc xoá `_framework-dropins/` trước gate/
        commit đầu tiên (thêm vào Bước 0 runbook) — xác nhận lại: xoá xong thì toàn bộ chuỗi hook chạy đúng.

- ✅ **Reconcile PR #27 với `main` sau khi PR #26 merge song song** (cùng đợt rà template, 2 phiên làm
      độc lập trùng phạm vi): merge `origin/main` vào nhánh `claude/template-review-k4lpfy`, hợp nhất
      5 file xung đột thay vì chọn một bên:
      - `ci.yml`: giữ cả 3 job — `framework-lint` (bash -n/shellcheck/jq — thu hẹp lại, bỏ bước kiểm
        tham chiếu tài liệu vì trùng việc), `docs-consistency` (từ #26, kỹ hơn: còn bắt tên file cũ sót
        ngoài bảng ánh xạ), `copy-framework-smoke` (từ #26, chạy thật copy script vào scratch dir).
      - Xoá `scripts/check-docs-links.sh` (của #27) — thừa so với `scripts/check-docs-consistency.sh`
        (của #26, đã bao phủ + kỹ hơn). Tránh đúng lỗi "logic trùng lặp phân kỳ" mà Nhóm 12 audit-full
        của chính khung này cảnh báo.
      - `copy-framework.sh`/`.ps1`: hợp nhất fix "không đè `.claude/settings.json`/hooks/agents có sẵn"
        (#26) với fix "copy kèm `scripts/dev-task.sh`+`usage-estimate.sh`+2 file `.example.sh`" (#27) —
        dùng chung helper `copy_if_absent`/`Copy-IfAbsent` sẵn có cho toàn bộ nhóm file cấu hình Claude
        Code, thay vì hard-code từng nhánh if/else.
      - `new-project-runbook.md`: giữ bản tham chiếu đủ cả "Phần A Bước 6 / Phần D Bước 11" (đủ thông
        tin hơn bản chỉ ghi "Bước 6 ở trên" của #26 — cả 2 đều sửa đúng cùng một tham chiếu mồ côi).
      - `PROGRESS.md`: hợp nhất nhật ký cả 2 nhánh, viết lại mục Đang làm/Tiếp theo cho khớp thực tế.

- ✅ PR #27 (`claude/template-review-k4lpfy`) đã merge vào `main` (CI 3 job mới xanh).
- ✅ **Xác minh opusplan đúng tài liệu nền (đợt 2026-07-02, nhánh `claude/opusplan-token-optimization-ihrkd6`):**
      `settings.json` ≡ `settings-shared-opusplan.json` (diff trống); hooks/agents/scripts/copy-framework/
      mọi chỗ nhắc opusplan đều khớp `models-and-automation.md`; đối chiếu nguồn sống docs chính thức
      Claude Code — alias `opusplan` (Opus plan → Sonnet execution; API Anthropic: Opus 4.8/Sonnet 5),
      `fallbackModel` dạng MẢNG, `effortLevel` đều chuẩn. **Không có drift — không sửa config.**
- ✅ **Thêm §5 "Kỷ luật vận hành" vào `models-and-automation.md`** (tối ưu token thứ 3, theo yêu cầu người dùng):
      plan MỘT LẦN cho cả khối việc (tránh re-plan lắt nhắt; ghi kết quả suy nghĩ ra PROGRESS/ADR làm
      "cache chất lượng"), ngữ cảnh gọn (subagent gánh output dài; đóng mảng việc → `/gate` → commit →
      phiên mới), checklist một phiên chuẩn, bảng 2 lỗi ngược nhau về plan mode. Đánh lại số mục cũ
      §5–§8 → §6–§9 (tham chiếu ngoài chỉ trỏ §4 — không gãy; đã grep xác minh). Cập nhật mô tả file ở
      CLAUDE.md §1 + `docs/framework/README.md`.

- ✅ PR #29 (`claude/opusplan-token-optimization-ihrkd6`, §5 "Kỷ luật vận hành") đã merge vào `main`
      (CI xanh, squash). Không còn PR nào đang mở trên repo (đã rà lại 2026-07-03).
- ✅ **Rà lại opusplan sau khi người dùng hỏi "còn việc gì Sonnet làm tốt mà chưa vào hook":** xác nhận
      `settings.json` không lệch bản shared, 3 subagent (executor/lookup/version-check) + 4 hook đã phủ
      đủ vòng đời. Gap thật tìm được: cổng `pre-commit-gate.sh` chỉ chạy cổng MÁY MÓC (build/lint/test),
      không bắt được lỗi logic/trùng lặp/hiệu năng — đúng việc Sonnet làm tốt qua `/code-review`,
      `/simplify` nhưng chưa có gì nhắc chạy trước khi commit.
      - **Vá:** thêm nudge (không chặn) vào `pre-commit-gate.sh` — khi diff staged ≥ 80 dòng đổi hoặc
        ≥ 5 file, in gợi ý stderr đề nghị chạy `/code-review`/`/simplify` trước khi commit. Đã test tay:
        diff nhỏ (2 file, hook change) → im lặng đúng như kỳ vọng; logic đếm dòng qua
        `git diff --cached --numstat` đã kiểm chứng chạy được.
      - Cập nhật bảng hook ở `docs/framework/models-and-automation.md` §6 khớp hành vi mới.
- ✅ **Rà tiếp theo yêu cầu người dùng "việc Sonnet làm tốt để Sonnet làm, việc khác đẩy Opus/Fable":**
      soát 8 slash command (`adr, audit-full, audit-optimize, auto, bootstrap, completion, consult,
      gate, incident, ui-ux`) đối chiếu bảng năng lực §3 `models-and-automation.md`. 5/8 lệnh lý luận
      sâu (`adr, auto, completion, consult, incident`) đã có dòng nhắc 💡 nâng model đúng pha. `gate`,
      `ui-ux`, `bootstrap`, `audit-optimize` không cần nhắc (Sonnet ✅/✅✅ đã đủ theo bảng).
      **Gap tìm được:** `audit-full.md` — bảng §3 xếp Sonnet chỉ ✅ cho *quét* nhưng mục "Đọc theo
      nhóm" liệt `/audit-full` vào nhóm "audit lớn" cần nâng Opus cho *tổng hợp/xếp ưu tiên toàn cục*
      — command file lại không có nhắc nào, 2 việc khác thế mạnh bị gộp chung một model.
      - **Vá:** thêm dòng 💡 vào `audit-full.md` tách rõ 2 pha: GIAI ĐOẠN 1 quét từng nhóm (cơ học,
        đối chiếu checklist) → Sonnet/`opusplan` giữ nguyên; bước tổng hợp báo cáo cuối GIAI ĐOẠN 1
        (cân đánh đổi giữa 12 nhóm, xếp ưu tiên toàn cục) → nâng `/model claude-opus-4-8` (hoặc
        `fable-5` nếu dự án rất phức tạp) + `/effort xhigh`, xong hạ lại cho GIAI ĐOẠN 2 (xử lý).

- ✅ **Đặc tả AI Harness (SPEC-AIH-001)** — `docs/specs/AI-HARNESS-SPEC.md` (~1030 dòng): đặc tả kỹ thuật
      để xây một AI harness theo mô hình 7 cấu phần (Context · Tool · Orchestration · Evaluation · Security ·
      Governance · AgentOps). Gồm: 12 nguyên tắc bất biến, kiến trúc 3 mặt phẳng + luồng một lượt, yêu cầu
      chức năng có mã (`C1-FR-01`…`C7-FR-10`), mô hình dữ liệu Postgres, hợp đồng API + ánh xạ OTel GenAI,
      ma trận truy vết ASI01–ASI10, chiến lược eval 3 tầng + red team, runbook vận hành, ngăn xếp tham chiếu
      **đã xác minh phiên bản qua PyPI/npm ngày 2026-09-04**, lộ trình M0–M5.
- ✅ **ADR-0002** (`docs/adr/0002-ai-harness-architecture.md`, trạng thái *Đề xuất*): chốt 7 quyết định kiến
      trúc cốt lõi (vòng lặp ngoài xác định · event sourcing append-only · Tool Gateway là điểm nghẽn duy nhất ·
      điều phối 2 tầng Temporal+LangGraph · ngăn xếp · định tuyến model · không-eval-không-deploy) + 4 phương
      án đã cân nhắc và lý do loại.

- ✅ **Đặc tả Công ty lập trình AI (SPEC-ASC-002)** — `docs/specs/AI-SOFTWARE-COMPANY-SPEC.md` (~725 dòng):
      hệ thống đa agent đóng vai một công ty phần mềm, chạy trên harness SPEC-AIH-001. Trục thiết kế:
      **nút thắt là năng lực xác minh, không phải năng lực sinh code** (dữ liệu DORA 2025–2026: throughput
      +2–18% nhưng sự cố/PR +243%, PR agent chờ review lâu gấp 5.3×). Gồm: 7 luật bất biến (người viết ≠
      người duyệt · test sinh từ spec không sinh từ diff · reviewer chỉ đọc diff+spec · WIP ≤ năng lực xác
      minh · vai không bắt được lỗi thì xoá · không họp giữa agent · người giữ 3 chốt), máy trạng thái
      WorkItem + 3 làn, 10 vai (R0–R9) mỗi vai gắn một lớp lỗi, ma trận phân quyền thực thi ở Tool Gateway,
      6 hợp đồng artifact, 8 cổng G0–G7, 4 vòng học của trí nhớ tổ chức, ước tính chi phí/work item
      (~$6.1, xác minh chiếm ~40%), bộ chỉ số + chỉ số CẤM dùng làm KPI, 11 chống chỉ định,
      mức tự chủ L0–L4 có điều kiện vào đo được, công thức định cỡ theo số NGƯỜI.

- ✅ **Đọc repo `seeker19110/Claude-Agents` (X-Agents) và tổng hợp** → `docs/specs/LESSONS-FROM-CLAUDE-AGENTS.md`
      (SYNTH-001, ~310 dòng): 18 điểm tốt rút từ một triển khai ĐÃ CHẠY (20 agent, 45 skill, 18 topic có JSON Schema,
      5 loại human gate, ADR 0001–0025). Điểm đắt nhất: **bằng chứng chất lượng do CODE điền, không do model khai**
      (`verified_by`), quét tài sản prompt của chính repo như chuỗi cung ứng, tầng skill hai mức + chủ quản,
      eval ghi/phát lại cưỡng chế offline trong CI, chạy bằng gói đăng ký thay vì mua token.
      Nêu thẳng **4 chỗ đặc tả của mình đã sai** (self_check do model tự khai; thiếu tầng skill; thiếu phân quyền ghi
      TRI THỨC; nhãn untrusted một-kích-cỡ quá thô) và **3 chỗ đặc tả mạnh hơn repo** (test viết mù độc lập,
      reviewer không đọc lời biện hộ, mức tự chủ L0–L4 + đường cơ sở).
- ✅ **SPEC-AIH-001 → v1.1**: thêm C1-FR-11 (chống injection phân biệt theo nguồn) + C5-FR-12/13 (quét tài sản prompt,
      ngân sách prompt tĩnh là cổng CI); cập nhật ma trận ASI04.
- ✅ **SPEC-ASC-002 → v1.1**: sửa lỗi bằng chứng do model tự khai (§5.4 `evidence.verified_by`, cổng G3a đổi chủ sở hữu
      sang runner) + thêm §15 với 33 yêu cầu bổ sung ASC-FR-01…33 (tầng skill, chủ ghi tri thức, ngữ cảnh theo vai,
      cổng tách máy-kiểm/người-kiểm, cổng nghiệm thu khách hàng, risk_tags, nhánh tích hợp, golden + eval replay,
      định tuyến hai chế độ chi phí, trực ban chỉ đọc).

- ✅ **GỘP BA TÀI LIỆU → MỘT** (người dùng chốt): `docs/specs/AI-HARNESS-AND-COMPANY-SPEC.md`
      (**SPEC-AI-100 v2.0**, ~2.040 dòng) thay thế và xoá `AI-HARNESS-SPEC.md` + `AI-SOFTWARE-COMPANY-SPEC.md`
      + `LESSONS-FROM-CLAUDE-AGENTS.md`. Cấu trúc 3 phần: **A** harness (hạ tầng, A1–A11) · **B** công ty đa agent
      (tổ chức, B1–B11) · **C** chứng cứ thực địa + rủi ro + phụ lục (C1–C5).
      Khử trùng lặp thật, không dán ghép: gộp hai lộ trình (M0–M5 + Đ1–Đ5) thành **một lộ trình Đ0–Đ8**;
      gộp hai danh sách câu hỏi (8+8) thành **12 câu** chia 4 nhóm; gộp hai sổ rủi ro thành **một bảng 12 dòng**;
      hoà §15 (33 yêu cầu ASC-FR) vào đúng mục tự nhiên (skill → §B3.6, chủ ghi tri thức → §B3.5, ngữ cảnh theo
      vai → §B4.0, kỷ luật dòng chảy → §B6.5, hai chế độ chi phí → §B8.4, trực ban → §B9.4, prompt-là-code → §C1.5);
      **hợp nhất bảng cổng thành G0–G8 + G-esc**, mỗi cổng tách rõ *máy kiểm* vs *người tự kiểm*, thêm **G7 nghiệm
      thu khách hàng**. Giải một mâu thuẫn giữa hai tài liệu cũ: quá hạn cổng — trước là "mặc định huỷ" (harness)
      vs "không tự đi tiếp" (công ty) → chốt **không tự đi tiếp, không tự huỷ, chuyển leo thang cho người** (ASC-FR-14).
      Cập nhật ADR-0002 trỏ sang tài liệu mới.

- ✅ **Chốt `n = 1` (một người cho cả ba chốt) → thêm §B12 "Hồ sơ một người"** vào SPEC-AI-100:
      định cỡ theo thời gian thật (60/120/180 phút/ngày → WIP 2/3/4, 1–5 việc làn chuẩn/ngày, khởi động
      **luôn ở WIP = 2**); bảng vai bật/tắt (**R4 viết test độc lập không được tắt**; R0 điều phối thay bằng
      code; R9 chạy theo lô tuần); cổng nào giữ người (G1, G6 gộp lô, G-esc) và cổng nào để máy;
      ngưỡng điều chỉnh (rà tay mẫu **≥ 3 PR/tuần hoặc 20%** thay cho 10%; L1→L2 **60 lần merge** thay 200,
      đổi lại phải thu hẹp làn nhanh; **không lên L3 trong 6 tháng đầu**); **ba yêu cầu chống duyệt bừa**
      ASC-FR-35/36/37 (đo thời gian từ mở màn duyệt tới lúc bấm, cảnh báo khi p50 < 90 giây; nút chỉ bật sau
      khi cuộn hết; quá 48h thì tự hạ WIP); chế độ **gói đăng ký là mặc định** (~$390/tháng nếu mua token);
      đường cơ sở Đ0 rút thẳng từ git history (4 lệnh sẵn); và **lộ trình 8 tuần KHÔNG xây Phần A từ đầu** —
      dùng repo Claude-Agents đã có, chỉ vá các khoảng cách theo thứ tự giá trị/giờ.

- ✅ **Chốt lại `n = 3` (ba người ở các chốt) → viết lại §B12 thành "Hồ sơ theo quy mô đội"**: §B12.1 bảng chọn
      nhanh 1/3/6+; **§B12.2 cấu hình chốt n = 3**: four-eyes người↔người khả thi trở lại và thành BẮT BUỘC
      (ASC-FR-39 không tự duyệt việc mình khởi tạo, từ chối bằng code); **nút thắt dời từ rà tay mẫu sang G1
      duyệt đặc tả** (100% việc, không phải mẫu) → đầu tư mạnh nhất vào R1, đo `g1_review_time_p50`; phân vai
      A chủ sản phẩm / B tech lead / C trực luân phiên tuần (ASC-FR-40 ghi đổi vai); định cỡ 120'/người →
      6–7 việc/ngày, WIP 3 → 6, thông lượng bị chặn bởi A không cộng tuyến tính; ngưỡng về chuẩn đội (rà mẫu
      10% sàn ≥ 4 PR/tuần, L1→L2 200 lần ≈ 6 tuần, L3 khả thi); rủi ro mới **khuếch tán trách nhiệm** →
      ASC-FR-38 gán đích danh, không có hàng đợi "của đội"; chi phí ~$900/tháng API → 3 tài khoản xoay vòng;
      lộ trình 8 tuần **ba luồng song song**. **§B12.3 = chế độ suy giảm n = 1** (nội dung cũ giữ nguyên,
      kích hoạt khi hai người vắng, phải ghi vào hệ thống).

- ✅ **Chạy đường cơ sở Đ0 trên repo Claude-Agents** → `docs/ops/BASELINE-2026-09-04-claude-agents.md`.
      Kết luận: **không tồn tại đường cơ sở hồi cứu 8 tuần** — X-Agents mới 3 ngày tuổi, tháng 8 là dự án tiền thân
      MEP-Agents (PR `(#N)` trỏ repo khác), 6 tuần giữa trống; quy trình hiện tại đã là 1 người + Claude Code.
      Số đáng chú ý: lead time PR **trung vị 4,4 phút = thời gian CI**, 2/38 PR merge TRƯỚC khi CI xong (#29: 23 s,
      `quality` xanh 3 phút sau merge ⇒ branch protection không chặn); **35% commit thẳng vào main**; 1 sự cố xoá
      nhầm cả dự án 11/08 (138 file). Đã chỉnh bộ lệnh §B12.3.8 cho squash-merge (đếm `(#N)` + commit thẳng; lead
      time phải lấy từ API và tách CI khỏi người xem), đổi Đ0 thành **tiến cứu 4 tuần từ T0**, luồng A tuần 1 thêm
      việc **bật branch protection thật**. Câu chặn #2 ở §C2.4 đã có câu trả lời.

- ✅ **PR #3 đã squash-merge vào `main`** (`132f141`) — gồm SPEC-AI-100 v2.0, ADR-0002, đường cơ sở Đ0, `.gitleaksignore`.
      Vòng CI: `gitleaks` đỏ lúc mở vì quy tắc `generic-api-key` bắt VÍ DỤ `"idempotency_key"` trong tài liệu;
      sửa bằng `.gitleaksignore` (2 fingerprint lịch sử, có lý do) + đổi ví dụ thành chuỗi 8 ký tự; tái hiện bằng đúng
      gitleaks 8.24.3 của CI (2 vết → 0 vết) rồi mới push. Head mới 9/9 xanh, không review → merge, huỷ lịch, về `main`.

## Đang làm
- (không có — PR #3 đã merge, `main` = `132f141`, không còn PR nào mở)

## Tiếp theo
- **Đề xuất ngược cho repo Claude-Agents** (SPEC-AI-100 §C1.2, §C1.3): thêm vai `test-author` độc lập (rủi ro lớn nhất còn lại,
  vừa bị ADR-0021 khuếch đại vì reviewer thành lượt kiểm thử duy nhất); tách `summary` khỏi phần reviewer nhận;
  cập nhật phần "Hệ quả" của ADR-0015 (nói REQUIRED.txt còn trống — nay đã đủ 20 agent, ghi 2026-09-03);
  nâng ngưỡng coverage của `gateway` (73, thấp nhất, mà lại giữ thông tin xác thực nhiều tài khoản).
- **Việc kế tiếp theo lộ trình SPEC-AI-100 §B12.2.9 (n = 3, tuần 1, ba luồng song song):**
  luồng A — **bật branch protection thật** trên Claude-Agents (required check `quality`, cấm merge trước CI,
  cấm commit thẳng) + mở đo tiến cứu 4 tuần từ T0 = 05/09; luồng B — bắt đầu **vai R4 viết test độc lập**;
  luồng C — lịch trực luân phiên, G6 gộp lô, diễn tập kill switch.
- **AI Harness — câu hỏi còn mở ở §C2.4** (đã chốt câu 4 = 3 người, câu 5 = không có đường cơ sở hồi cứu):
  use case đầu tiên · Python hay TS · cloud/on-prem · đa tenant · phạm vi tuân thủ · kênh HITL · chế độ chi phí.
  Có đủ câu trả lời ⇒ thu hẹp đặc tả về đúng bối cảnh, chuyển ADR-0002 sang "Đã chấp nhận".
- **AI Harness — cần xác minh lại:** mở tài liệu gốc OWASP Agentic Top 10 2026 để xác nhận nguyên văn
  ASI01–ASI10 (phiên viết đặc tả bị egress proxy chặn `genai.owasp.org`, phải đối chiếu nguồn thứ cấp);
  xác minh phiên bản Python/PostgreSQL/Redis/OPA/sandbox bằng nguồn sống khi khởi tạo.
- Case-study mới chạy phần D (hàng rào cục bộ). Phần Bước 6–8 (branch protection, Supabase, Vercel) cần
  tài khoản thật, chưa kiểm chứng được — nếu có dịp áp khung vào dự án thật, nên kiểm nốt phần này.
- Dự án đã copy khung bản cũ → dùng bảng ánh xạ trong `docs/framework/README.md` khi cập nhật; chạy lại
  `copy-framework.sh` bản mới để nhận `scripts/` + hook hoạt động thật + fix không-đè-cấu-hình-có-sẵn.

## Quyết định quan trọng (trỏ tới ADR nếu có)
- **ADR-0002 (Đề xuất):** kiến trúc AI harness — vòng lặp ngoài xác định do harness sở hữu, event sourcing
  append-only làm nguồn sự thật duy nhất, Tool Gateway là điểm nghẽn duy nhất cho mọi tác động ra ngoài.
  Nguyên tắc nền: *prompt không phải cơ chế bảo mật*.
- Cấu hình Opusplan được thêm vào `_framework-dropins/` (an toàn, không đè cấu hình cũ)
- `.claude/` (hooks + agents) cũng được copy vào `_framework-dropins/` để dự án cũ tự merge nếu cần
- **opusplan là điểm ngọt, không đổi**; tối ưu token thêm bằng CHIA VIỆC (subagent) chứ không "route theo độ khó"
  (Claude Code không có bộ định tuyến model per-query). `thuc-thi` cùng Sonnet với pha-code opusplan —
  lợi ích là **cô lập ngữ cảnh + song song**, không phải model rẻ hơn.

## Nợ kỹ thuật (chỗ "làm tạm" cần quay lại)
- (không có)

## Bàn giao phiên (điền khi WIND-DOWN gần chạm limit 5h — để phiên sau "tiếp tục")
> Chế độ tự động ghi ở đây trước khi dừng: việc vừa xong, việc DỞ ở đâu, bước kế tiếp cụ thể.
- Lần cập nhật: 2026-07-02 (đợt 2 — sau khi PR #27 đã merge)
- Việc DỞ / bước tiếp theo: nhánh `claude/opusplan-token-optimization-ihrkd6` thêm §5 "Kỷ luật vận hành"
  vào `models-and-automation.md` (+ đồng bộ CLAUDE.md §1, framework/README.md, PROGRESS.md) — cần theo dõi
  CI của PR, squash-merge khi xanh, quay về `main`.
- Cần lưu ý khi chạy tiếp: TOÀN BỘ tên file/lệnh đã sang tiếng Anh — tra bản đồ tên cũ→mới ở `docs/framework/README.md`. Doc model/tự động: `docs/framework/models-and-automation.md`. Subagent Sonnet: `.claude/agents/executor.md`. Copy-framework giờ copy kèm `scripts/` + `PROGRESS.template.md` + KHÔNG đè `.claude/settings.json`/hooks/agents có sẵn (dùng `copy_if_absent`).
