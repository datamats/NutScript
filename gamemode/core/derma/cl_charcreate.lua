--[[
	NutScript is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	NutScript is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with NutScript.  If not, see <http://www.gnu.org/licenses/>.
--]]

local PANEL = {}
	function PANEL:Init()
		if (IsValid(nut.gui.charCreate)) then
			nut.gui.charCreate:Remove()
		end

		nut.gui.charCreate = self

		self:SetSize(ScrW() * 0.45, ScrH() * 0.55)
		self:SetPos(ScrW() * 0.3, ScrH() * 0.3 + 16)

		self.notice = self:Add("nutNoticeBar")
		self.notice:setType(4)
		self.notice:setText(L"charCreateTip")
		self.notice:SetWide(self:GetWide())

		self.payload = {}
		self.lastY = self.notice:GetTall() + 8
	end

	function PANEL:addLabel(text)
		local label = self:Add("DLabel")
		label:SetPos(0, self.lastY)
		label:SetFont("nutMenuButtonFont")
		label:SetText(L(text))
		label:SizeToContents()
		label:SetTextColor(color_white)
		label:SetExpensiveShadow(2, Color(0, 0, 0, 200))

		self.lastY = self.lastY + label:GetTall() + 8

		return label
	end

	function PANEL:addTextBox()
		local textBox = self:Add("DTextEntry")
		textBox:SetFont("nutMenuButtonLightFont")
		textBox:SetWide(self:GetWide())
		textBox:SetPos(0, self.lastY)
		textBox:SetTall(36)

		self.lastY = self.lastY + textBox:GetTall() + 8

		return textBox
	end

	function PANEL:setUp(faction)
		self.faction = faction
		self.payload.faction = self.faction
		
		for k, v in SortedPairsByMemberValue(nut.char.vars, "index") do
			if (!v.noDisplay and k != "__SortedIndex") then
				if (v.shouldDisplay) then
					if (v.shouldDisplay(self) == false) then
						continue
					end
				end

				self:addLabel(k)

				if (v.onDisplay) then
					local panel = v.onDisplay(self, self.lastY)

					if (IsValid(panel)) then
						self.lastY = self.lastY + panel:GetTall() + 8
					end
				elseif (type(v.default) == "string") then
					local textBox = self:addTextBox()
					textBox.OnTextChanged = function(this)
						self.payload[k] = this:GetText()
					end
				end
			end
		end
	end
vgui.Register("nutCharCreate", PANEL, "DScrollPanel")
