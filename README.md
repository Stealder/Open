# Anime Adventures Dedicated Kaitun Suite

Bản Kaitun tự động hóa hiệu năng cao dành cho Anime Adventures (No-GUI, chạy ngầm siêu nhẹ, tối ưu hóa phần cứng và ẩn danh console 100%).

---

## 🚀 Cách sử dụng (Quick Start)

### Cách 1: Chạy trực tiếp qua Executor (Khuyên dùng)
Copy đoạn mã dưới đây dán vào tab Script của Executor (hoặc file `.luau` trong thư mục `autoexec`):

```lua
getgenv().KaitunConfig = {
    Mode = "Infinite",              -- "Infinite" hoặc "Story"
    TargetInfiniteMap = "namek_infinite", -- Map farm Infinite
    AutoSell = {
        Enabled = true,             -- Tự động bán unit để replay nhanh
        Wave = 25,                  -- Bán ở Wave 25
    },
    BlackScreen = true,             -- Bật màn hình tối giảm tải GPU/RAM
    SecurityMode = true,            -- Tự rời trận nếu có người lạ
    Webhook = {
        Enabled = false,            -- Bật webhook thông báo kết quả
        Url = "",                   -- Dán Webhook URL Discord
    }
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Stealder/Open/main/kaitun.luau"))()
```

### Cách 2: Sử dụng file cấu hình riêng
1. Tham khảo và chỉnh sửa các tham số chi tiết tại [`config.lua`](config.lua).
2. Tải và chạy script qua [`loader.luau`](loader.luau).

---

## ⚙️ Bảng thông số cấu hình (`KaitunConfig`)

| Tham số | Kiểu dữ liệu | Mặc định | Mô tả |
| :--- | :---: | :---: | :--- |
| `Mode` | string | `"Infinite"` | Chế độ cày: `"Infinite"` (farm gems vô tận) hoặc `"Story"` (leo map). |
| `TargetInfiniteMap` | string | `"namek_infinite"` | Map farm Infinite (Planet Greenie [Hard]). |
| `AutoPlace` | boolean | `true` | Tự động đặt các Unit đã trang bị xuống sân. |
| `AutoUpgrade` | boolean | `true` | Tự động nâng cấp Unit trong trận lên cấp tối đa. |
| `AutoStart` | boolean | `true` | Tự động bấm Vote Start khi vào trận. |
| `AutoSkipWave` | boolean | `true` | Tự động bấm Vote Skip Wave qua màn nhanh. |
| `AutoSell.Enabled` | boolean | `true` | Tự động bán toàn bộ Unit để kết thúc trận và nhận thưởng. |
| `AutoSell.Wave` | number | `25` | Mốc Wave kích hoạt bán Unit. |
| `BlackScreen` | boolean | `true` | Màn hình tối tối ưu FPS/RAM, kèm HUD theo dõi trực tiếp. |
| `DeleteMap` | boolean | `true` | Xóa cảnh quan thừa (giữ sàn an toàn) chống giật lag. |
| `HideEnemyHealthBars` | boolean | `true` | Ẩn thanh máu quái vật để giảm tải giao diện Roblox. |
| `SecurityMode` | boolean | `true` | Tự động teleport về Lobby nếu phát hiện người lạ vào phòng. |
| `Webhook.Enabled` | boolean | `false` | Bật thông báo kết quả trận đấu qua Discord Webhook. |
| `Webhook.Url` | string | `""` | Địa chỉ Webhook Discord. |

---

## 🛡️ Đặc tính bảo mật & Tối ưu

- **Zero Console Leak:** Tắt toàn bộ `warn()` và `print()` nội bộ, loại bỏ nguy cơ bị phát hiện qua `LogService.MessageOut` hoặc bảng console F9.
- **AST Protection:** Mã nguồn core (`kaitun.luau`) được mã hóa chuỗi động, xáo trộn biến và bảo vệ toàn bộ cấu trúc định danh.
- **Private IO Guard:** Tự động phát hiện và ngăn chặn hook các API nhạy cảm (`request`, `readfile`, `writefile`).
