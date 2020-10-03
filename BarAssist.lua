-- simple way to share information between files in lua.
local name, bar = ...

bar.buttons = {}

function pickUpAction(self, event, ...)
  bar:BarAssistPickUpAction(self)
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

function test22()
  StaticPopup_Show("EXAMPLE_HELLOWORLD");
end

function test23()
  -- This function turn off the edit mode, and reactivate all buttons

  if item3:IsVisible() then
    item3:Hide();
      ends = bar:countTable()
    for i=0, ends -1, 1
    do
      buttonData = bar.buttons[0][i]
      button =  bar.buttons[0][i]['button']
      button:SetAttribute("type", buttonData['infoType']);
      button:SetAttribute(buttonData['infoType'], buttonData['nameData']);
      button:SetScript("PreClick", nil);
      button:SetScript("OnDragStart", nil);
      button:SetScript("OnReceiveDrag", nil);
      bar.buttons[0][i]['button'] = button
    end
  else
    -- This function turn on the edit mode, and reactivate all buttons
    item3:Show();
    ends = bar:countTable()
    for i=0, ends -1, 1
    do
      buttonData = bar.buttons[0][i]
      button =  bar.buttons[0][i]['button']

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

-- Create a popup menu to enter text
StaticPopupDialogs["EXAMPLE_HELLOWORLD"] = {
  text = "Enter a new name for menu",
  button1 = "Save",
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 1,
  OnShow = function (self, data)
    self.editBox:SetText(item:GetText())
  end,
  OnAccept = function (self, data, data2)
    local text = self.editBox:GetText()
    item:SetText(text)
  end,
  hasEditBox = true
}

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
  item = CreateFrame("Button", "test", bar.Menu, "SecureActionButtonTemplate, SecureHandlerBaseTemplate, BA_MenuLabelTemplate");
  item:SetPoint("TOP", bar.Menu, "TOP", 0, -5);
  item:SetText("Healing spells")
  item:SetScript("OnClick", test22);

  -- Config
  item2 = CreateFrame("Button", "test1", bar.Menu, "SecureActionButtonTemplate, SecureHandlerBaseTemplate, BA_MenuLabelTemplate");
  item2:SetPoint("BOTTOM", bar.Menu, "BOTTOMRIGHT", -25, 5);
  item2:SetText("Config")
  item2:SetScript("OnClick", test23);

  -- EDIT MODE
  item3 = CreateFrame("Button", "test2", bar.Menu, "SecureActionButtonTemplate, SecureHandlerBaseTemplate, BA_MenuLabelTemplate");
  item3:SetPoint("BOTTOM", bar.Menu, "BOTTOMLEFT", 40, 5);
  item3:SetText("EDIT MODE")
  item3:Hide();

  -- create 3 buttons
  bar.buttons[0][0]['button'] = bar:createButton("BarAssistButton1", bar.Menu, 0)
  bar.buttons[0][1]['button'] = bar:createButton("Button2", bar.buttons[0][0]['button'], 1)
  bar.buttons[0][2]['button'] = bar:createButton("Button3", bar.buttons[0][1]['button'], 2)

  -- Where to display
  bar.Menu:SetPoint("CENTER");
  bar.buttons[0][0]['button']:SetPoint("TOPLEFT", bar.Menu, "TOPLEFT", 14, -25);
  bar.buttons[0][1]['button']:SetPoint("TOP", bar.buttons[0][0]['button'], "BOTTOM", 0, -4)
  bar.buttons[0][2]['button']:SetPoint("TOP", bar.buttons[0][1]['button'], "BOTTOM", 0, -4)

  -- Sets what the button is a spell and what spell to vast
  if BA_Vars then
      bar:restoreSaved()
  end

  bar.Menu:Show();
end
