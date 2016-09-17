--[[
##########################################################
S V U I   By: Munglunch
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
GET ADDON DATA
##########################################################
]]--
if(select(2, UnitClass("player")) ~= 'WARLOCK') then return end;

local SV = select(2, ...)

--[[ WARLOCK FILTERS ]]--

SV.defaults.Filters["BuffWatch"] = {};