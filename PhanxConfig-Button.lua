--[[--------------------------------------------------------------------
	PhanxConfig-Button
	Simple button widget generator.
	Requires LibStub.
	https://github.com/phanx/PhanxConfigWidgets
	Copyright 2009-2014 Phanx <addons@phanx.net>
	Do not redistribute standalone without permisssion.
	See the accompanying LICENSE file for details.
----------------------------------------------------------------------]]

local MINOR_VERSION = tonumber(string.match("$Revision$", "%d+"))

local lib, oldminor = LibStub:NewLibrary("PhanxConfig-Button", MINOR_VERSION)
if not lib then return end

------------------------------------------------------------------------

local scripts = {}

function scripts:OnClick(button)
	PlaySound("gsTitleOptionOK")
	if self.Callback then
		self:Callback(button)
	end
end

function scripts:OnEnter()
	if self.tooltipText then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
	end
end
function scripts:OnLeave()
	GameTooltip:Hide()
end

function scripts:OnMouseDown(button)
	if self:IsEnabled() then
		self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	end
end
function scripts:OnMouseUp(button)
	if self:IsEnabled() then
		self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	end
end

function scripts:OnEnable()
	self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
end
function scripts:OnDisable()
	self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
end

------------------------------------------------------------------------

local methods = {}

function methods:GetLabel()
	return self:GetText()
end
function methods:SetLabel(text)
	self:SetText(text)
end

function methods:GetTooltip()
	return self.tooltipText
end
function methods:SetTooltip(text)
	self.tooltipText = text
end

------------------------------------------------------------------------

function lib:New(parent, name, tooltipText)
	assert(type(parent) == "table" and parent.CreateFontString, "PhanxConfig-Button: Parent is not a valid frame!")
	if type(name) ~= "string" then name = nil end
	if type(tooltipText) ~= "string" then tooltipText = nil end

	local button = CreateFrame("Button", nil, parent)

	button:SetNormalFontObject(GameFontNormalSmall)
	button:SetDisabledFontObject(GameFontDisable)
	button:SetHighlightFontObject(GameFontHighlightSmall)

	local left = button:CreateTexture(nil, "BACKGROUND")
	left:SetPoint("TOPLEFT")
	left:SetPoint("BOTTOMLEFT")
	left:SetWidth(12)
	left:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
	left:SetTexCoord(0, 0.09375, 0, 0.6875)
	button.Left = left

	local right = button:CreateTexture(nil, "BACKGROUND")
	right:SetPoint("TOPRIGHT")
	right:SetPoint("BOTTOMRIGHT")
	right:SetWidth(12)
	right:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
	right:SetTexCoord(0.53125, 0.625, 0, 0.6875)
	button.Right = right

	local mid = button:CreateTexture(nil, "BACKGROUND")
	mid:SetPoint("BOTTOMLEFT", left, "BOTTOMRIGHT")
	mid:SetPoint("TOPRIGHT", right, "TOPLEFT")
	mid:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
	mid:SetTexCoord(0.09375, 0.53125, 0, 0.6875)
	button.Middle = mid

	button:SetHighlightTexture([[Interface\Buttons\UI-Panel-Button-Highlight]])
	local hilight = button:GetHighlightTexture()
	hilight:SetTexCoord(0, 0.625, 0, 0.6875)
	hilight:SetBlendMode("ADD")
	button.Highlight = hilight

	for name, func in pairs(scripts) do
		button:SetScript(name, func)
	end
	for name, func in pairs(methods) do
		button[name] = func
	end

	button:SetText(name)
	button:SetWidth(math.min(44, button:GetTextWidth() + 8))
	button:SetHeight(24)

	button.tooltipText = tooltipText

	return button
end

function lib.CreateButton(...)
	return lib:New(...)
end