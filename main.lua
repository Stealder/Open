-- ===================================================================
-- ANIME ADVENTURES KAITUN - LOADER & CONFIGURATION
-- Chỉnh sửa cấu hình trực tiếp tại bảng bên dưới trước khi chạy:
-- ===================================================================

getgenv().KaitunConfig = {
    -- 1. Chế độ cày cuốc (Progression & Combat)
    Kaitun = true,                  -- Bật/Tắt tự động cày Kaitun
    Mode = "Infinite",              -- "Infinite" (Farm gem liên tục) hoặc "Story" (Tự động leo Story)
    TargetInfiniteMap = "namek_infinite", -- Map farm Infinite (mặc định: namek_infinite [Planet Greenie Hard])
    AutoPlace = true,               -- Tự động đặt tất cả Unit đã trang bị
    AutoUpgrade = true,             -- Tự động nâng cấp Unit trong trận lên max level
    AutoStart = true,               -- Tự động bấm Vote Start khi vào trận
    AutoSkipWave = true,            -- Tự động bấm Vote Skip Wave
    AutoClaimBattlepass = true,     -- Tự động nhận quà Battlepass định kỳ
    AutoClaimDailyRewards = true,   -- Tự động nhận quà điểm danh hàng ngày, quà lên cấp, first clear

    -- 2. Tự động bán Unit để thua & replay nhanh (Tối ưu farm Gems/giờ)
    AutoSell = {
        Enabled = true,             -- Bật/Tắt tự động bán unit để kết thúc trận nhanh
        Wave = 25,                  -- Đến Wave này sẽ bán sạch unit trên sân và ngừng đặt mới
    },

    -- 3. Tối ưu hóa & Ẩn danh (Optimization & Stealth)
    BlackScreen = true,             -- Bật màn hình tối giảm 90% GPU/RAM, hiển thị Live HUD
    DeleteMap = true,               -- Xóa cảnh quan map (giữ sàn an toàn) giúp FPS cực cao
    HideEnemyHealthBars = true,     -- Ẩn thanh máu quái vật để giảm tải UI
    ExtremeOptimization = true,     -- Triệt tiêu VFX kỹ năng, ép SmoothPlastic, tắt sóng nước
    DisableNotifications = true,    -- Chặn toàn bộ thông báo popup làm phiền
    SecurityMode = true,            -- Tự động rời trận về Lobby ngay khi phát hiện người lạ vào phòng
    HidePlayerInfo = true,          -- Ẩn tên và ngoại hình nhân vật

    -- 4. Discord Webhook thông báo kết quả trận đấu
    Webhook = {
        Enabled = false,            -- Bật/Tắt gửi webhook Discord khi kết thúc trận
        Url = "",                   -- Dán URL Discord Webhook vào đây
        PingUser = false,           -- Có ping Discord User không (true/false)
        PingUserId = ""             -- Discord User ID nếu muốn ping
    }
}

-- Tải và thực thi core engine đã mã hóa từ GitHub (Chạy ẩn ngầm, 0 leak log console)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Stealder/Open/main/kaitun.luau"))()
