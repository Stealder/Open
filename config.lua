-- ===================================================================
-- ANIME ADVENTURES KAITUN - CONFIGURATION TEMPLATE
-- Chỉnh sửa các giá trị bên dưới theo nhu cầu của bạn
-- ===================================================================

getgenv().KaitunConfig = {
    -- 1. Chế độ cày cuốc (Progression & Combat)
    Kaitun = true,                  -- Bật/Tắt chế độ tự động cày Kaitun
    Mode = "Infinite",              -- "Infinite" (Farm gem liên tục) hoặc "Story" (Tự động leo Story)
    TargetInfiniteMap = "namek_infinite", -- Map farm Infinite (mặc định: namek_infinite [Planet Greenie])
    AutoPlace = true,               -- Tự động đặt tất cả Unit đã trang bị
    AutoUpgrade = true,             -- Tự động nâng cấp Unit trong trận lên max level
    AutoStart = true,               -- Tự động bấm Vote Start khi vào trận
    AutoSkipWave = true,            -- Tự động bấm Vote Skip Wave
    AutoClaimBattlepass = true,     -- Tự động nhận quà Battlepass định kỳ
    AutoClaimDailyRewards = true,   -- Tự động nhận quà điểm danh hàng ngày, quà lên cấp, first clear
    LevelRewardMilestones = { 5, 10, 15, 20, 25, 30 }, -- Các mốc cấp nhận thưởng

    LobbyRewards = {
        ReturnEveryInfiniteMatches = 1, -- 1: về Lobby sau mỗi trận; 3: replay 2 trận rồi về; 0: chỉ replay
        Timeout = 25,                  -- Giới hạn thời gian chờ nhận quà ở Lobby (giây)
        UIWait = 5,                    -- Thời gian chờ UI khởi tạo
    },

    RedeemCodes = {
        Enabled = true,                -- Tự động nhập giftcode khi ở Lobby
        List = {                       -- Danh sách code muốn nhập
            -- "EXAMPLE_CODE_1",
            -- "EXAMPLE_CODE_2",
        },
        Delay = 1,                     -- Giây giãn cách giữa các code
        Timeout = 10,
        RequestTimeout = 5,
    },

    AutoRejoin = {
        Enabled = true,                -- Tự động kết nối lại khi bị mất kết nối / kick
        LobbyPlaceId = 8304191830,     -- PlaceId của Lobby Anime Adventures
        Delay = 8,                     -- Thời gian chờ trước khi thử vào lại Lobby (giây)
        RetryDelay = 30,               -- Giãn cách thử lại nếu thất bại (giây)
        MaxAttempts = 3,               -- Số lần thử tối đa
        WaveStartTimeout = 120,        -- Quá thời gian này ở Wave 0 sẽ tự động về Lobby
    },

    -- 2. Tự động bán Unit để thua & replay nhanh (Tối ưu farm Gems/giờ)
    AutoSell = {
        Enabled = true,                -- Bật/Tắt tự động bán unit để kết thúc trận nhanh
        Wave = 25,                     -- Đến Wave này sẽ bán sạch unit trên sân và ngừng đặt mới
    },

    -- 3. Hệ thống Summon nâng cao (Summon System)
    Summon = {
        FillTeam = {
            Enabled = false,           -- Tự động summon cho đủ slot đội hình
        },
        TargetHunt = {
            Enabled = false,           -- Bật/Tắt săn unit mục tiêu
            TargetUnits = { "Noel" },  -- Danh sách tên unit cần săn (ví dụ: { "Noel", "Gojo" })
            SpendMode = "AllGems",     -- "AllGems" (quay hết gem) hoặc "ReserveGems" (giữ lại mức gem)
            ReserveAmount = 10000,     -- Số gem tối thiểu giữ lại nếu chọn "ReserveGems"
            AutoUseLuckBoost = true,   -- Tự động dùng Potion tăng Luck trước khi quay
            AutoBuyLuckBoost = true,   -- Tự động mua Potion Luck từ Traveling Merchant
        },
    },

    -- 4. Tối ưu hóa & Ẩn danh (Optimization & Stealth)
    BlackScreen = true,                -- Bật màn hình tối giảm 90% GPU/RAM, hiển thị Live HUD
    DeleteMap = true,                  -- Xóa cảnh quan map (giữ sàn an toàn) giúp FPS cực cao
    HideEnemyHealthBars = true,        -- Ẩn thanh máu quái vật để giảm tải UI
    ExtremeOptimization = true,        -- Triệt tiêu VFX kỹ năng, ép SmoothPlastic, tắt sóng nước
    DisableNotifications = true,       -- Chặn toàn bộ thông báo popup làm phiền
    SecurityMode = true,               -- Tự động rời trận về Lobby ngay khi phát hiện người lạ vào phòng
    HidePlayerInfo = true,             -- Ẩn tên và ngoại hình nhân vật

    -- 5. Discord Webhook thông báo kết quả trận đấu
    Webhook = {
        Enabled = false,               -- Bật/Tắt gửi webhook Discord
        Url = "",                      -- Dán URL Discord Webhook vào đây
        PingUser = false,              -- Có tag/ping tài khoản Discord không
        PingUserId = ""                -- Discord User ID nếu muốn ping
    }
}
