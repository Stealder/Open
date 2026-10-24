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
    Mode = "Infinite",
    TargetInfiniteMap = "namek_infinite",
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
            SpendMode = "AllGems",
            ReserveAmount = 10000,
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
