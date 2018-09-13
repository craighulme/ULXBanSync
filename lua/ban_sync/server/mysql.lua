require"mysqloo"
local db = mysqloo.connect(bsync.mysql.host, bsync.mysql.username, bsync.mysql.password, bsync.mysql.database, bsync.mysql.port)

-- What do do when the Database connects.
function db:onConnected()
    ServerLog("BSync connected successfully.")
    -- This table setup is literally the same as ULibs. Makes syncing SO much easier.
    local query = [[
		CREATE TABLE IF NOT EXISTS bsync_bans (
		    steamid INTEGER NOT NULL PRIMARY KEY,
		    time INTEGER NOT NULL,
		    unban INTEGER NOT NULL,
		    reason TEXT,
		    name TEXT,
		    admin TEXT,
    		modified_admin TEXT,
		    modified_time INTEGER
		);
	]]
    local q = db:query(query)

    function q:onSuccess(data)
        ServerLog("BSync Table Created Successfully.")
    end

    function q:onError(err, _)
        ServerLog("Fatal Error: Could not create BSync table: " .. err)
        bsync.enabled = false
    end

    q:start()
end

function db:onConnectionFailed(err)
    ServerLog("Fatal Error: Could not connect to MySQL Database: " .. err)
    ServerLog("Check your settings. If this problem persists, please post an issue at the GitHub page (https://github.com/iViscosity/ULXBanSync/issues)")
    bsync.enabled = false
end

function bsync.mysql_init()
    db:connect()
    bsync.sync_all()
end

-- Taken from ULib to meet their standards.
local function escapeOrNull(str)
    if not str then
        return "NULL"
    else
        return sql.SQLStr(str)
    end
end

--[[
    Function: sync_all

    Takes all of the current bans (from ULib.bans) and syncs them with the database, then takes everything in the database and puts it in ULib.bans.
]]
function bsync.sync_all()
    ULib.refreshBans() -- Make sure the list we're getting is up to date.
    local ban_data = ULib.bans -- These are all the currently active bans.

    -- Now we sync all the shit. This is expensive because it goes through every single ban. If there's a lot of them, this could cause lag.
    for _, bdata in pairs(ban_data) do
        bsync.sync(bdata)
    end

    local query = "SELECT * FROM bsync_bans"
    local q = db:query(query)

    function q:onSuccess(data)
        for i = 1, #data do
            local row = data[i]
            ULib.bans[row.steamid] = row
        end
    end

    function q:onError(err, _)
        ServerLog("Fatal Error: Could not retrieve ban data from Database: " .. err)
    end

    q:start()
end

--[[
    Function: sync

    Syncs the given ban data with the Database.

    Parameters:

        bdata - The table of ban data.
]]
function bsync.sync(bdata)
    if not bsync.sync_all and bdata.unban - bdata.time < bsync.min_time then return end
    local query = "REPLACE INTO bsync_bans (steamid, time, unban, reason, name, admin, modified_admin, modified_time) " .. string.format("VALUES (%s, %i, %i, %s, %s, %s, %s, %s);", util.SteamIDTo64(bdata.steamID), bdata.time or 0, bdata.unban or 0, escapeOrNull(bdata.reason), escapeOrNull(bdata.name), escapeOrNull(bdata.admin), escapeOrNull(bdata.modified_admin), escapeOrNull(bdata.modified_time))
    local q = db:query(query)

    function q:onSuccess(data)
        ServerLog(bdata.steamID .. "(" .. bdata.name .. ") synced successfully.")
    end

    function q:onError(err, _)
        ServerLog("Fatal Error: Could not update ban data: " .. bdata.steamID)
    end

    q:start()
end

--[[
    Function: remove

    Removes the bandata from the Database.

    Parameters:

        steamid - The SteamID of the player who was unbanned.
]]
function bsync.remove(steamid)
    local query = string.format("DELETE FROM bsync_bans WHERE steamid = %s;", steamid)
    local q = db:query(query)

    function q:onSuccess(data)
        ServerLog("Successfully removed bandata of " .. steamid)
    end

    function q:onError(err, _)
        ServerLog("Error: Could not remove ban data of " .. steamid .. ": " .. err)
    end

    q:start()
end

--[[
    Function: cleanup

    Cleans all expires bans from the database. This can be very expensive.
]]
function bsync.cleanup()
    local query = string.format("DELETE * FROM bsync_bans WHERE unban <= %i;", CurTime())
    local q = db:query(query)

    function q:onSuccess(data)
        ServerLog("Successfully cleaned expired bans.")
        ULib.fileWrite("data/mysql_ban_sync/last_clean.txt", tostring(CurTime()))
    end

    function q:onError(err, _)
        ServerLog("Error: Could not clean expired bans: " .. err)
    end

    q:start()
end

--[[
    Function: getall

    Returns a table of all bans, nil on error.
]]
function bsync.getall()
    local query = "SELECT * FROM bsync_bans"
    local q = db:query(query)
    local bdata = nil

    function q:onSuccess(data)
        bdata = data
    end

    function q:onError(err, _)
        ServerLog("Error: Could not retrieve ban data: " .. err)
    end

    return bdata
end