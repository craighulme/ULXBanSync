function init()
    if bsync.enabled then
        include("ban_sync/config/config.lua")
        include("ban_sync/server/listener.lua")
        include("ban_sync/server/mysql.lua")
        include("ban_sync/server/util.lua")

        if not ULib.fileExists("data/mysql_ban_sync/last_clean.txt") then
            ULib.fileWrite("data/mysql_ban_sync/last_clean.txt", tostring(CurTime()))
        else
            ServerLog("Cleaning expired bans...")

            -- We check once a week
            if CurTime() >= tonumber(ULib.fileRead("data/mysql_ban_sync/last_clean.txt")) + 604800 then
                bsync.queue_func(bsync.cleanup)
            end
        end

        bsync.queue_func(bsync.msyql_init)
    end
end

hook.Add("ULXLoaded", "Load BSync", init) -- We are basically a ULX module, because everything we do relies on ULX, so we wait until ULX has loaded before we start.