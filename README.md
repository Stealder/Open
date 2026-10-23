```lua
getgenv().KaitunConfig = {
    Kaitun = true,
    Mode = "Infinite",
    TargetInfiniteMap = "namek_infinite",
    AutoPlace = true,
    AutoUpgrade = true,
    AutoStart = true,
    AutoSkipWave = true,
    AutoClaimBattlepass = true,
    AutoClaimDailyRewards = true,
    RedeemCodes = {
        Enabled = true,
        List = {}
    },
    AutoSell = {
        Enabled = true,
        Wave = 25
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/Stealder/Open/main/main.luau"))()
```
