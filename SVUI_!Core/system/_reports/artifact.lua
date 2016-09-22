--[[
##############################################################################
S V U I   By: Munglunch
##############################################################################

##########################################################
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;

local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local error 	= _G.error;
local pcall 	= _G.pcall;
local assert 	= _G.assert;
local tostring 	= _G.tostring;
local tonumber 	= _G.tonumber;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
local GetEquippedArtifactInfo = _G.C_ArtifactUI.GetEquippedArtifactInfo
local GetNumArtifactTraitsPurchasableFromXP = _G.MainMenuBar_GetNumArtifactTraitsPurchasableFromXP
local HasArtifactEquipped = _G.HasArtifactEquipped
local GetCostForPointAtRank = _G.C_ArtifactUI.GetCostForPointAtRank;
--[[
##########################################################
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local Reports = SV.Reports;
-- JV: I may change to use LibArtifactData if direct access proves unsafe/unreliable. 
--local LibArtifactData = LibStub("LibArtifactData-1.0");
--[[
##########################################################
REPORT TEMPLATE
##########################################################
]]--
local REPORT_NAME = "Artifact";
local HEX_COLOR = "22FFFF";
--SV.media.color.green
--SV.media.color.normal
--r, g, b = 0.8, 0.8, 0.8
--local c = SV.media.color.green
--r, g, b = c[1], c[2], c[3]
local Report = Reports:NewReport(REPORT_NAME, {
	type = "data source",
	text = REPORT_NAME .. " Info",
	icon = [[Interface\Addons\SVUI_!Core\assets\icons\SVUI]]
});


local function GetArtifactData()
	if HasArtifactEquipped() then
		local itemID, _, _, _, totalPoints, pointsSpent, _, _, _, _, _, _ = GetEquippedArtifactInfo()

		local pointsToSpend, currentPower, powerForNextPoint = GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalPoints)
    	return true, tonumber(pointsSpent), tonumber(currentPower), tonumber(powerForNextPoint), tonumber(pointsToSpend)
	else
        return false --, nil,nil,nil,nil
    end
end

local function SetTooltipText(self)
	Reports:SetDataTip(self)
	local isEquipped,rank, currentPower,powerToNextLevel,pointsToSpend = GetArtifactData()
	Reports.ToolTip:AddLine(L["Artifact Power"])
	Reports.ToolTip:AddLine(" ")

	if isEquipped then
		local calc1 = (currentPower / powerToNextLevel) * 100;
		Reports.ToolTip:AddDoubleLine(L["Rank:"], (" %d "):format(rank), 1, 1, 1)
		Reports.ToolTip:AddDoubleLine(L["Current Artifact Power:"], (" %d  /  %d (%d%%)"):format(currentPower, powerToNextLevel, calc1), 1, 1, 1)
		Reports.ToolTip:AddDoubleLine(L["Remaining:"], (" %d "):format(powerToNextLevel - currentPower), 1, 1, 1)
		Reports.ToolTip:AddDoubleLine(L["Points to Spend:"], format(" %d ", pointsToSpend), 1, 1, 1)
	else
		Reports.ToolTip:AddDoubleLine(L["No Artifact"])		
	end
end

local function FormatPower(rank, currentPower, powerForNextPoint, pointsToSpend)

	local currentText = ("%d(+%d) %d/%d"):format(rank, pointsToSpend, currentPower, powerForNextPoint);
	return currentText
end

Report.events = {"PLAYER_ENTERING_WORLD", "ARTIFACT_XP_UPDATE", "UNIT_INVENTORY_CHANGED"};

Report.OnEvent = function(self, event, ...)
	local subset = self.ExpKey or "XP";
	if self.barframe:IsShown()then
		self.text:SetAllPoints(self)
		self.text:SetJustifyH("CENTER")
		self.barframe:Hide()
	end

	local isEquipped,rank,currentPower,powerToNextLevel,pointsToSpend = GetArtifactData()

	if isEquipped then
		local text = FormatPower(rank, currentPower,powerToNextLevel,pointsToSpend);
		self.text:SetText(text)
	else
		self.text:SetText(L["No Artifact"])		
	end
end

Report.OnEnter = function(self)
	SetTooltipText(self)
	Reports:ShowDataTip()
end

-- Report.OnInit = function(self)
-- 	LibArtifactData:ForceUpdate()
-- end

--[[
##########################################################
BAR TYPE
##########################################################
]]--
local BAR_NAME = "Artifact Bar";
local ReportBar = Reports:NewReport(BAR_NAME, {
	type = "data source",
	text = BAR_NAME,
	icon = [[Interface\Addons\SVUI_!Core\assets\icons\SVUI]]
});

ReportBar.events = {"PLAYER_ENTERING_WORLD", "ARTIFACT_XP_UPDATE", "UNIT_INVENTORY_CHANGED"};

ReportBar.OnEvent = function(self, event, ...)
	if (not self.barframe:IsShown())then
		self.barframe:Show()
		self.barframe.icon.texture:SetTexture(SV.media.dock.artifactLabel)
	end

	local bar = self.barframe.bar;
	local isEquipped,rank, currentPower,powerToNextLevel,pointsToSpend = GetArtifactData()
	if isEquipped then
		bar:SetMinMaxValues(0, powerToNextLevel)
		bar:SetValue(currentPower)
		bar:SetStatusBarColor(0.9, 0.64, 0.37)
		self.text:SetText(rank)
	else
		bar:SetMinMaxValues(0, 1)
		bar:SetValue(0)
		self.text:SetText(L["No Artifact"])
	end
end

ReportBar.OnEnter = function(self)
	SetTooltipText(self)
	Reports:ShowDataTip()
end

-- ReportBar.OnInit = function(self)
-- 	LibArtifactData:ForceUpdate()
-- end

