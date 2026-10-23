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

loadstring(game:HttpGet("https://raw.githubusercontent.com/Stealder/Open/main/loader.luau"))()
```

Startup recovery supports Potassium and Volt after injection. The loader does not inject the executor.

Add this configuration before the loadstring call:

```lua
getgenv().KaitunConfig.ExecuteRetry = {
    Enabled = true,
    MaxAttempts = 2, -- Initial attempt plus one retry.
    StartupTimeout = 180, -- Seconds after game and LocalPlayer readiness.
    Delay = 5, -- Seconds before retrying.
}
```

The bootstrap retries failed payload downloads or compilation once. Once the core starts, its embedded supervisor handles startup errors and timeouts. Ready is marked after worker startup. Before retrying, it cancels owned tasks, disconnects owned signals and destroys owned HUD GUIs. If cleanup fails, it stops recovery to avoid overlapping instances. Worker errors after ready do not trigger whole-script re-execution.

Inspect AA_LOADER_STATE, AA_EXECUTE_STATE, ExecuteState in AA_Live_Stats.json and AA_Execute_State.json in the executor workspace. Retry diagnostics exclude webhook URLs and raw exception text.

Existing loaders pointing directly to main.luau still receive the embedded startup retry. To also retry payload download/compilation, use loader.luau as shown above. The first download of loader.luau itself remains the responsibility of the executor/autoexec.

Validated with 235 local tests, source/obfuscated Luau compilation and an obfuscated recovery simulation. Live Volt VPS validation is pending.
