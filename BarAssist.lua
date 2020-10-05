-- simple way to share information between files in lua.
local name, bar = ...

function pickUpAction(self, event, ...)
  local button = bar:BarAssistPickUpAction(self)
  local index = button:GetAttribute("index")
  local buttonData = {
    ["buttonName"] = "",
    ["infoType"] = "",
    ["typeID"] = "",
    ["textureData"] = "",
    ["nameData"] = ""
  }

  bar:test(button, buttonData)
  bar:test2(index, buttonData)
end

function retrievCursorItem(self, event, ...)
  bar:BarAssistRetrieveCursorItem(self)
end

function startMov(self, event, ...)
  self:StartMoving();
end

function stopMov(self, event, ...)
  self:StopMovingOrSizing();
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
    bar.buttons['headerText'] = text
  end,
  hasEditBox = true
}

function BarAssistPopUpDialog()
  StaticPopup_Show("EDIT_MENU_TITLE_DIALOG");
end

function editeModeActivation()
  -- This function turn off the edit mode, and reactivate all buttons
  -- this should be rewritten
  local ends = bar:countTable()

  if editVarning:IsVisible() then
    editVarning:Hide();
    for i = 0, ends - 1, 1
    do
      if bar.buttons[0][i]['infoType'] then
        buttonData = bar.buttons[0][i]
        button = bar.buttons[0][i]['button']
        button:SetScript("PreClick", nil);
        button:SetScript("OnDragStart", nil);
        button:SetScript("OnReceiveDrag", nil);
        bar.buttons[0][i]['button'] = button
      end
    end
    bar:BarAssistUpdateButtonAction()
  else
    -- This function turn on the edit mode, and reactivate all buttons
    editVarning:Show();
    for i = 0, ends - 1, 1
    do
      buttonData = bar.buttons[0][i]
      button = bar.buttons[0][i]['button']
      if button:GetAttribute("type") then
        button:SetAttribute(buttonData['infoType'], nil);
        button:SetAttribute("type", nil);
      end

      button:SetScript("PreClick", retrievCursorItem);
      button:SetScript("OnDragStart", pickUpAction);
      button:SetScript("OnReceiveDrag", retrievCursorItem);
      bar.buttons[0][i]['button'] = button
    end
  end
end

function bar:createAll()
  -- Create a Base frame and a button
  bar.Menu = CreateFrame("Frame", "BA_Menu", UIParent, "SecureHandlerBaseTemplate, BA_MenuContainer");
  bar.Menu:SetMovable(true)
  bar.Menu:EnableMouse(true)
  bar.Menu:RegisterForDrag("LeftButton");
  bar.Menu:SetScript("OnDragStart", startMov);
  bar.Menu:SetScript("OnReceiveDrag", stopMov);
  bar.Menu:SetBackdropColor(0, 0, 0, 0.9);

  -- template text (title)
  header = CreateFrame("Button", "TitleButton", bar.Menu, "SecureActionButtonTemplate, SecureHandlerBaseTemplate, BA_MenuLabelTemplate");
  header:SetPoint("TOP", bar.Menu, "TOP", 0, - 5);
  header:SetText(bar.buttons['headerText'])
  header:SetScript("OnClick", BarAssistPopUpDialog);

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

  -- create 3 buttons
  bar.buttons[0][0]['button'] = bar:createButton("BarAssistButton1", bar.Menu, 0)
  bar.buttons[0][1]['button'] = bar:createButton("Button2", bar.buttons[0][0]['button'], 1)
  bar.buttons[0][2]['button'] = bar:createButton("Button3", bar.buttons[0][1]['button'], 2)

  -- Where to display
  bar.Menu:SetPoint("CENTER");
  bar.buttons[0][0]['button']:SetPoint("TOPLEFT", bar.Menu, "TOPLEFT", 14, - 25);
  bar.buttons[0][1]['button']:SetPoint("TOP", bar.buttons[0][0]['button'], "BOTTOM", 0, - 4)
  bar.buttons[0][2]['button']:SetPoint("TOP", bar.buttons[0][1]['button'], "BOTTOM", 0, - 4)

  -- Sets what the button is a spell and what spell to vast
  if BA_Vars then
    bar:restoreSaved()
  end

  bar.Menu:Show();
end
