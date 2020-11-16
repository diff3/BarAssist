-- simple way to share information between files in lua.
local name, bar = ...

-- Events
bar.eventFrame = CreateFrame("Frame", "eventFrame")
bar.eventFrame:RegisterEvent("ADDON_LOADED")
bar.eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
bar.eventFrame:RegisterEvent("UPDATE_BINDINGS")

-- this function let us create funtions of all the events, looks nicer.
bar.eventFrame:SetScript("OnEvent",
    function(self, event, ...)
        if (type(bar[event]) == 'function') then
            bar[event](self, event, ...);
        end
    end
)

function bar:ADDON_LOADED(self, event)
    if event == "BarAssist" then
      print("BarAssist loaded");
      bar.buttons = {}

      -- It's not until now all between session variables is loaded, if we
      -- run init or create all before this point the program breakes.
      bar:init_vars()

      -- I could have done one function to create all, but I felt I needed to
      -- have the ability to call functions seperatly. Like then key binding
      -- updates.

      bar:createTemplateFrame()


      local btn

      for index=0, 2, 1 do
        btn = bar:createOneButton(index)
        bar.buttons[index] = btn
        bar:restoreSavedButtons(btn)
        bar:UpdateCooldown(btn)
        bar:UpdateButtonActions(btn)
      end

      header:SetText(BA_Vars.headerText)
      bar.Menu:Show();
    end
end

function bar:UPDATE_BINDINGS(self, event, ...)
  for index=0, 2, 1 do
    local nameData = "BarAssistButton" .. index
    local key1, key2 = GetBindingKey(nameData .. "binding")
    local spellName = GetSpellInfo(getglobal(nameData).typeID)

    if key1 and spellName then
      SetBindingSpell(key1, spellName)
    end

    if key2 and spellName then
      SetBindingSpell(key2, spellName)
    end
  end
end

function bar:UNIT_SPELLCAST_SUCCEEDED(self, arg1, arg2, arg3, arg4)
  if arg1 == "player" then
    C_Timer.After(0.2, function()
      -- we need to wait 0.2 secounds or we won't get any information from GetSpellCooldown

      for i = 0, 2, 1 do
        local btn = getglobal("BarAssistButton" .. i)
        local duration = 0
        local startTime = 0

        if btn.infoType == 'item' then
          local spellName, spellID = GetItemSpell(btn.typeID)
          if tostring(spellID) == tostring(arg3) then
            startTime, duration = GetItemCooldown(btn.typeID)
          end
        elseif btn.infoType == 'spell' then
          if tostring(btn.typeID) == tostring(arg3) then
            start, duration = GetSpellCooldown(arg3)
          end
        end

        if duration > 0 then
          btn.cooldown:SetCooldown(start, duration)
        end
      end
    end)
  end
end

function bar:UpdateCooldown(btn)
  local start, duration = 0, 0

  if btn.infoType == 'item' then
    start, duration = GetItemCooldown(btn.typeID)
  elseif btn.infoType == 'spell' then
    start, duration = GetSpellCooldown(btn.typeID)
  end

  if duration > 0 then
    btn.cooldown:SetCooldown(start, duration)
  end
end

-- Create a popup menu to enter text
StaticPopupDialogs["EDIT_MENU_TITLE_DIALOG"] = {
  text = "Enter a new name for menu",
  button1 = "Save",
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 1,
  OnShow = function (self, data)
    self.editBox:SetText(header:GetText())
  end,
  OnAccept = function (self, data, data2)
    local text = self.editBox:GetText()
    header:SetText(text)
    BA_Vars.headerText = text
  end,
  hasEditBox = true
}

function editeModeActivation()
  if editVarning:IsVisible() then
    editVarning:Hide()
    bar.editMode = false

    local btn
    for i=0, 2, 1 do
      btn = getglobal("BarAssistButton" .. i)
      bar:UpdateButtonActions(btn)
    end
  else
    editVarning:Show();
    bar.editMode = true
    local btn

    for i=0, 2, 1 do
      btn = getglobal("BarAssistButton" .. i)
      btn:SetAttribute(btn.infoType, "");
      btn:SetAttribute("type", "");
    end
  end
end

function bar:createTemplateFrame()
  --[[
  Creates where we till place all buttons.
  ]]

  -- Create a Base frame
  bar.Menu = CreateFrame("Frame", "BA_Menu", UIParent, "SecureHandlerClickTemplate, SecureHandlerBaseTemplate, BA_MenuContainer");
  bar.Menu:SetMovable(true)
  bar.Menu:EnableMouse(true)
  bar.Menu:RegisterForDrag("LeftButton");
  -- bar.Menu:RegisterForClicks("AnyDown")
  bar.Menu:SetBackdropColor(0, 0, 0, 0.9);
  bar.Menu:SetPoint("CENTER");


  -- if (keystate == "down") then
  --   if getglobal("BA_Menu"):IsVisible() then
  --     getglobal("BA_Menu"):Hide();ß
  --   else
  --     getglobal("BA_Menu"):Show();
  --   end
  -- end

  -- bar.Menu:SetAttribute("_onclick", [[
  --   self:SetPoint("CENTER", "$cursor")
  --
  --   if self:IsVisible() then
  --     self:Hide()
  --   else
  --     self:Show()
  --   end]]
  -- )


  bar.Menu:SetScript("OnDragStart", function(self, event, ...)
    if bar.editMode == true then
      self:StartMoving()
    end
  end);
  bar.Menu:SetScript("OnReceiveDrag", function(self, event, ...) self:StopMovingOrSizing() end);

  -- template
  header = CreateFrame("Button", "TitleButton", bar.Menu, "SecureActionButtonTemplate, SecureHandlerBaseTemplate, BA_MenuLabelTemplate");
  header:SetPoint("TOP", bar.Menu, "TOP", 0, - 5);
  header:SetText(bar.headerText)
  header:SetScript("OnClick", function(self, event, ...)
    StaticPopup_Show("EDIT_MENU_TITLE_DIALOG")
  end)

  -- Config
  configButton = CreateFrame("Button", "ConfigButton", bar.Menu, "SecureActionButtonTemplate, SecureHandlerBaseTemplate, BA_MenuLabelTemplate");
  configButton:SetPoint("BOTTOM", bar.Menu, "BOTTOMRIGHT", - 25, 5);
  configButton:SetText("Config")
  configButton:SetScript("OnClick", editeModeActivation);

  -- EDIT MODE
  editVarning = CreateFrame("Button", "EditModeText", bar.Menu, "SecureActionButtonTemplate, SecureHandlerBaseTemplate, BA_MenuLabelTemplate");
  editVarning:SetPoint("BOTTOM", bar.Menu, "BOTTOMLEFT", 40, 5);
  editVarning:SetText("EDIT MODE")
  editVarning:Hide();
end

function bar:createOneButton(index)
  --[[
  Method to create ONE button
  ]]

  -- populate it with buttons
  local data, setPoint, icon;

  data = bar.buttonLayout[index]
  setPoint = data['setPoint']

  -- Creates button frame
  local button = CreateFrame(data['frameType'], data['name'], getglobal(data['relativeTo']), data['template'], data['id']);
  button:SetPoint(setPoint['point'], getglobal(data['relativeTo']), setPoint['relativePoint'], setPoint['ofsx'], setPoint['ofsy']);

  -- Icon texture layer
  icon =  data['icon']
  setPoint = icon['setPoint']

  button.Icon = button:CreateTexture(data['name'] .. "_icon", icon['layer']);
  button.Icon:SetSize(icon['sizex'], icon['sizey']);
  button.Icon:SetPoint(setPoint['point'], button, setPoint['relativePoint'], setPoint['ofsx'], setPoint['ofsy']);

  -- Cooldown layer
  local cooldown = CreateFrame("Cooldown", data['name'] .. index .. "_cooldown", button, "CooldownFrameTemplate")
  cooldown:SetAllPoints()
  button.cooldown = cooldown

  -- Attributes
  button:SetAttribute("index", index)
  button:SetAttribute("checkselfcast", 1);
  button:SetAttribute("checkfocuscast", 1);
  button:RegisterForDrag("LeftButton");

  -- Scripts
  button:SetScript("OnEnter", function (self) bar:OnEnterShowGameTooltip(self) end);
  button:SetScript("OnLeave", function (self) GameTooltip:Hide() end);

  -- All buttons also got a OnClick for all actions

  button:SetScript("PreClick", function(self, event, ...)
    if bar.editMode == true then
      bar:BarAssistRetrieveCursorItem(self)
     end
  end);

  button:SetScript("OnReceiveDrag", function(self, event, ...)
    if bar.editMode == true then
      bar:BarAssistRetrieveCursorItem(self)
    end
  end);

  button:SetScript("OnDragStart", function(self, event, ...)
    if bar.editMode == true then
      bar:BarAssistPickUpAction(self)

      self:SetAttribute(self.infoType,"");
      self:SetAttribute("type", "");

      local i = self:GetAttribute("index")
      self.infoType = ""
      self.typeID = ""
      self.Texture = ""
      self.Icon:SetTexture("")
      self:SetText("")

      BA_Vars.buttons[i]['infoType'] = ""
      BA_Vars.buttons[i]['typeID'] = ""
      BA_Vars.buttons[i]['Texture'] = ""
      BA_Vars.buttons[i]['nameData'] = ""
    end
  end);

  return button
end
