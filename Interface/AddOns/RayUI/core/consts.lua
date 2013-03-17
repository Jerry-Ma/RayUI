local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local AddOnName = ...

R.myclass = select(2, UnitClass("player"))
R.myname = UnitName("player")
R.myrealm = GetRealmName()
R.version = GetAddOnMetadata(AddOnName, "Version")
BINDING_HEADER_RAYUI = GetAddOnMetadata(AddOnName, "Title")

R.colors = {
	tapped = {0.55, 0.57, 0.61},
	disconnected = {0.84, 0.75, 0.65},
	power = {
		["MANA"] = {0.31, 0.45, 0.63},
		["RAGE"] = {0.78, 0.25, 0.25},
		["FOCUS"] = {0.71, 0.43, 0.27},
		["ENERGY"] = {0.65, 0.63, 0.35},
		["RUNES"] = {0.55, 0.57, 0.61},
		["RUNIC_POWER"] = {0, 0.82, 1},
		["AMMOSLOT"] = {0.8, 0.6, 0},
		["FUEL"] = {0, 0.55, 0.5},
		["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
		["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
	},
	happiness = {
		[1] = {.69,.31,.31},
		[2] = {.65,.63,.35},
		[3] = {.33,.59,.33},
	},
	runes = {
        [1] = {.69,.31,.31},
        [2] = {.33,.59,.33},
        [3] = {.31,.45,.63},
        [4] = {.84,.75,.65},
	},
	reaction = {
		-- [1] = { 0.78, 0.25, 0.25 }, -- Hated
		[1] = { .7, .2, .1 }, -- Hated
		[2] = { 0.78, 0.25, 0.25 }, -- Hostile
		[3] = { 0.78, 0.25, 0.25 }, -- Unfriendly
		-- [4] = { 218/255, 197/255, 92/255 }, -- Neutral
		[4] = { 1, .8, 0 }, -- Neutral
		-- [5] = { 75/255,  175/255, 76/255 }, -- Friendly
		[5] = { .2, .6, .1 }, -- Friendly
		[6] = { 75/255,  175/255, 76/255 }, -- Honored
		[7] = { 75/255,  175/255, 76/255 }, -- Revered
		[8] = { 75/255,  175/255, 76/255 }, -- Exalted
	},
	class = {
		["DEATHKNIGHT"] = { 196/255,  30/255,  60/255 },
		["DRUID"]       = { 255/255, 125/255,  10/255 },
		["HUNTER"]      = { 171/255, 214/255, 116/255 },
		["MAGE"]        = { 104/255, 205/255, 255/255 },
		["PALADIN"]     = { 245/255, 140/255, 186/255 },
		["PRIEST"]      = { 212/255, 212/255, 212/255 },
		["ROGUE"]       = { 255/255, 243/255,  82/255 },
		["SHAMAN"]      = {  41/255,  79/255, 155/255 },
		["WARLOCK"]     = { 148/255, 130/255, 201/255 },
		["WARRIOR"]     = { 199/255, 156/255, 110/255 },
		["MONK"]        = {   0/255, 255/255, 151/255 },
	},
}
