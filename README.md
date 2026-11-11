```lua
getgenv().KaitunConfig = {
    Kaitun = true,
    AutoSummonEarlyGame = true,
    Mode = "Event", -- Mode chinh sau khi xong Daily Challenge: "Event", "Story", hoac "Infinite"
    TargetInfiniteMap = "namek_infinite",

    -- 1. DAILY CHALLENGE (Setting uu tien: Chay xong Daily Challenge truoc roi tu dong chuyen vao Mode chinh)
    DailyChallenge = {
        Enabled = true,           -- Bat uu tien chay Daily Challenge moi ngay
        AutoMatchmaking = true,   -- Tim tran ghep doi tu dong (__DAILY_CHALLENGE)
        RetryOnDefeat = true,     -- Tu dong thu lai neu that bai cho den khi thang
    },

    -- 2. EVENT SUMMER (Che do Event chinh: San boss, farm Summer Pearls, mo Capsule & quay Banner)
    AutoEvent = {
        Enabled = true,           -- Bat che do Event
        TargetMap = "summer2_event",
        AutoMatchmaking = true,   -- Tim tran ghep doi tu dong phong event
        AutoClaimBoard = true,    -- Tu dong nhan thuong bang nhiem vu / event board
        LeaveLowLevel = true,     -- Tu dong roi phong neu dong doi level qua thap
        MinPlayerLevel = 10,      -- Level toi thieu cua dong doi
        AutoSummon = true,        -- Tu dong quay banner hoac mo capsule
        KeepSummerPearls = 0,     -- So luong Summer Pearls giu lai khong tieu
        Summon = {
            Enabled = true,
            Mode = "Banner",       -- "Banner" (quay bang Summer Pearls) hoac "Inventory" (mo capsule_summer2 trong tui)
            TargetBanner = "Auto", -- "Auto" (tu dong nhan dien Summer banner), hoac chi dinh ten
            CapsuleId = "capsule_summer2",
            KeepSummerPearls = 0,
            StopWhenOutOfPearls = true,
            StopOnMythicOrSecret = true,
        },
    },

    -- 3. STORY MODE (Neu chon Mode = "Story")
    Story = {
        TargetWorld = "Auto",     -- "Auto" hoac map id (vd: "namek", "aot")
        TargetAct = "Auto",       -- "Auto" hoac so act (1..6)
        Difficulty = "Normal",    -- "Normal" hoac "Hard"
        FriendsOnly = false,
        AutoNext = true,
        RetryOnDefeat = true,
    },

    -- 4. IN-GAME MECHANICS (AUTO PLAY)
    AutoPlay = {
        Enabled = true,
        SmartPlace = true,                  -- Dat quan doc theo lane waypoints, tach rieng khong cham nhau (>= 4.5 studs)
        PlaceNearOtherPlayersUnits = false,  -- Dat quan chum lai sat unit dong doi (1.8 - 3.2 studs). Neu bat se tu dong tat SmartPlace
        UpgradeFarmsFirst = true,           -- Uu tien dat CEO & Bulma truoc, nang max farm roi moi dat/nang unit DPS
        SmartFarmUpgrade = false,           -- Nang cap farm thong minh theo thu tu gia re
        AutoAbilities = true,               -- Tu dong dung skill chu dong
        DefendBaseOnLeak = true,            -- Bat co phong thu khan cap khi quai lot ve base
        LeakDistanceThreshold = 75,         -- Khoang cach (studs) tu quai den base de kich hoat thu base
        BuffInfinite = true,                -- Erwin tu dat gan Physical DPS, Wendy tu dat gan Magic DPS; xoay tua buff lien tuc
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

    -- 5. SUMMON & TARGET HUNT
    Summon = {
        FillTeam = {
            Enabled = true,
        },
        TargetHunt = {
            Enabled = false,                 -- Bat/tat san target unit
            TargetUnits = { "Elyssia" },     -- Target unit (Elyssia - Celestial Compass U21)
            TargetBanner = "Special",        -- "Special" (Gems) hoac "Summer" (Summer Pearls)
            gems_amount = 5000,              -- Chi bat dau quay khi so du Gems dat tu muc nay tro len
            AutoUseCompass = true,           -- Tu dong set Celestial Compass (Update 21) cho Elyssia truoc khi quay
            AutoUseLuckBoost = true,         -- Tu dong dung Luck Potion
            AutoBuyLuckBoost = true,
        },
    },

    -- 6. PERFORMANCE & OPTIMIZATION
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
