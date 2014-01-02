--[[--------------------------------------------------------------------
	PhanxConfig-Button
	Simple button widget generator.
	Requires LibStub.

	This library is not intended for use by other authors. Absolutely no
	support of any kind will be provided for other authors using it, and
	its internals may change at any time without notice.
----------------------------------------------------------------------]]

local MINOR_VERSION = tonumber( string.match( "$Revision: 30000 $", "%d+" ) )

local lib, oldminor = LibStub:NewLibrary( "PhanxConfig-Button", MINOR_VERSION )
if not lib then return end

local function OnEnter( self )
	local text = self.desc
	if text then
		GameTooltip:SetOwner( self, "ANCHOR_RIGHT" )
		GameTooltip:SetText( text, nil, nil, nil, nil, true )
	end
end

local function OnLeave()
	GameTooltip:Hide()
end

local function OnClick( self, button )
	PlaySound("gsTitleOptionOK")
	local func = self.OnClick
	if func then
		func( self, button )
	end
end

local function OnMouseDown( self )
	if self:IsEnabled() then
		self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	end
end

local function OnMouseUp( self )
	if self:IsEnabled() then
		self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	end
end

local function OnDisable( self )
	self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
end

local function OnEnable( self )
	self.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	self.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	self.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
end

function lib.CreateButton( parent, name, desc )
	assert( type(parent) == "table" and parent.CreateFontString, "PhanxConfig-Button: Parent is not a valid frame!" )
	if type(name) ~= "string" then name = nil end
	if type(desc) ~= "string" then desc = nil end

	local button = CreateFrame( "Button", nil, parent )

	button:SetNormalFontObject( GameFontNormalSmall )
	button:SetDisabledFontObject( GameFontDisable )
	button:SetHighlightFontObject( GameFontHighlightSmall )

	local left = button:CreateTexture( nil, "BACKGROUND" )
	left:SetPoint( "TOPLEFT" )
	left:SetPoint( "BOTTOMLEFT" )
	left:SetWidth( 12 )
	left:SetTexture( [[Interface\Buttons\UI-Panel-Button-Up]] )
	left:SetTexCoord( 0, 0.09375, 0, 0.6875 )
	button.Left = left

	local right = button:CreateTexture( nil, "BACKGROUND" )
	right:SetPoint( "TOPRIGHT" )
	right:SetPoint( "BOTTOMRIGHT" )
	right:SetWidth( 12 )
	right:SetTexture( [[Interface\Buttons\UI-Panel-Button-Up]] )
	right:SetTexCoord( 0.53125, 0.625, 0, 0.6875 )
	button.Right = right

	local mid = button:CreateTexture( nil, "BACKGROUND" )
	mid:SetPoint( "BOTTOMLEFT", left, "BOTTOMRIGHT" )
	mid:SetPoint( "TOPRIGHT", right, "TOPLEFT" )
	mid:SetTexture( [[Interface\Buttons\UI-Panel-Button-Up]] )
	mid:SetTexCoord( 0.09375, 0.53125, 0, 0.6875 )
	button.Middle = mid
--[=[
	button:SetNormalTexture( [[Interface\Buttons\UI-Panel-Button-Up]] )
	button:GetNormalTexture():SetTexCoord( 0, 0.625, 0, 0.6875 )

	button:SetPushedTexture( [[Interface\Buttons\UI-Panel-Button-Down]] )
	button:GetPushedTexture():SetTexCoord( 0, 0.625, 0, 0.6875 )

	button:SetDisabledTexture( [[Interface\Buttons\UI-Panel-Button-Disabled]] )
	button:GetDisabledTexture():SetTexCoord( 0, 0.625, 0, 0.6875 )
]=]
	button:SetHighlightTexture( [[Interface\Buttons\UI-Panel-Button-Highlight]] )
	button:GetHighlightTexture():SetTexCoord( 0, 0.625, 0, 0.6875 )
	button:GetHighlightTexture():SetBlendMode( "ADD" )

	button:SetScript( "OnEnter", OnEnter )
	button:SetScript( "OnLeave", OnLeave )
	button:SetScript( "OnClick", OnClick )
	button:SetScript( "OnMouseDown", OnMouseDown )
	button:SetScript( "OnMouseUp", OnMouseUp )
	button:SetScript( "OnShow", OnMouseUp )
	button:SetScript( "OnDisable", OnDisable )
	button:SetScript( "OnEnable", OnEnable )

	button:SetText( name )
	button:SetWidth( math.min( 44, button:GetTextWidth() + 8 ) )
	button:SetHeight( 24 )

	button.desc = desc

	return button
end