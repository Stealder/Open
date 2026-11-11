getgenv().KaitunConfig = {
    Diagnostics = {
        Enabled = true,
        Interval = 2,
        Duration = 0,
    },
    ExecuteRetry = {
        Enabled = true,
        MaxAttempts = 2,
        StartupTimeout = 180,
        DownloadTimeout = 30,
        Delay = 5,
    },
    AntiSpy = {
        Enabled = true,
    },
    TrackStats = {
        Enabled = true,
        Folder = "TrackStats",
        Interval = 10,
    },
    Kaitun = true,
    AutoSummonEarlyGame = true,
    Mode = "Story", -- "Story", "Infinite", "Event", or "DailyChallenge"
    TargetInfiniteMap = "namek_infinite",

    -- 1. DAILY CHALLENGE (Uu tien so 1 tuyet doi neu duoc bat)
    DailyChallenge = {
        Enabled = false,          -- Neu bat: Luon uu tien lam xong Daily Challenge truoc Story, Event, Infinite
        AutoMatchmaking = true,   -- Tim tran tu dong qua __DAILY_CHALLENGE
        RetryOnDefeat = true,     -- Tu dong thu lai neu that bai cho den khi thang
    },

    -- 2. STORY MODE
    Story = {
        TargetWorld = "Auto",     -- "Auto" or map id (e.g. "namek", "aot")
        TargetAct = "Auto",       -- "Auto" or act number (1..6)
        Difficulty = "Normal",    -- "Normal" or "Hard"
        FriendsOnly = false,
        AutoNext = true,
        RetryOnDefeat = true,
    },

    -- 3. IN-GAME MECHANICS
    AutoPlay = {
        Enabled = true,
        SmartPlace = true,                  -- Dat quan thong minh doc theo duong lane, tach rieng khong dung nhau (>= 4.5 studs)
        PlaceNearOtherPlayersUnits = false,  -- Dat quan chum lai sat vi tri unit dong doi (1.8 - 3.2 studs). Neu bat se tu dong tat SmartPlace
        UpgradeFarmsFirst = true,           -- Uu tien dat CEO & Bulma truoc, nang max farm roi moi dat/nang unit DPS
        SmartFarmUpgrade = false,           -- Nang cap farm thong minh theo thu tu toi uu gia
        AutoAbilities = true,
        DefendBaseOnLeak = true,            -- Bat/tat co phong thu khan cap khi lot quai ve base
        LeakDistanceThreshold = 75,         -- Nguong khoang cach (studs) tu quai den nha de kich hoat thu khan cap
        BuffInfinite = true,                -- Buff vo han: Erwin tu dat gan unit Physical DPS, Wendy tu dat gan unit Magic DPS
    },

    AutoStart = true,
    AutoSkipWave = true,
    AutoClaimBattlepass = true,
    AutoClaimDailyRewards = true,
    LevelRewardMilestones = { 5, 10, 15, 20, 25, 30 },
    LobbyRewards = {
        ReturnEveryInfiniteMatches = 4,
        Timeout = 25,
        UIWait = 5,
    },
    RedeemCodes = {
        Enabled = true,
        List = { "APRILFOOLS", "UPDATESOON5189" },
        Delay = 1,
        Timeout = 10,
        RequestTimeout = 5,
    },
    AutoRejoin = {
        Enabled = true,
        LobbyPlaceId = 8304191830,
        Delay = 8,
        RetryDelay = 30,
        MaxAttempts = 3,
        WaveStartTimeout = 120,
    },
    TeleportRecovery = {
        Enabled = true,
        MaxAttempts = 3,
        RetryDelay = 8,
        FloodDelay = 20,
        EntryTimeout = 60,
        RequestTimeout = 15,
    },
    AutoSell = {
        Enabled = true,
        Wave = 25,
    },
    Summon = {
        FillTeam = {
            Enabled = true,
        },
        TargetHunt = {
            Enabled = false,
            TargetUnits = { "Elyssia" },     -- Target unit (mac dinh Elyssia / Ellysa - Update 21)
            TargetBanner = "Special",        -- "Special" (Gems) hoac "Summer" (Summer Pearls)
            gems_amount = 5000,              -- Chi bat dau quay khi so du Gems dat tu muc nay tro len
            AutoUseCompass = true,           -- Tu dong set Celestial Compass (Update 21) cho target unit truoc khi quay
            AutoUseLuckBoost = true,         -- Tu dong kich hoat Luck Potion
            AutoBuyLuckBoost = true,
        },
    },
    BlackScreen = true,
    DeleteMap = true,
    HideEnemyHealthBars = true,
    ExtremeOptimization = true,
    DisableNotifications = true,
    SecurityMode = true,
    HidePlayerInfo = true,
    Webhook = {
        Enabled = false,
        Url = "",
        PingUser = false,
        PingUserId = ""
    }
}
