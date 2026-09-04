# Đường cơ sở Đ0 — repo `seeker19110/Claude-Agents`

> **Ngày đo:** 2026-09-04 · **Theo:** SPEC-AI-100 §B12.3.8 (bốn lệnh), đã chỉnh cho repo **squash-merge**
> **Nguồn:** `git origin/main` (fetch depth 1000 → 521 commit, từ 2025-03-30) + GitHub API (38 PR, 20 check run/PR)
> **Người đo:** AI trong phiên, đối chiếu tay hai PR (#29, #37). Số nào là ước lượng đều ghi rõ.

## 1. Kết luận — đọc trước bảng số

1. **Không tồn tại đường cơ sở hồi cứu 8 tuần cho codebase này.** X-Agents ở dạng hiện tại mới **~3 ngày tuổi**
   (03–05/09). Tám tuần trước đó gồm **một tuần** (W33, 10–14/08) của dự án tiền thân *MEP-Agents* — khác codebase,
   PR số `(#N)` trong commit tháng 8 trỏ tới repo khác — và **sáu tuần trống**.
2. **Quy trình "người" hiện tại đã là một người + Claude Code**: cùng một email cho hai tên tác giả, 22/248 commit
   có đồng tác giả Claude, 38 PR trong hai ngày. Vậy câu hỏi đúng của Đ0 không phải *"AI có tốt hơn người?"*
   mà là **"đa agent có cổng có tốt hơn một người + Claude tương tác không?"**
3. **Cổng PR hiện không chặn gì.** Lead time mở → merge **trung vị 4,4 phút = đúng thời gian CI**;
   **2/38 PR merge trước khi CI xong** (#28 sau 55 giây, #29 sau 23 giây — job `quality` xanh **3 phút sau merge**).
   Phần người xem ≈ 0. Branch protection không cưỡng chế required check.
4. **35% commit đi thẳng vào `main`** không qua PR (76/215), dồn vào 10–14/08 và 02–03/09.
5. **Một sự cố nghiêm trọng** ngày 11/08: xoá nhầm toàn bộ dự án (138 file, −14.194 dòng), 2 revert + 1 PR khôi phục.
   Thuộc dự án tiền thân, nhưng **cùng người, cùng cách làm** — đây là mẫu lỗi mà cổng G6 + nhánh tích hợp (ASC-FR-23) sinh ra để chặn.

## 2. Bốn số

| # | Số đo | 8 tuần (10/07 → 04/09) | Chỉ X-Agents (02 → 05/09) | Ghi chú |
|---|---|---|---|---|
| **1** | Tần suất đưa vào `main` | **139** lượt qua PR (125 squash + 14 merge) + **76** commit thẳng = 215 | 87 squash + 6 merge + 24 thẳng trong **4 ngày** | Hoạt động dồn hai tuần: W33 = 98, W36 = 117 commit; sáu tuần giữa = 0 |
| **2** | Revert / hotfix | **3** commit, **1 sự cố** (11/08) → 1,4% commit; 1 sự cố / 8 tuần | **0** | Sự cố của dự án tiền thân |
| **3** | Lead time PR (mở → merge, GitHub) | — *(không có PR của repo này trước 03/09)* | **trung vị 4,4 phút** · p90 ≈ 16 phút · min 23 giây · max 29 phút *(n = 38, tính tay từ timestamp)* | ≈ thời gian CI ⇒ **không có bước người** |
| **4** | Kích thước PR | TB 15,2 file, +647/−809 dòng *(bị 2 revert 138 file kéo lệch)* | 124 squash-PR, loại revert: **trung vị 8 file**, TB 13, max 140 | Skill `code-review` của chính repo đặt ngưỡng ~400 dòng thay đổi — chưa đo dòng/PR riêng |

## 3. Bối cảnh cần biết khi đọc số

- **Tác giả 8 tuần:** `seeker19110` (141) + `Seeker` (82) — cùng email, **một người**; `Claude` 22; `dependabot` 3.
- **CI:** 20 job, gom vào `quality`; chạy ~3,5–4 phút; xanh 20/20 ở cả hai PR đã kiểm.
- **Branch protection:** bằng chứng #29 cho thấy merge được **trước** khi `quality` kết thúc ⇒ hoặc chưa bật
  required check, hoặc admin bypass. Dù cách nào, CI đang là **tư vấn**, không phải **cổng**.
- Số tuần 33 và 36 **không cộng được với nhau** thành xu hướng — hai codebase khác nhau.

## 4. Hệ quả cho SPEC-AI-100

| Điều khoản | Trước | Sau khi có số |
|---|---|---|
| Đ0 (§B11.1, §B12.2.9 luồng A tuần 1) | Đo **hồi cứu** 8 tuần | **Đo tiến cứu 4 tuần** kể từ 05/09 với quy trình hiện tại (1 người + Claude Code) làm mốc T0. Không có cách nào khác — quá khứ không có dữ liệu cùng codebase |
| Bốn số | Như §B12.3.8 | Thêm hai số: **% commit qua PR** (mục tiêu 100%) và **thời gian người xem PR** (ASC-FR-35 áp ngay từ T0, chưa cần chờ hệ đa agent) |
| Luồng A tuần 1 | Chốt đường cơ sở | **Bật branch protection thật** (required check `quality`, cấm merge trước CI, cấm commit thẳng) — nếu không, mọi cổng G3a–G6 sau này chỉ là lời hứa |
| Cổng ra tuần 8 ("không lên L2 nếu `escaped_defect_rate` không tốt hơn") | So với đường cơ sở | **Cảnh giác:** mốc T0 = 0 sự cố / 4 ngày là **thấp vì thời gian ngắn**, không phải vì quy trình tốt. Dùng mốc 4 tuần tiến cứu, không dùng số 4 ngày |

## 5. Lệnh tái đo (đã chỉnh cho squash-merge — thay cho bản trong §B12.3.8)

```bash
B=origin/main; S=8.weeks
# [1] Lượt vào main: PR squash có đuôi "(#N)" + merge thật + commit thẳng (cái cuối phải → 0)
git log --first-parent --no-merges --since=$S --format='%s' $B | grep -cE '\(#[0-9]+\)$'   # squash-PR
git log --first-parent --merges    --since=$S --oneline       $B | wc -l                    # merge thật
git log --first-parent --no-merges --since=$S --format='%s' $B | grep -vcE '\(#[0-9]+\)$'  # commit thẳng
# [2] Revert / hotfix
git log --first-parent --since=$S --format='%h %ad %s' --date=short $B | grep -iE 'revert|hotfix|fix!|urgent|khôi phục'
# [3] Lead time: KHÔNG lấy được từ git với squash-merge — dùng GitHub API (created_at → merged_at của PR)
#     và tách riêng "thời gian CI" khỏi "thời gian người xem" bằng check-run completed_at so với merged_at
# [4] Kích thước PR: trung vị, loại revert (trung bình bị revert lớn kéo lệch)
git log --first-parent --no-merges --since=$S --format='%H %s' $B | grep -E '\(#[0-9]+\)$' | grep -viE 'revert|khôi phục' \
  | cut -d' ' -f1 | while read h; do git show --shortstat --format= $h | grep -oE '^ *[0-9]+ files? changed' | awk '{print $1}'; done \
  | sort -n | awk '{a[NR]=$1} END {print "trung vị file/PR:", (NR%2)?a[(NR+1)/2]:(a[NR/2]+a[NR/2+1])/2}'
```
