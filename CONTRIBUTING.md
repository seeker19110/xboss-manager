# Đóng góp

> Dự án vận hành theo bộ khung trong `docs/framework/`. Đọc `CLAUDE.md` (luật vận hành) và
> `docs/framework/01-process-and-standards.md` (quy trình + cổng) trước khi bắt đầu.

## Trước khi bắt đầu một việc (Definition of Ready)

Một task chỉ nên BẮT ĐẦU khi: có tiêu chí chấp nhận rõ ràng đo được · không còn câu hỏi mở · đã
xác định phụ thuộc · thiết kế/luồng đủ rõ · phạm vi gói gọn trong một PR. (Chi tiết: Nhóm 1, mục 7.)

## Quy trình Git

- Mỗi tính năng/sửa lỗi **một nhánh riêng**: `feat/...`, `fix/...`, `refactor/...`, `docs/...`.
- Commit nhỏ, mỗi commit một thay đổi logic.
- **Conventional commits** bắt buộc (commitlint chặn nếu sai): `feat`, `fix`, `refactor`, `docs`,
  `test`, `chore`, `style`, `perf`. Nêu rõ "cái gì" + "tại sao".
- **Mọi merge qua Pull Request** (kể cả làm một mình) · **CI xanh mới merge** · **không push thẳng `main`**.
- **Ưu tiên squash merge** khi gộp PR: lịch sử `main` tuyến tính, mỗi PR = một commit conventional
  (hợp `release-please`). Đặt tiêu đề squash đúng dạng conventional. Nên cấu hình repo chỉ bật
  *Allow squash merging* (tắt merge commit) để buộc đúng cách. (Lưu ý: các merge/squash commit do
  GitHub tạo mang committer `noreply@github.com` nhưng được GitHub ký GPG → hiển thị **Verified**.)

### Bảo vệ nhánh `main` — kiểm được bằng máy, không phải lời hứa

Ba gạch đầu dòng ngay trên (qua PR · CI xanh mới merge · chỉ squash) trước đây chỉ là quy ước viết trong
tài liệu. Từ nay có hai lớp cưỡng chế:

1. **`.github/rulesets/main.json`** — ruleset **import được**, đi qua PR như code nên sửa nó để lại dấu vết.
   Bật: Settings → Rules → Rulesets → **New ruleset → Import a ruleset** → chọn file đó → Create.
   Nội dung: bắt buộc PR (thread review phải resolve, **chỉ squash**) · required status checks
   `framework-lint` · `docs-consistency` · `copy-framework-smoke` · `quality` · `e2e` · `lighthouse` ·
   `gitleaks` · `protection-guard` · cấm xoá và cấm force-push `main` · **không ai bypass, kể cả admin** ·
   **tắt** "up to date" (`strict: false`) để một PR merge không bắt mọi PR đang mở gộp `main` rồi chờ CI lại.
2. **Job `protection-guard` trong CI**, hai vế:
   - Đọc rule đang áp lên nhánh mặc định qua API và **đỏ khi thiếu** bất kỳ mục nào ⇒ chưa import ruleset thì
     mọi PR đỏ, đó là chủ đích.
   - Đối chiếu **mọi required check trong ruleset với tên job có thật** trong `.github/workflows/`. Đây là kiểu
     hỏng âm thầm và tốn kém nhất: đổi tên một job mà quên sửa ruleset ⇒ context bắt buộc **không bao giờ xuất
     hiện** ⇒ `main` khoá vĩnh viễn trong khi CI vẫn xanh. Guard bắt ngay ở PR đổi tên.

Hai nút vẫn phải bật tay trong Settings → General (không thuộc ruleset): **Allow auto-merge** và
**Automatically delete head branches**. Nên tắt luôn *Allow merge commits* cho khớp với quy ước squash ở trên.

> #### ⚠️ Vì sao `required_approving_review_count` = 0
>
> **Không phải hạ tiêu chuẩn — là tránh một thế kẹt đã xảy ra thật.** Repo này hiện có **một người**.
> GitHub **không cho tự duyệt PR của chính mình**, và `bypass_actors` cố ý để rỗng, nên đặt 1 approval sẽ
> **khoá vĩnh viễn mọi PR** vào `main` — auto-merge bật cũng không kích hoạt được. Điều này đã xảy ra ở
> repo `Claude-Agents` và phải sửa lại thủ công trong Settings, vì sửa file JSON cũng cần một PR mà PR
> thì đang bị khoá.
>
> Đặt 0 **vẫn giữ nguyên** hai thứ đáng giá nhất: bắt buộc đi qua PR (chặn push thẳng `main`) và bắt buộc
> CI xanh **trước** khi merge. Thứ mất đi là four-eyes — vốn không tồn tại khi chỉ có một người.
> Cùng lý do, `require_extra_approval_for_unattributed_changes` cũng để `false`: nó đòi **thêm** một
> approval khi PR chứa thay đổi không gán được cho tài khoản nào, tức là tái tạo đúng thế kẹt trên.
>
> **Nâng lại lên 1 (hoặc 2) ngay khi có người thứ hai thật** trong repo — lúc đó four-eyes mới có nghĩa.
> Cách đổi: sửa file JSON qua PR **rồi import lại** (ruleset cùng tên sẽ được cập nhật).
> Guard không kiểm số approval nên đổi số không làm CI đỏ.
>
> ⚠️ **Nếu lỡ tự khoá:** phải **sửa ruleset đang chạy trong Settings TRƯỚC**, rồi mới sửa được file —
> vì sửa file cũng cần một PR. Đường vòng nhanh: đổi "Enforcement status" sang **Disabled**, merge, bật lại.

## Cổng trước khi commit (chạy và đạt hết)

```bash
npm run lint && npm run type-check && npm run format:check && npm run test:coverage && npm run build
```

Ngoài ra: tự đọc lại diff · xóa code rác/`console.log` debug · không bí mật trong code · mọi input đã
validate · mọi thao tác có thể lỗi đã xử lý. Xuất **Báo cáo xác thực** (KHUNG 2) trước khi commit/merge.

## Cổng trước khi merge (thêm)

Toàn bộ test (gồm **E2E Playwright**) xanh · nhánh đã cập nhật với `main`, không xung đột · đối chiếu đủ
**tiêu chí chấp nhận** + **Definition of Done** (checklist trong PR template) · smoke test luồng chính trên
Preview · rà soát bảo mật · nếu đổi schema: migration có phiên bản + đường rollback, RLS đã test.

## Hàng rào tự động (đừng vô hiệu hóa)

pre-commit (lint/format/type) · commit-msg (commitlint) · CI (lint/type/format/test+coverage/build/audit/E2E)
· Lighthouse CI · CodeQL · gitleaks · branch protection trên `main`.
