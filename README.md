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
    DownloadTimeout = 30, -- Seconds per payload download; range 5-120.
    Delay = 5, -- Seconds before retrying.
}
```

The bootstrap retries failed payload downloads or compilation once. Once the core starts, its embedded supervisor handles startup errors and timeouts. Ready is marked after worker startup. Before retrying, it cancels owned tasks, disconnects owned signals and destroys owned HUD GUIs. If cleanup fails, it stops recovery to avoid overlapping instances. Worker errors after ready do not trigger whole-script re-execution.

Inspect AA_LOADER_STATE, AA_EXECUTE_STATE, ExecuteState in AA_Live_Stats.json and AA_Execute_State.json in the executor workspace. Retry diagnostics exclude webhook URLs and raw exception text.

Existing loaders pointing directly to main.luau still receive the embedded startup retry. To also retry payload download/compilation, use loader.luau as shown above. The first download of loader.luau itself remains the responsibility of the executor/autoexec.

Validated with 251 core/recovery tests plus 10 isolated loader-diagnostics tests, Luau compilation and obfuscated recovery simulations. Live Volt VPS validation is pending.

Loader diagnostics now run independently of the Kaitun core. Keep the same `loader.luau` URL and existing KaitunConfig. A local `AA_Execution_Probe_<session-id>.json` file is written in the executor workspace on entry and every 2 seconds. It records the loader stage, heartbeat sequence, core startup state, supported APIs and a sanitized error category/line. It does not export webhook URLs, cookies, usernames or raw exceptions, and it does not read the native Volt console.

```lua
getgenv().KaitunConfig.Diagnostics = {
    Enabled = true,
    Interval = 2, -- Seconds, range 1-30.
    Duration = 0, -- 0 continues for this Lua VM; a positive value limits seconds.
}
```

If a download hangs, it is cancelled at DownloadTimeout before retry. If cancellation fails, the loader stops retrying instead of accumulating blocked downloads. Compile errors and payload startup failures are also recorded. A successfully launched core still owns its startup recovery.

Diagnostics require this loader to execute at least once. They cannot observe an uninjected/nonexecuting VM, or recover a Volt lease by themselves. The outer `game:HttpGet` that first downloads `loader.luau` runs before these diagnostics. A Windows observer is still required to establish that no current Lua acknowledgement was received; missing files alone do not prove injection failure.

For the optional Windows challenge/response observer, matching diagnostic replies echo `RunId` from `AA_Diagnostic_Request.json` (Protocol 1). Replies have per-VM SessionId and an advancing Sequence, so old files are not treated as proof of a live VM. `VoltConsoleVisible=false` explicitly separates Lua diagnostics from native executor logs. These files stay local and should not be committed.

Development tests: Python with `lupa`, then `python -m unittest discover -s tests -q`. No network requests or executor processes are used by those tests.

The core also handles local-player `TeleportInitFailed` events during ordinary map transitions, including unexpected teleport failures reported as error 769. It releases stale teleport/in-flight flags, deduplicates failure events for the same request and waits before retrying. A visible 769 prompt is treated as a failed transition, rather than starting a second disconnect/rejoin controller. Lobby queue requests pause during active teleports, rejoin recovery and retry cooldowns.

```lua
getgenv().KaitunConfig.TeleportRecovery = {
    Enabled = true,
    MaxAttempts = 3,
    RetryDelay = 8,
    FloodDelay = 20,
}
```

These values are defaults; adding them to your config is optional. An active teleport is never duplicated. Unauthorized/invalid destinations and exhausted retry budgets stop recovery, with `NeedsExternalRestart` recorded. Details are in `MatchTransitionState.LastTeleportFailure` inside AA_Live_Stats.json. The build is `teleport-769-recovery-v1`. Recovery cannot override Roblox access controls or guarantee success during a Roblox/network outage. The original farming/reward/summon order is preserved.
