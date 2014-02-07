--[[--------------------------------------------------------------------
	PhanxConfig-Button
	Simple button widget generator.
	Requires LibStub.

	This library is not intended for use by other authors. Absolutely no
	support of any kind will be provided for other authors using it, and
	its internals may change at any time without notice.
----------------------------------------------------------------------]]

local MINOR_VERSION = tonumber(string.match("$Revision$", "%d+"))

local lib, oldminor = LibStub:NewLibrary("PhanxConfig-Button", MINOR_VERSION)
if not lib then return end

local scripts = {
	OnEnter = function(self)
		if self.hint then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.hint, nil, nil, nil, nil, true)
		end
	end,
	OnLeave = function(self)
		GameTooltip:Hide()
	end,
	OnClick = function(self, button)
		PlaySound("gsTitleOptionOK")
		if self.OnClick then
			self:OnClick(button)
		end
	end,
	OnMouseDown = function(self, button)
		if self:IsEnabled() then
			self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
			self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
			self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		end
	end,
	OnMouseUp = function(self, button)
		if self:IsEnabled() then
			self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
			self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
			self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		end
	end,
	OnDisable = function(self)
		self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
		self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
		self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	end,
	OnEnable = function(self)
		self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	end,
}

local methods = {
	SetHint = function(self, text)
		self.hint = text
	end,
	GetHint = function(self)
		return self.hint
	end,
}

function lib:New(parent, name, hint)
	assert(type(parent) == "table" and parent.CreateFontString, "PhanxConfig-Button: Parent is not a valid frame!")
	if type(name) ~= "string" then name = nil end
	if type(hint) ~= "string" then hint = nil end

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

	button.hint = hint

	return button
end

function lib.CreateButton(...)
	return lib:New(...)
end