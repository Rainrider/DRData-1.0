local major = "DRData-1.0"
local minor = 1033
assert(LibStub, string.format("%s requires LibStub.", major))

local Data = LibStub:NewLibrary(major, minor)
if( not Data ) then return end

local L = {
	["Roots"] = "Roots",
	["Stuns"] = "Stuns",
	["Incapacitates"] = "Incapacitates",
	["Disorients"] = "Disorients",
	["Silences"] = "Silences",
	["Taunts"] = "Taunts",
	["Knockbacks"] = "Knockbacks",
}

local locale = GetLocale()
if locale == "deDE" then
	--@localization(locale="deDE", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "esES" then
	--@localization(locale="esES", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "esMX" then
	--@localization(locale="esMX", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "frFR" then
	--@localization(locale="frFR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "itIT" then
	--@localization(locale="itIT", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "koKR" then
	--@localization(locale="koKR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ptBR" then
	--@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ruRU" then
	--@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhCN" then
	--@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhTW" then
	--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="ignore")@
end

-- How long before DR resets
-- While everyone will tell you it's 15 seconds, it's actually 16 - 20 seconds with 18 being a decent enough average
Data.RESET_TIME = 18

-- Spells and providers by categories
--[[ Generic format:
	category = {
		-- When the debuff and the spell that applies it are the same:
		debuffId = true
		-- When the debuff and the spell that applies it differs:
		debuffId = spellId
		-- When several spells applies the debuff:
		debuffId = {spellId1, spellId2, ...}
	}
--]]
local spellsAndProvidersByCategory = {
	--[[ TAUNT ]]--
	taunt = {
		-- Death Knight
		[ 56222] = true, -- Dark Command
		[ 57603] = true, -- Death Grip
		-- I have also seen these two spellIDs used for the Death Grip debuff in MoP.
		-- I have not seen the first one here in any of my MoP testing, but it may still be valid.
		[ 49560] = true, -- Death Grip
		[ 51399] = true, -- Death Grip
		-- Druid
		[  6795] = true, -- Growl
		-- Hunter
		[ 20736] = true, -- Distracting Shot
		-- Monk
		[116189] = 115546, -- Provoke
		[118635] = 115546, -- Provoke via the Black Ox Statue -- NEED TESTING
		[118585] = 115543, -- Leer of the Ox -- NEED TESTING
		-- Paladin
		[ 62124] = true, -- Reckoning
		-- Warlock
		[ 17735] = true, -- Suffering (Voidwalker)
		-- Warrior
		[   355] = true, -- Taunt
		-- Shaman
		[ 36213] = true, -- Angered Earth (Earth Elemental)
	},

	--[[ INCAPACITATES ]]--
	incapacitate = {
		-- Druid
		[    99] =   true, -- Incapacitating Roar (talent)
		-- Hunter
		[  3355] = {1499, 60192}, -- Freezing Trap
		[ 19386] =   true, -- Wyvern Sting
		-- Mage
		[   118] =   true, -- Polymorph
		[ 28272] =   true, -- Polymorph (pig) -- TODO: verify id
		[ 28271] =   true, -- Polymorph (turtle) -- TODO: verify id
		[ 61305] =   true, -- Polymorph (black cat)
		[ 61721] =   true, -- Polymorph (rabbit) -- TODO: verify id
		[ 61780] =   true, -- Polymorph (turkey)
		[ 82691] = 113724, -- Ring of Frost
		[ 31661] =   true, -- Dragon's Breath
		-- Monk
		[115078] =   true, -- Paralysis
		[123393] = 115181, -- Breath of Fire (Glyphed) -- TODO: either tooltip wrong or officially listed in the wrong category
		[137460] = 116844, -- Ring of Peace
		-- Paladin
		[ 20066] =   true, -- Repentance (talent)
		-- Priest
		[  9484] =   true, -- Shackle Undead -- XXX: not officially listed
		[ 64044] =   true, -- Psychic Horror
		[ 88625] =   true, -- Holy Word: Chastise
		[   605] =   true, -- Dominate Mind
		-- Rogue
		[  1776] =   true, -- Gouge
		[  6770] =   true, -- Sap
		-- Shaman
		[ 51514] =   true, -- Hex
		-- Warlock
		[   710] =   true, -- Banish
		[137143] = 111397, -- Blood Horror
		[  6789] =   true, -- Mortal Coil
		-- Pandaren
		[107079] =   true, -- Quaking Palm
	},

	--[[ SILENCES ]]--
	silence = {
		-- Death Knight
		[ 47476] =  true, -- Strangulate
		-- Druid
		[114238] =   770, -- Glyph of Fae Silence
		[ 81261] = 78675, -- Solar Beam
		-- Mage
		[102051] =  true, -- Frostjaw (talent)
		-- Paladin
		[ 31935] =  true, -- Avenger's Shield
		-- Priest
		[ 15487] =  true, -- Silence
		-- Rogue
		[  1330] =   703, -- Garrote
		-- Blood Elf
		[ 25046] =  true, -- Arcane Torrent (Energy)
		[ 28730] =  true, -- Arcane Torrent (Mana)
		[ 50613] =  true, -- Arcane Torrent (Runic power)
		[ 69179] =  true, -- Arcane Torrent (Rage)
		[ 80483] =  true, -- Arcane Torrent (Focus)
		[129597] =  true, -- Arcane Torrent (Chi)
		[155145] =  true, -- Arcane Torrent (Holy Power)
	},

	--[[ DISORIENTS ]]--
	disorient = {
		-- Druid
		[ 33786] = true, -- Cyclone
		-- Paladin
		[ 10326] = true, -- Turn Evil
		[145067] = true, -- Turn Evil (with Evil is a Point of View talent) -- FIXME: removed in a recent build
		-- Priest
		[  8122] = true, -- Psychic Scream (Talent)
		-- Rogue
		[  2094] = true, -- Blind
		-- Warlock
		[118699] = 5782, -- Fear
		[130616] = 5782, -- Fear with Glyph of Fear -- FIXME: verify cetegory
		[  5484] = true, -- Howl of Terror (Talent)
		[115268] = true, -- Mesmerize (Shivarra)
		[  6358] = true, -- Seduction (Succubus)
		-- Warrior
		[  5246] = true, -- Intimidating Shout
	},

	--[[ STUNS ]]--
	ctrlstun = {
		-- Death Knight
		[108194] =   true, -- Asphyxiate
		[ 91800] =  47481, -- Gnaw (Ghoul)
		[ 91797] =  47481, -- Monstrous Blow (Dark Transformation Ghoul)
		[115001] = 108200, -- Remorseless Winter (talent)
		-- Druid
		[ 22570] =   true, -- Maim
		[  5211] =   true, -- Mighty Bash
		[163505] =   1822, -- Rake
		-- Hunter
		[117526] = 109248, -- Binding Shot
		[ 24394] =  19577, -- Intimidation
		-- Mage
		[ 44572] =   true, -- Deep Freeze
		-- Monk
		[119392] =   true, -- Charging Ox Wave
		[120086] = 113656, -- Fists of Fury
		[119381] =   true, -- Leg Sweep
		-- Paladin
		[   853] =   true, -- Hammer of Justice
		[119072] =   true, -- Holy Wrath (protection)
		[105593] =   true, -- Fist of Justice (talent)
		-- Rogue
		[  1833] =   true, -- Cheap Shot
		[   408] =   true, -- Kidney Shot
		-- Shaman
		[118345] =   true, -- Pulverize (Primal Earth Elemental)
		[118905] = 108269, -- Static Charge (Capacitor Totem)
		[ 77505] =  61882, -- Earthquake -- TODO: verify effect id -- XXX: not officially listed
		-- Warlock
		[ 89766] =   true, -- Axe Toss (Felguard)
		[ 30283] =   true, -- Shadowfury
		[ 22703] =   1122, -- Summon Infernal
		-- Warrior
		[132168] =  46968, -- Shockwave
		[132169] = 107570, -- Storm Bolt
		[118895] = 118000, -- Dragon Roar (talent) -- XXX: not officially listed
		-- Tauren
		[ 20549] =   true, -- War Stomp
	},

	--[[ ROOTS ]]--
	ctrlroot = {
		-- Death Knight
		[ 96294] =  45524, -- Chains of Ice (with Chilblains talent)
		-- Druid
		[   339] =   true, -- Entangling Roots
		[113770] = 102703, -- Entangling Roots (through Force of Nature (Feral talent))
		[102359] =   true, -- Mass Entanglement (talent)
		-- Hunter
		[ 53148] =  61685, -- Charge (Tenacity pet) -- XXX: warrior charge is not on DR, why this?
		[136634] =    781, -- Narrow Escape (talent)
		[135373] = { -- Entrapment (Survival passive)
			13809, -- Ice Trap
			82941, -- Ice Trap (Trap Launcher)
			34600, -- Snake Trap
			82948, -- Snake Trap (Trap Launcher) -- FIXME: bugged on beta
		},
		-- Mage
		[   122] =   true, -- Frost Nova
		[ 33395] =   true, -- Freeze (Water Elemental)
		[111340] = 111264, -- Ice Ward (Talent)
		-- Monk
		[116706] = 116095, -- Disable
		-- Priest
		[ 87194] =   8092, -- Glyph of Mind Blast
		[114404] = 108920, -- Void Tendrils
		-- Shaman
		[ 63685] =   8056, -- Freeze (Frost Shock with Frozen Power talent)
		[ 64695] =  51485, -- Earthgrab Totem (talent)
	},

	--[[ KNOCKBACK ]]--
	knockback = {
		-- Death Knight
		[108199] = true, -- Gorefiend's Grasp (talent)
		-- Druid
		[102793] = true, -- Ursol's Vortex
		[ 61391] = 132469, -- Typhoon
		-- Hunter
		[149575] = { -- Glyph of Explosive Trap
			13813, -- Explosive Trap
			82939, -- Explosive Trap (Trap Launcher)
		},
		-- Shaman
		[ 51490] = true, -- Thunderstorm
		-- Warlock
		[  6360] = true, -- Whiplash
		[115770] = true, -- Fellash
	},
}

--- List of spellID -> DR category
Data.spells = {}

--- List of spellID => ProviderID
Data.providers = {}

-- Dispatch the spells in the final tables
for category, spells in pairs(spellsAndProvidersByCategory) do
	for spell, provider in pairs(spells) do
		Data.spells[spell] = category
		if provider == true then -- "== true" is really needed
			Data.providers[spell] = spell
			spells[spell] = spell
		else
			Data.providers[spell] = provider
		end
	end
end

-- DR Category names
Data.categoryNames = {
	["ctrlroot"] = L["Roots"],
	["ctrlstun"] = L["Stuns"],
	["incapacitate"] = L["Incapacitates"],
	["disorient"] = L["Disorients"],
	["silence"] = L["Silences"],
	["taunt"] = L["Taunts"],
	["knockback"] = L["Knockbacks"], -- NEEDS PROPER TESTING WITH DEPENDENT ADDONS
}

-- Categories that have DR in PvE as well as PvP
Data.pveDR = {
	["ctrlstun"] = true,
	["taunt"] = true,
	-- ["bindelemental"] = true, -- Why was this added to pveDR? Just tested and it definitely does not have PvE DR.
}

-- Public APIs
-- Category name in something usable
function Data:GetCategoryName(cat)
	return cat and Data.categoryNames[cat] or nil
end

-- Spell list
function Data:GetSpells()
	return Data.spells
end

-- Provider list
function Data:GetProviders()
	return Data.providers
end

-- Seconds before DR resets
function Data:GetResetTime()
	return Data.RESET_TIME
end

-- Get the category of the spellID
function Data:GetSpellCategory(spellID)
	return spellID and Data.spells[spellID] or nil
end

-- Does this category DR in PvE?
function Data:IsPVE(cat)
	return cat and Data.pveDR[cat] or nil
end

-- List of categories
function Data:GetCategories()
	return Data.categoryNames
end

-- Next DR, if it's 1.0, next is 0.50, if it's 0.[50] = "ctrlroot",next is 0.[25] = "ctrlroot",and such
function Data:NextDR(diminished)
	if( diminished == 1 ) then
		return 0.50
	elseif( diminished == 0.50 ) then
		return 0.25
	end

	return 0
end

-- Iterate through the spells of a given category.
-- Pass "nil" to iterate through all spells.
do
	local function categoryIterator(id, category)
		local newCat
		repeat
			id, newCat = next(Data.spells, id)
			if id and newCat == category then
				return id, category
			end
		until not id
	end

	function Data:IterateSpells(category)
		if category then
			return categoryIterator, category
		else
			return next, Data.spells
		end
	end
end

-- Iterate through the spells and providers of a given category.
-- Pass "nil" to iterate through all spells.
function Data:IterateProviders(category)
	if category then
		return next, spellsAndProvidersByCategory[category]
	else
		return next, Data.providers
	end
end

--[[ EXAMPLES ]]--
-- This is how you would track DR easily, you're welcome to do whatever you want with the below functions

--[[
local trackedPlayers = {}
local function debuffGained(spellID, destName, destGUID, isEnemy, isPlayer)
	-- Not a player, and this category isn't diminished in PVE, as well as make sure we want to track NPCs
	local drCat = DRData:GetSpellCategory(spellID)
	if( not isPlayer and not DRData:IsPVE(drCat) ) then
		return
	end

	if( not trackedPlayers[destGUID] ) then
		trackedPlayers[destGUID] = {}
	end

	-- See if we should reset it back to undiminished
	local tracked = trackedPlayers[destGUID][drCat]
	if( tracked and tracked.reset <= GetTime() ) then
		tracked.diminished = 1.0
	end
end

local function debuffFaded(spellID, destName, destGUID, isEnemy, isPlayer)
	local drCat = DRData:GetSpellCategory(spellID)
	if( not isPlayer and not DRData:IsPVE(drCat) ) then
		return
	end

	if( not trackedPlayers[destGUID] ) then
		trackedPlayers[destGUID] = {}
	end

	if( not trackedPlayers[destGUID][drCat] ) then
		trackedPlayers[destGUID][drCat] = { reset = 0, diminished = 1.0 }
	end

	local time = GetTime()
	local tracked = trackedPlayers[destGUID][drCat]

	tracked.reset = time + DRData:GetResetTime()
	tracked.diminished = DRData:NextDR(tracked.diminished)

	-- Diminishing returns changed, now you can do an update
end

local function resetDR(destGUID)
	-- Reset the tracked DRs for this person
	if( trackedPlayers[destGUID] ) then
		for cat in pairs(trackedPlayers[destGUID]) do
			trackedPlayers[destGUID][cat].reset = 0
			trackedPlayers[destGUID][cat].diminished = 1.0
		end
	end
end

local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER

local eventRegistered = {["SPELL_AURA_APPLIED"] = true, ["SPELL_AURA_REFRESH"] = true, ["SPELL_AURA_REMOVED"] = true, ["PARTY_KILL"] = true, ["UNIT_DIED"] = true}
local function COMBAT_LOG_EVENT_UNFILTERED(self, event, timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, auraType)
	if( not eventRegistered[eventType] ) then
		return
	end

	-- Enemy gained a debuff
	if( eventType == "SPELL_AURA_APPLIED" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			debuffGained(spellID, destName, destGUID, (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE), isPlayer)
		end

	-- Enemy had a debuff refreshed before it faded, so fade + gain it quickly
	elseif( eventType == "SPELL_AURA_REFRESH" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			local isHostile = (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)
			debuffFaded(spellID, destName, destGUID, isHostile, isPlayer)
			debuffGained(spellID, destName, destGUID, isHostile, isPlayer)
		end

	-- Buff or debuff faded from an enemy
	elseif( eventType == "SPELL_AURA_REMOVED" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			debuffFaded(spellID, destName, destGUID, (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE), isPlayer)
		end

	-- Don't use UNIT_DIED inside arenas due to accuracy issues, outside of arenas we don't care too much
	elseif( ( eventType == "UNIT_DIED" and select(2, IsInInstance()) ~= "arena" ) or eventType == "PARTY_KILL" ) then
		resetDR(destGUID)
	end
end]]
