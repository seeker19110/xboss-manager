# Cấu hình Fable 5 + Opus 4.8 dùng chung cho mọi dự án

> **Mục đích:** Cung cấp cấu hình Claude Code tiêu chuẩn sử dụng **Fable 5** (mạnh nhất, nếu có) → fallback **Opus 4.8** cho bất kỳ dự án nào khi áp dụng bộ khung CLAUDE.md.
> **Khi nào:** Được áp dụng **mặc định** khi tích hợp khung vào dự án (mới hoặc có sẵn). Nếu muốn đổi sang Sonnet 5 (rẻ hơn), chỉ cần sửa `.claude/settings.json`.

---

## 0. TL;DR — Dùng ngay

Khi áp dụng khung vào dự án của bạn bằng `copy-framework.sh` hoặc `copy-framework.ps1`:

```bash
# Từ repo khung, chạy:
bash copy-framework.sh /đường-dẫn/tới/dự-án-của-bạn
```

✅ **Xong!** Script sẽ tự động:
- Copy cấu hình Fable 5 vào `.claude/settings.json` 
- Copy hooks & agents vào `.claude/`
- Copy các file cấu hình khác (eslint, prettier, etc.) vào `_framework-dropins/`

**Kết quả:** 
- ✅ Model mặc định: **Fable 5** (mạnh nhất)
- ✅ Fallback: **Opus 4.8** (nếu Fable 5 không có)
- ✅ Mở phiên Claude Code lần đầu → AI tự dùng Fable 5 / Opus 4.8 để chạy khung 🚀

**Nếu muốn đổi model** (vd Sonnet 5 để tiết kiệm):
```bash
# Chỉnh file .claude/settings.json:
#   "model": "claude-sonnet-5"
```

---

## 1. File cấu hình tiêu chuẩn là gì?

**`.claude/settings.json`** — file cấu hình Claude Code mặc định (tự động copy từ `.claude/settings-shared-opusplan.json`):

### Model (chính)
- **`"model": "claude-fable-5"`** — Dùng Fable 5 (mạnh nhất):
  - ✅ Đủ mạnh cho mọi task: lập kế hoạch, code, research-first, quyết định kiến trúc
  - ✅ **Chi phí**: gấp ~1.5× Opus 4.8, gấp ~3.3× Sonnet 5
  - ✅ **Thích hợp**: dự án có rủi ro cao, phức tạp, yêu cầu chất lượng cao

### Fallback model
- **`"fallbackModel": ["claude-opus-4-8", "claude-sonnet-5", "claude-haiku-4-5"]`** — Nếu Fable 5 không khả dụng:
  1. Thử Opus 4.8 trước (mạnh, rẻ hơn Fable 5)
  2. Thử Sonnet 5 (cân bằng, phổ biến)
  3. Thử Haiku 4.5 (rẻ nhất, cho việc đơn giản)

### Permissions (quyền hạn)
Cho phép các công cụ cần thiết:
- **Read/Edit/Write:** chỉnh sửa file
- **Bash git:** quản lý git (add, commit, push, fetch)
- **Bash build/test:** chạy lệnh dev của dự án (npm/pnpm/yarn/pytest/go/cargo/…)
- **Deny:** chặn các thao tác nguy hiểm (rm -rf, force push, sudo, xem .env)

### Hooks (tự động chạy)
- **SessionStart:** Kiểm tra nạp file PROGRESS.md, hướng dẫn phiên
- **PreToolUse (Bash):** Cổng pre-commit trước mỗi thao tác Bash (chặn công việc bẩn)
- **PostToolUse (Edit/Write):** Auto-format file vừa sửa
- **Stop:** Guard sử dụng (cảnh báo nếu dùng quá nhiều token)

---

## 2. Khi nào dùng Fable 5?

| Tiêu chí | Dùng Fable 5? | Nếu muốn tiết kiệm → dùng |
|---|---|---|
| **Dự án nhỏ** (script, landing, prototype, <5k LOC) | ❌ (quá mạnh) | ↓ Sonnet 5 |
| **Dự án tầm trung** (web+API, 10–50k LOC) | ✅ **CÓ (mặc định)** | Opus 4.8 (rẻ hơn) |
| **Dự án lớn/phức tạp** (nhiều dịch vụ, realtime, >50k LOC) | ✅ **CÓ (mặc định)** | Opus 4.8 (cân bằng) |
| **Yêu cầu mơ hồ, nhiều đánh đổi kiến trúc** | ✅ **CÓ (tốt nhất)** | Opus 4.8 |
| **Kiến trúc nhạy cảm, breaking change, migration** | ✅ **CÓ (tốt nhất)** | Opus 4.8 |

**Chiến lược:**
- **Mặc định: Fable 5** (mạnh nhất, không lo chất lượng)
- **Tiết kiệm: Sonnet 5** (rẻ ~60%, đủ tốt cho dự án nhỏ→tầm trung)
- **Hybrid: Opus 4.8** (mạnh/rẻ balanced, fallback tốt)

---

## 3. Cách chọn model cho dự án của bạn

**Mặc định đã là Fable 5** — cấu hình tự động copy khi áp dụng khung. Không cần chọn!

**Nếu muốn thay đổi:**

### Tùy chọn A — Giữ Fable 5 (mặc định, khuyến nghị)
✅ Không cần làm gì, file `.claude/settings.json` đã cấu hình sẵn.

### Tùy chọn B — Dùng Opus 4.8 (mạnh + rẻ hơn Fable)
Sửa file `.claude/settings.json`:
```json
{
  "model": "claude-opus-4-8",
  "fallbackModel": ["claude-sonnet-5", "claude-haiku-4-5"]
}
```

### Tùy chọn C — Dùng Sonnet 5 (tiết kiệm chi phí, ~60% rẻ hơn Fable)
Sửa file `.claude/settings.json`:
```json
{
  "model": "claude-sonnet-5",
  "fallbackModel": ["claude-haiku-4-5"]
}
```

### Tùy chọn D — Hybrid (Sonnet 5 mặc định, Fable khi cần)
1. Cấu hình `.claude/settings.json` dùng `"model": "claude-sonnet-5"`
2. Khi cần Fable (KHUNG-3 trade-off, `/adr`, `/su-co`), chạy:
   ```bash
   /model claude-fable-5
   ```

---

## 4. Áp dụng cấu hình cho dự án của bạn

### Tất cả dự án (mới hoặc có sẵn)

**Quá trình tự động:**

1. Clone repo khung (hoặc đã ở trong repo khung):
   ```bash
   cd /đường-dẫn/tới/repo-khung
   ```

2. Copy khung sang dự án của bạn:
   ```bash
   bash copy-framework.sh /đường-dẫn/tới/dự-án
   ```

   ✅ Script tự động:
   - Copy `.claude/settings.json` (Fable 5 / Opus 4.8 fallback) thẳng vào dự án
   - Copy `.claude/hooks` và `.claude/agents`
   - Copy các file cấu hình khác (eslint, prettier, etc.) vào `_framework-dropins/`

3. Vào dự án:
   ```bash
   cd /đường-dẫn/tới/dự-án
   ```

4. **(Tùy chọn)** Soát thư mục `_framework-dropins/`:
   - Nếu dự án của bạn dùng các công cụ giống khung (eslint, prettier, playwright), hãy merge config từ đó
   - Hoặc xóa nếu không cần:
     ```bash
     rm -rf _framework-dropins/
     ```

5. Commit tất cả thay đổi:
   ```bash
   git add .claude/ && git commit -m "chore: apply framework config (Fable 5 / Opus 4.8)"
   ```

6. Mở phiên Claude Code lần đầu → AI tự nạp `.claude/settings.json` và chạy khung với Fable 5 / Opus 4.8 🎉

---

## 5. Tuỳ chỉnh cấu hình cho dự án đặc thù

### Thêm permission tùy chỉnh
Nếu dự án dùng công cụ khác (vd `make`, `docker`, `kubectl`):

```json
{
  "permissions": {
    "allow": [
      ...cũ...,
      "Bash(make *)",
      "Bash(docker *)",
      "Bash(kubectl *)"
    ]
  }
}
```

### Loại bỏ hook không cần
Nếu không dùng pre-commit gate (vd dự án backend không cần auto-format):

```json
{
  "hooks": {
    "SessionStart": [...],
    "Stop": [...]
    // Bỏ "PreToolUse" và "PostToolUse" nếu không cần
  }
}
```

### Thêm hook mới (tuỳ chọn)
Xem `CLAUDE.md` mục "update-config" để thêm hook tùy chỉnh (vd chạy vitest tự động).

---

## 6. Kiểm tra cấu hình đã áp đúng

Khi mở phiên Claude Code lần đầu:

✅ **Kiểm tra:**
1. Dòng trạng thái Claude Code hiển thị **"Fable 5"** hoặc **"Opus 4.8"** (fallback)
2. Phiên khởi động gọi hook `session-resume.sh` (xem PROGRESS.md)
3. Có thông báo chế độ chạy (từ hook `session-guide.sh`) với model được cấu hình
4. Mỗi lần Edit/Write, file tự format (hook `auto-format.sh`)

❌ **Nếu không thấy:**
- Kiểm tra file `.claude/settings.json` có tồn tại không: `ls -la .claude/settings.json`
- Kiểm tra model được cấu hình: `grep '"model"' .claude/settings.json`
- Đóng/mở phiên Claude Code lại (reload cấu hình)
- Nếu vẫn sai, kiểm tra `.claude/hooks/` có tồn tại không

---

## 7. Q&A

### Q: Tôi muốn dùng Sonnet 5 thay vì Fable 5, phải làm gì?
**A:** Sửa `.claude/settings.json`:
```bash
jq '.model = "claude-sonnet-5"' .claude/settings.json > /tmp/settings.json && mv /tmp/settings.json .claude/settings.json
```
Hoặc mở file text, thay `"claude-fable-5"` → `"claude-sonnet-5"`.

### Q: Tôi có thể tạo nhiều file cấu hình cho nhiều dự án khác nhau không?
**A:** Có! Tạo các file:
- `.claude/settings-sonnet.json` — cho dự án nhỏ
- `.claude/settings-opus.json` — cho dự án lớn
- `.claude/settings.json` — file hiện tại (cái mà Claude Code nạp)

Sau đó copy cái cần: `cp .claude/settings-sonnet.json .claude/settings.json`

### Q: File này có tương thích với mọi loại dự án không?
**A:** **Có, nhưng...** 
- ✅ Permissions tổng quát cho Node/Python/Go/Rust/Makefile
- ✅ Hooks không phụ thuộc stack
- ⚠️ Một vài hook (vd `auto-format`) cần `scripts/dev-task.sh` — nếu dự án không có, hook sẽ no-op (không lỗi)
- Nếu dự án dùng công cụ độc lạ, thêm permissions tùy chỉnh (xem mục 5)

### Q: Cấu hình Fable 5 + Opus 4.8 có hỗ trợ các dự án mobile, desktop, backend không?
**A:** **Có!** Đây là cấu hình **Claude Code chạy khung CLAUDE.md**, không giới hạn loại dự án.
- ✅ Web (Next, Remix, Svelte, Astro, Vue)
- ✅ Mobile (React Native, Flutter — qua CLI/backend)
- ✅ Backend (Python FastAPI, Node Express, Go, Rust)
- ✅ Desktop (Electron, Tauri)
- ✅ CLI / SDK / Library
- ✅ Data / ML / AI
- ✅ Game, Blockchain, Monorepo
- Nó áp dụng **quy trình CLAUDE.md** (9 giai đoạn, cổng, research-first) cho bất kỳ stack nào.

### Q: Chi phí các model bao nhiêu?
**A:** Giá hiện tại (2026-07, intro pricing):
- **Sonnet 5:** $2 input / $10 output (intro) → $3/$15 (normal)
- **Opus 4.8:** $5 input / $25 output
- **Fable 5:** $10 input / $50 output
- **Haiku 4.5:** $1 input / $5 output

**So sánh (per 1M input token):**
| Model | Giá | So với Sonnet 5 |
|---|---|---|
| Sonnet 5 | $3 | ✅ (baseline) |
| Opus 4.8 | $5 | 1.67× đắt |
| Fable 5 | $10 | 3.3× đắt |
| Haiku 4.5 | $1 | 0.33× (rẻ) |

**Mặc định Fable 5:** Bạn trả gấp ~3.3× Sonnet 5, nhưng được mạnh nhất (không bao giờ chất lượng kém).

---

## 8. Tiếp theo

Sau khi áp dụng cấu hình:
1. ✅ Commit file `.claude/settings.json` vào git
2. ✅ Mở phiên Claude Code, mô tả dự án → AI tự chạy khung
3. ✅ Đọc `AP-DUNG-vao-du-an-co-san.md` nếu dự án cũ (brownfield)
4. ✅ Đọc `KHOI-TAO-du-an-moi.md` nếu dự án mới (greenfield)

---

**Happy building! 🚀**
