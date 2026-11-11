```lua
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
        AutoPlace = true,
        AutoUpgrade = true,
        AutoAbilities = true,
        SmartFarmUpgrade = true,
        UpgradeFarmsFirst = true,          -- Dat Farm truoc & nang max Farm roi moi dat unit def
        PlaceNearOtherDamageUnits = false, -- Neu false: tu dong dat theo Smart Place doc theo duong quai di (lane waypoints)
        DefendBaseOnLeak = true,           -- Bat/tat co phong thu khan cap khi lot quai
        LeakDistanceThreshold = 75,        -- Nguong khoang cach (studs) tu quai den nha de kich hoat thu khan cap
        BuffInfinite = true,               -- Xoay tua buff vo han cho Erwin, Wendy/Wind Song, Brook
        ErwinBuffRotation = true,          -- Alias tuong thich cho Erwin
    },

    AutoPlace = true,
    AutoUpgrade = true,
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
            TargetUnits = { "Noel" },
            TargetBanner = "Special",       -- "Auto", "Special", "Standard", "EventClover"
            SpendMode = "AllGems",          -- "AllGems" or "ReserveGems"
            ReserveAmount = 10000,
            AutoUseCompass = true,          -- Tu dong dung item Compass truoc khi quay banner
            AutoUseLuckBoost = true,
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/Stealder/Open/main/loader.luau"))()
```
