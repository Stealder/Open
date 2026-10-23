-- Portable Potassium/Volt bootstrap. Existing KaitunConfig is preserved.
-- Run this loader after injection; it cannot inject the executor itself.
local env = getgenv()
if env.AA_KAITUN_LOADER_LOADING or env.AA_KAITUN_LOADED then return end
env.AA_KAITUN_LOADER_LOADING = true
local options = env.KaitunConfig and env.KaitunConfig.ExecuteRetry or {}
local function bounded(value, fallback, minimum, maximum)
    value = tonumber(value)
    if not value or value ~= value then value = fallback end
    return math.max(minimum, math.min(maximum, math.floor(value)))
end
local limit = options.Enabled == false and 1 or bounded(options.MaxAttempts, 2, 1, 3)
local delay = bounded(options.Delay, 5, 1, 30)
local state = { Phase = "loading", Attempt = 0, MaxAttempts = limit }
env.AA_LOADER_STATE = state
local ok = pcall(function()
    for number = 1, limit do
        state.Attempt = number
        local fetched, source = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/Stealder/Open/main/main.luau")
        end)
        if fetched and type(source) == "string" and #source > 0 then
            local compiled, chunk = pcall(loadstring, source)
            if compiled and type(chunk) == "function" then
                local executed = pcall(chunk)
                if executed and env.AA_KAITUN_LOADED then state.Phase = "accepted"; return end
                state.Reason = "execute-failed"
                -- An active core supervisor owns runtime retries; never launch another beside it.
                if env.AA_KAITUN_LOADED then state.Phase = "core-active"; return end
            else state.Reason = "compile-failed" end
        else state.Reason = "download-failed" end
        if number < limit then state.Phase = "retry-wait"; task.wait(delay) end
    end
    state.Phase = "failed"
end)
if not ok then state.Phase, state.Reason = "failed", "loader-error" end
env.AA_KAITUN_LOADER_LOADING = false
