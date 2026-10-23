-- ===================================================================
-- ANIME ADVENTURES KAITUN - ONE-CLICK LOADER & CONFIGURATION
-- Đặt file này vào thư mục autoexec hoặc chạy trực tiếp trong Executor
-- ===================================================================

getgenv().KaitunConfig = {
    -- 1. Chế độ cày cuốc (Progression & Combat)
    Kaitun = true,                  -- Bật tự động cày Kaitun
    Mode = "Infinite",              -- "Infinite" (Farm gem liên tục) hoặc "Story" (Leo map Story)
    TargetInfiniteMap = "namek_infinite", -- Map farm Infinite (mặc định: namek_infinite [Hard])
    AutoPlace = true,               -- Tự động đặt Unit đã trang bị
    AutoUpgrade = true,             -- Tự động nâng cấp Unit lên max level
    AutoStart = true,               -- Tự động bấm Vote Start
    AutoSkipWave = true,            -- Tự động bấm Vote Skip Wave
    AutoClaimBattlepass = true,     -- Tự động nhận quà Battlepass
    AutoClaimDailyRewards = true,   -- Tự động nhận quà điểm danh hàng ngày

    -- 2. Tự động bán Unit để thua & replay nhanh (Tối ưu farm Gems/giờ)
    AutoSell = {
        Enabled = true,             -- Bật tự động bán unit để replay nhanh
        Wave = 25,                  -- Đạt Wave này sẽ bán sạch unit trên sân
    },

    -- 3. Tối ưu hóa & Ẩn danh (Optimization & Stealth)
    BlackScreen = true,             -- Màn hình tối giảm 90% GPU/RAM, hiển thị Live HUD
    DeleteMap = true,               -- Xóa cảnh quan map giúp FPS cực cao
    HideEnemyHealthBars = true,     -- Ẩn thanh máu quái vật
    ExtremeOptimization = true,     -- Triệt tiêu VFX kỹ năng, ép SmoothPlastic
    DisableNotifications = true,    -- Chặn toàn bộ thông báo popup làm phiền
    SecurityMode = true,            -- Tự động rời trận về Lobby khi phát hiện người lạ
    HidePlayerInfo = true,          -- Ẩn tên và ngoại hình nhân vật

    -- 4. Discord Webhook thông báo kết quả
    Webhook = {
        Enabled = false,            -- Bật/Tắt gửi webhook Discord khi kết thúc trận
        Url = "",                   -- Dán URL Discord Webhook vào đây
        PingUser = false,           -- Có ping người dùng không
        PingUserId = ""             -- Discord User ID nếu muốn ping
    }
}

-- Tải và thực thi core script đã mã hóa (chạy ẩn ngầm, 0 leak log console)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Stealder/Open/main/kaitun.luau"))()
