--[[
##########################################################
S V U I   By: Munglunch
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
GET ADDON DATA
##########################################################
]]--
if(select(2, UnitClass("player")) ~= 'HUNTER') then return end;

local SV = select(2, ...)

--[[ HUNTER FILTERS ]]--

SV.defaults.Filters["BuffWatch"] = {};