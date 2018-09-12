function init()
	include("ban_sync/config/config.lua")
	include("ban_sync/server/listener.lua")
	include("ban_sync/server/mysql.lua")
end
hook.Add("ULXLoaded", "Load BSync", init) -- We are basically a ULX module, because everything we do relies on ULX, so we wait until ULX has loaded before we start.