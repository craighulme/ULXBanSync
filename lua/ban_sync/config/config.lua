bsync = {}
bsync.mysql = {}

--[[You are free to edit anything past this line.]]--

--[[MySQL Database Settings]]--

bsync.mysql.host     = "" -- The hostname.
bsync.mysql.username = "" -- The username.
bsync.mysql.password = "" -- The password.
bsync.mysql.database = "" -- The database.
bsync.mysql.port     = 3306 -- The port. This is 3306 unless you are SURE it's different.

--[[End MySQL Database Settings]]--

--[[ULX Ban Sync Settings]]--

bsync.enabled  = true   -- Whether or not this addon is enabled. If this is false, this addon won't do anything.
bsync.sync_all = true   -- Whether or not to sync all bans. If false, only sync bans that pass the 'bsync.min_time' threshold.
bsync.min_time = 604800 -- The time (in seconds) that we will sync bans if 'bsync.sync_all' is false.

bsync.debug    = false  -- Keep this false. This will enable a bunch of debug messages that are not helpful for everyday use. If you're having problems with something, turn this on.

--[[End ULX Ban Sync Settings]]--