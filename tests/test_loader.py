"""Isolated loader tests: no network, Roblox, Volt or filesystem side effects."""
from pathlib import Path
import json
import unittest

from lupa import LuaRuntime

SOURCE = (Path(__file__).resolve().parents[1] / "loader.luau").read_text(encoding="utf-8")
MOCK = r'''
now=0;entries={};files={};cancelled=0;fetches=0;executions=0
env={KaitunConfig={Custom="keep",ExecuteRetry={MaxAttempts=2,DownloadTimeout=5,Delay=1}}}
function getgenv() return env end
function warn() end
os={clock=function() return now end,time=function() return 1000+math.floor(now) end}
challenge={Protocol=1,RunId="current-run"}
function readfile(path) return "request" end
function writefile(path,text) files[path]=text end
function identifyexecutor() return "MockExecutor" end
service={}
function service:GenerateGUID() return "test-session" end
function service:JSONEncode(value) return encode(value) end
function service:JSONDecode(raw) return challenge end
game={PlaceId=8304191830,GetService=function() return service end}
function game:HttpGet(url) fetches=fetches+1;return "payload" end
function loadstring(source)
    return function() executions=executions+1;env.AA_KAITUN_LOADED=true end
end
task={}
local function resume(entry)
    local ok,delay=coroutine.resume(entry.thread);assert(ok,delay)
    entry.due=now+(tonumber(delay) or 0.05)
end
local function schedule(fn,delay,immediate)
    local entry={thread=coroutine.create(fn),due=now+(delay or 0)}
    entries[entry.thread]=entry
    if immediate then resume(entry) end
    return entry.thread
end
function task.spawn(fn) return schedule(fn,0,true) end
function task.wait(seconds) return coroutine.yield(seconds or 0.05) end
function task.cancel(thread)
    if failCancel then error("cancel unavailable") end
    cancelled=cancelled+1;entries[thread].cancelled=true
    local ok,err=coroutine.close(thread);assert(ok,err)
end
function advance(seconds)
    local target=now+seconds
    while now<target do
        now=math.min(target,now+0.05)
        local ready={}
        for _,entry in pairs(entries) do
            if not entry.cancelled and coroutine.status(entry.thread)=="suspended" and entry.due<=now+0.000001 then
                table.insert(ready,entry)
            end
        end
        for _,entry in ipairs(ready) do
            if not entry.cancelled and coroutine.status(entry.thread)=="suspended" then resume(entry) end
        end
    end
end
'''


def convert(value):
    if hasattr(value, "items"):
        return {str(k): convert(v) for k, v in value.items()}
    return value


class LoaderDiagnosticsTests(unittest.TestCase):
    def scenario(self, setup=""):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.globals().encode = lambda value: json.dumps(convert(value))
        lua.execute(MOCK + setup + "\nfunction bootstrap()\n" + SOURCE + "\nend\ntask.spawn(bootstrap)")
        return lua

    def test_success_preserves_config_and_writes_current_challenge(self):
        lua = self.scenario()
        lua.execute("advance(3)")
        self.assertEqual(lua.eval("env.KaitunConfig.Custom"), "keep")
        self.assertEqual(lua.eval("executions"), 1)
        self.assertEqual(lua.eval("env.AA_DIAGNOSTIC_STATUS.RunId"), "current-run")
        self.assertEqual(lua.eval("env.AA_LOADER_STATE.Phase"), "accepted")
        self.assertFalse(lua.eval("env.AA_DIAGNOSTIC_STATUS.VoltConsoleVisible"))

    def test_probe_heartbeat_advances_while_download_is_blocked(self):
        lua = self.scenario('game.HttpGet=function() fetches=fetches+1;task.wait(500);return "payload" end\n')
        before = lua.eval("env.AA_DIAGNOSTIC_STATUS.Sequence")
        lua.execute("advance(4)")
        self.assertGreater(lua.eval("env.AA_DIAGNOSTIC_STATUS.Sequence"), before)
        self.assertEqual(lua.eval("env.AA_DIAGNOSTIC_STATUS.Stage"), "download-started")
        self.assertTrue(lua.eval("env.AA_KAITUN_LOADER_LOADING"))

    def test_hung_download_is_cancelled_before_bounded_retry(self):
        lua = self.scenario('game.HttpGet=function() fetches=fetches+1;task.wait(500);return "payload" end\n')
        lua.execute("advance(14)")
        self.assertEqual(lua.eval("fetches"), 2)
        self.assertEqual(lua.eval("cancelled"), 2)
        self.assertEqual(lua.eval("env.AA_LOADER_STATE.Reason"), "download-timeout")
        self.assertFalse(lua.eval("env.AA_KAITUN_LOADER_LOADING"))

    def test_failed_cancellation_does_not_accumulate_downloads(self):
        lua = self.scenario('failCancel=true;game.HttpGet=function() fetches=fetches+1;task.wait(500);return "payload" end\n')
        lua.execute("advance(14)")
        self.assertEqual(lua.eval("fetches"), 1)
        self.assertFalse(lua.eval("env.AA_LOADER_STATE.DownloadWorkerStopped"))
        self.assertEqual(lua.eval("env.AA_LOADER_STATE.Phase"), "failed")

    def test_compile_failure_retries_and_raw_exception_is_redacted(self):
        lua = self.scenario('''loadstring=function(source)
            if fetches==1 then return nil,"chunk.lua:12: private-placeholder" end
            return function() executions=executions+1;env.AA_KAITUN_LOADED=true end
        end\n''')
        lua.execute("advance(4)")
        self.assertEqual(lua.eval("fetches"), 2)
        self.assertEqual(lua.eval("env.AA_LOADER_STATE.Phase"), "accepted")
        report = lua.eval('files["AA_Execution_Probe_test-session.json"]')
        self.assertNotIn("private-placeholder", report)
        self.assertEqual(json.loads(report)["LastErrorLine"], 12)

    def test_failed_execute_retries_once_without_leaking_error(self):
        lua = self.scenario('''loadstring=function(source) return function()
            executions=executions+1
            if executions==1 then error("LEASE_3506: Lease not found private-placeholder") end
            env.AA_KAITUN_LOADED=true
        end end\n''')
        lua.execute("advance(4)")
        self.assertEqual(lua.eval("executions"), 2)
        report = json.loads(lua.eval('files["AA_Execution_Probe_test-session.json"]'))
        self.assertEqual(report["LastErrorClass"], "lease-not-found")
        self.assertNotIn("private-placeholder", json.dumps(report))

    def test_duplicate_loaders_keep_one_probe_and_one_core(self):
        lua = self.scenario()
        lua.execute("task.spawn(bootstrap);advance(3)")
        self.assertEqual(lua.eval("fetches"), 1)
        lua.execute('alive=0;for _,entry in pairs(entries) do if not entry.cancelled and coroutine.status(entry.thread)~="dead" then alive=alive+1 end end')
        self.assertEqual(lua.eval("alive"), 1)

    def test_disabled_diagnostics_do_not_block_core(self):
        lua = self.scenario("env.KaitunConfig.Diagnostics={Enabled=false}\n")
        self.assertEqual(lua.eval("executions"), 1)
        self.assertIsNone(lua.eval('files["AA_Execution_Probe_test-session.json"]'))

    def test_unavailable_file_io_does_not_block_core(self):
        lua = self.scenario("writefile=nil\n")
        lua.execute("advance(3)")
        self.assertEqual(lua.eval("executions"), 1)
        self.assertGreater(lua.eval("env.AA_DIAGNOSTIC_STATUS.WriteErrors"), 0)

    def test_new_challenge_and_native_core_state_are_observed(self):
        lua = self.scenario()
        lua.execute('challenge.RunId="new-run";env.AA_EXECUTE_STATE={Phase="ready",Ready=true,Attempt=1};advance(3)')
        self.assertEqual(lua.eval("env.AA_DIAGNOSTIC_STATUS.RunId"), "new-run")
        self.assertTrue(lua.eval("env.AA_DIAGNOSTIC_STATUS.Core.Ready"))

    def test_map_entry_state_is_captured_independently_of_core_ready(self):
        lua = self.scenario('''game.JobId="current-job"
        env.AA_LAST_RUNTIME_SNAPSHOT={PlaceId=game.PlaceId,JobId=game.JobId,MatchTransitionState={
            EntryPending=false,FailureCount=1,LobbyEntry={Mode="Infinite",LevelKey="namek_infinite",Phase="failed"},
            LastTeleportFailure={Code=769}}}
        env.AA_EXECUTE_STATE={Phase="ready",Ready=true}\n''')
        self.assertTrue(lua.eval("env.AA_DIAGNOSTIC_STATUS.Core.Ready"))
        self.assertEqual(lua.eval("env.AA_DIAGNOSTIC_STATUS.MapEntry.LastErrorCode"),769)
        self.assertEqual(lua.eval("env.AA_DIAGNOSTIC_STATUS.MapEntry.Phase"),"failed")

    def test_previous_job_map_entry_is_not_reported_as_current(self):
        lua = self.scenario('''game.JobId="current-job"
        env.AA_LAST_RUNTIME_SNAPSHOT={PlaceId=game.PlaceId,JobId="previous-job",MatchTransitionState={
            LobbyEntry={Mode="Story",LevelKey="namek_level_1",Phase="failed"}}}\n''')
        self.assertIsNone(lua.eval("env.AA_DIAGNOSTIC_STATUS.MapEntry"))


if __name__ == "__main__":
    unittest.main()
