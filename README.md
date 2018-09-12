# ULXBanSync
Syncs your ULX bans with a MySQL database.

# DISCLAIMER
UNTIL THIS NOTE IS REMOVED, THIS IS UNTESTED AND MAY OR MAY NOT WORK. USE AT YOUR OWN RISK.

# Features
- Uses [MySQLOO](https://github.com/FredyH/MySQLOO/releases) to sync your Bans with a MySQL Database.
- Fairly lightweight.
- Performs automatic cleanup (performed weekly).

# Installation
1. Download the current release from the [releases page](https://github.com/iViscosity/ULXBanSync/releases)
2. Extract the contents of the ZIP into garrysmod/addons/
3. Perform all necessary edits in `lua/ban_sync/config/config.lua` (if you skip this step, this addon **WILL NOT** work)
4. Perform a COMPLETE server restart (**A MAP CHANGE WILL NOT WORK**)

# For Developers
I have provided several functions for use of this addon in your addons. More info on the [wiki](https://github.com/iViscosity/ULXBanSync/wiki/For-Developers).

# NOTE
This DOES NOT stop ULib from writing to bans.txt. This addon synchronizes everything in bans.txt with a MySQL database, and vice versa.
