# Cần gộp vào `tsconfig.json`

Không thể đưa sẵn `tsconfig.json` (create-next-app sinh ra bản riêng có `paths`, `plugins`).
Chỉ cần **thêm các cờ sau** vào `compilerOptions` để bật strict tối đa:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "forceConsistentCasingInFileNames": true
  }
}
```

> `strict: true` thường đã có sẵn. Nếu `noUnusedLocals`/`noUnusedParameters` quá chặt
> lúc mới bắt đầu, có thể tạm tắt (ESLint đã lo phần biến thừa).
