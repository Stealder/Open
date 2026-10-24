-- Loader diagnostics are local-only; no credentials, username or raw exceptions are exported.
local diagnosticConfig=type(getgenv().KaitunConfig)=="table" and getgenv().KaitunConfig.Diagnostics
local DIAGNOSTIC_SECONDS=type(diagnosticConfig)=="table" and tonumber(diagnosticConfig.Duration) or 0
if not DIAGNOSTIC_SECONDS or DIAGNOSTIC_SECONDS~=DIAGNOSTIC_SECONDS then DIAGNOSTIC_SECONDS=0 end
DIAGNOSTIC_SECONDS=math.max(0,math.min(86400,DIAGNOSTIC_SECONDS))
local executionDiagnostics = (function()
    local env = getgenv()
    local previous = env.AA_EXECUTION_DIAGNOSTICS
    if type(previous) == "table" and previous.Running then
        previous.EndAt = DIAGNOSTIC_SECONDS==0 and 0 or os.clock()+DIAGNOSTIC_SECONDS
        return previous
    end
    local nativeTask, write, read = task, writefile, readfile
    local service = game:GetService("HttpService")
    local function enabled()
        local config = type(env.KaitunConfig) == "table" and env.KaitunConfig.Diagnostics
        return type(config) ~= "table" or config.Enabled ~= false
    end
    local phases = {
        ["manual-probe"]=true,["loader-entered"]=true,["download-started"]=true,
        ["download-failed"]=true,["download-timeout"]=true,["compile-started"]=true,
        ["compile-failed"]=true,["payload-executing"]=true,["payload-no-ack"]=true,
        ["loader-accepted"]=true,["loader-failed"]=true,["core-entered"]=true,
        ["core-waiting-game"]=true,["core-starting"]=true,["core-ready"]=true,
        ["core-failed"]=true,["core-retry-wait"]=true,["core-teleporting"]=true,["probe-stopped"]=true,
    }
    local corePhases = { ["waiting-game"]=true,starting=true,ready=true,failed=true,["retry-wait"]=true,teleporting=true }
    local loaderPhases = { loading=true,["retry-wait"]=true,failed=true,accepted=true,["core-active"]=true }
    local report = { Protocol=1,Build="loader-diagnostics-v1",Stage="manual-probe",Sequence=0,
        WriteErrors=0,VoltConsoleVisible=false,Capabilities={
            ReadFile=type(read)=="function",WriteFile=type(write)=="function",
            LoadString=type(loadstring)=="function",TaskSpawn=type(nativeTask.spawn)=="function",
        } }
    local diag = { Running=false,EndAt=DIAGNOSTIC_SECONDS==0 and 0 or os.clock()+DIAGNOSTIC_SECONDS }
    local started = os.clock()
    local ok, id = pcall(function() return service:GenerateGUID(false) end)
    if not ok or type(id) ~= "string" then
        id = string.format("%x%x%x",os.time(),math.floor(os.clock()*1000),math.random(1,1000000))
    end
    report.SessionId = id:gsub("[^%w%-]", ""):sub(1,64)
    report.Executor = "unknown"
    pcall(function()
        local name = identifyexecutor and identifyexecutor()
        if type(name)=="string" then
            name=name:lower()
            for _, known in ipairs({"volt","potassium","delta"}) do
                if name:find(known,1,true) then report.Executor=known;break end
            end
        end
    end)
    local path = "AA_Execution_Probe_" .. report.SessionId .. ".json"
    local function number(value)
        return type(value)=="number" and value==value and math.abs(value)<math.huge and value or nil
    end
    function diag.Classify(detail)
        local text = type(detail)=="string" and detail:lower() or ""
        local category = "runtime-error"
        if text:find("lease_3506",1,true) or text:find("lease not found",1,true) then category="lease-not-found"
        elseif text:find("[aa:private_io]",1,true) then category="private-io-error"
        elseif text:find("timed out",1,true) or text:find("timeout",1,true) then category="timeout"
        elseif text:find("429",1,true) then category="http-rate-limit"
        elseif text:find("403",1,true) then category="http-forbidden"
        elseif text:find("nil value",1,true) or text:find("index nil",1,true) then category="nil-access"
        elseif text:find("not a valid member",1,true) then category="missing-instance-member" end
        return category, tonumber(text:match(":(%d+):"))
    end
    function diag.Flush()
        if not enabled() then return false end
        report.Sequence=report.Sequence+1
        report.Timestamp,report.Uptime=os.time(),os.clock()-started
        report.PlaceId=number(game.PlaceId)
        if type(read)=="function" then
            pcall(function()
                local raw=read("AA_Diagnostic_Request.json")
                if type(raw)~="string" or #raw>4096 then return end
                local request=service.JSONDecode(service,raw)
                local run=type(request)=="table" and request.RunId
                if request.Protocol==1 and type(run)=="string" and #run<=64 and run:match("^[%w%-]+$") then
                    report.RunId=run
                end
            end)
        end
        local core=env.AA_EXECUTE_STATE
        report.Core=type(core)=="table" and {
            Phase=corePhases[core.Phase] and core.Phase or "unknown",Ready=core.Ready==true,
            Attempt=number(core.Attempt),Heartbeat=number(core.Heartbeat),WorkerErrors=number(core.WorkerErrors),
        } or nil
        local loader=env.AA_LOADER_STATE
        report.Loader=type(loader)=="table" and {
            Phase=loaderPhases[loader.Phase] and loader.Phase or "unknown",Attempt=number(loader.Attempt),
        } or nil
        env.AA_DIAGNOSTIC_STATUS=report
        if type(write)~="function" then report.WriteErrors=report.WriteErrors+1;return false end
        local saved=pcall(function() write(path,service.JSONEncode(service,report)) end)
        if not saved then report.WriteErrors=report.WriteErrors+1 end
        return saved
    end
    function diag.Mark(stage)
        report.Stage=phases[stage] and stage or report.Stage
        diag.Flush()
    end
    function diag.Error(detail)
        report.LastErrorClass,report.LastErrorLine=diag.Classify(detail)
        diag.Flush()
    end
    env.AA_EXECUTION_DIAGNOSTICS=diag
    if enabled() then
        diag.Flush()
        pcall(function() warn("[AA:DIAG] Lua entered; session=" .. report.SessionId) end)
        if type(nativeTask.spawn)=="function" and type(nativeTask.wait)=="function" then
            diag.Running=true
            nativeTask.spawn(function()
                while env.AA_EXECUTION_DIAGNOSTICS==diag and enabled() and not env.AA_DIAGNOSTIC_STOP and (diag.EndAt==0 or os.clock()<diag.EndAt) do
                    local config=type(env.KaitunConfig)=="table" and env.KaitunConfig.Diagnostics
                    local interval=type(config)=="table" and tonumber(config.Interval) or 2
                    interval=interval and interval==interval and math.max(1,math.min(30,interval)) or 2
                    nativeTask.wait(interval)
                    if env.AA_EXECUTION_DIAGNOSTICS==diag then pcall(diag.Flush) end
                end
                report.Stopped=true; report.Stage="probe-stopped";pcall(diag.Flush)
                diag.Running=false
            end)
        end
    end
    return diag
end)()
-- END EXECUTION DIAGNOSTICS

do
-- Portable Potassium/Volt bootstrap. It observes Lua execution, not injection.
local env, loaderTask = getgenv(), task
if env.AA_KAITUN_LOADER_LOADING or env.AA_KAITUN_LOADED then return end
env.AA_KAITUN_LOADER_LOADING = true
executionDiagnostics.Mark("loader-entered")
local options = type(env.KaitunConfig)=="table" and env.KaitunConfig.ExecuteRetry or {}
if type(options)~="table" then options={} end
local function bounded(value, fallback, minimum, maximum)
    value=tonumber(value)
    if not value or value~=value then value=fallback end
    return math.max(minimum,math.min(maximum,math.floor(value)))
end
local limit=options.Enabled==false and 1 or bounded(options.MaxAttempts,2,1,3)
local delay=bounded(options.Delay,5,1,30)
local timeout=bounded(options.DownloadTimeout,30,5,120)
local state={Phase="loading",Attempt=0,MaxAttempts=limit,DownloadTimeout=timeout}
env.AA_LOADER_STATE=state
local function fetch()
    local done,fetched,source=false,false,nil
    local thread=loaderTask.spawn(function()
        fetched,source=pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/Stealder/Open/main/main.luau")
        end)
        done=true
    end)
    local deadline=os.clock()+timeout
    while not done and os.clock()<deadline do loaderTask.wait(0.1) end
    if not done then
        state.DownloadWorkerStopped=type(loaderTask.cancel)=="function" and pcall(loaderTask.cancel,thread) or false
        return false,nil,"download-timeout",state.DownloadWorkerStopped
    end
    return fetched,source,"download-failed",true
end
local ok,detail=pcall(function()
    for number=1,limit do
        state.Attempt,state.Phase=number,"loading"
        executionDiagnostics.Mark("download-started")
        local fetched,source,reason,retryable=fetch()
        if fetched and type(source)=="string" and #source>0 then
            executionDiagnostics.Mark("compile-started")
            local compiled,chunk,compileError=pcall(loadstring,source)
            if compiled and type(chunk)=="function" then
                executionDiagnostics.Mark("payload-executing")
                local executed,executeError=pcall(chunk)
                if executed and env.AA_KAITUN_LOADED then
                    state.Phase="accepted"
                    executionDiagnostics.Mark("loader-accepted")
                    return
                end
                state.Reason=executed and "payload-no-startup-ack" or "execute-failed"
                if not executed then executionDiagnostics.Error(executeError) end
                executionDiagnostics.Mark("payload-no-ack")
                if env.AA_KAITUN_LOADED then state.Phase="core-active";return end
            else
                state.Reason="compile-failed"
                executionDiagnostics.Error(compiled and compileError or chunk)
                executionDiagnostics.Mark("compile-failed")
            end
        else
            state.Reason=reason
            executionDiagnostics.Error(reason=="download-timeout" and "download timeout" or source)
            executionDiagnostics.Mark(reason)
        end
        if retryable==false then break end -- Do not accumulate uncancellable blocked downloads.
        if number<limit then state.Phase="retry-wait";loaderTask.wait(delay) end
    end
    state.Phase="failed"
end)
if not ok then
    state.Phase,state.Reason="failed","loader-error"
    executionDiagnostics.Error(detail)
end
env.AA_KAITUN_LOADER_LOADING=false
if state.Phase=="failed" then executionDiagnostics.Mark("loader-failed") else executionDiagnostics.Flush() end

end
