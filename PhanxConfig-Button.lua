--[[--------------------------------------------------------------------
	PhanxConfig-Button
	Simple button widget generator. Requires LibStub.
	https://github.com/Phanx/PhanxConfig-Button

	Copyright (c) 2009-2014 Phanx <addons@phanx.net>. All rights reserved.

	Permission is granted for anyone to use, read, or otherwise interpret
	this software for any purpose, without any restrictions.

	Permission is granted for anyone to embed or include this software in
	another work not derived from this software that makes use of the
	interface provided by this software for the purpose of creating a
	package of the work and its required libraries, and to distribute such
	packages as long as the software is not modified in any way, including
	by modifying or removing any files.

	Permission is granted for anyone to modify this software or sample from
	it, and to distribute such modified versions or derivative works as long
	as neither the names of this software nor its authors are used in the
	name or title of the work or in any other way that may cause it to be
	confused with or interfere with the simultaneous use of this software.

	This software may not be distributed standalone or in any other way, in
	whole or in part, modified or unmodified, without specific prior written
	permission from the authors of this software.

	The names of this software and/or its authors may not be used to
	promote or endorse works derived from this software without specific
	prior written permission from the authors of this software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
	OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
	ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
----------------------------------------------------------------------]]

local MINOR_VERSION = 20141201

local lib, oldminor = LibStub:NewLibrary("PhanxConfig-Button", MINOR_VERSION)
if not lib then return end

------------------------------------------------------------------------

local scripts = {}

function scripts:OnClick(button)
	PlaySound("gsTitleOptionOK")
	local callback = self.OnClicked
	if callback then
		callback(self, button)
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