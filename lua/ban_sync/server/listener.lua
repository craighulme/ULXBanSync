--[[
	Function: listen

	Waits and listens for a new ULib ban to be registered/edited/deleted. When this happens, we sync it.
]]
local function listen(steamid, bandata_or_admin)
    if not bsync.enabled then return end
    local bdata = nil
    local admin = nil

    if type(bandata_or_admin) == "table" then
        bdata = bandata_or_admin
    elseif type(bandata_or_admin) == "string" then
        admin = bandata_or_admin
    end

    if bdata then
        bsync.queue_func(bsync.sync, bdata)
    elseif admin then
        bsync.queue_func(bsync.remove, steamid)
    end
end

hook.Add("ULibUserBanned", "bsync_listen_for_ban", listen)
hook.Add("ULibUserUnbanned", "bsync_listen_for_unban", listen)