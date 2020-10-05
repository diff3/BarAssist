local name, bar = ...

--[[
This file will contain functions about buttonbar
]]

function bar:createButton(buttonName, relativeTo, index)
  -- Creates icon overlay to the button
  button = CreateFrame("Button", buttonName, relativeTo, "SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerBaseTemplate, BA_MenuSpellButtonTemplate");
  button:SetBackdropColor(0, 0, 0, 0.9);
  button:SetAttribute("index", index)

  button.Icon = button:CreateTexture(buttonName, "OVERLAY");
  button.Icon:SetSize(16, 16);
  button.Icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, - 2);

  -- If true, and the SELFCAST modifier is held down, resolves the unit to "player".
  button:SetAttribute("checkselfcast", "1");

  -- If true, and the FOCUSCAST modifier is held down, resolves the unit to "focus".
  button:SetAttribute("checkfocuscast", "1");
  button:RegisterForDrag("LeftButton");
  return button
end

function bar:findMountIndex(ID)
  --[[
  Pickup action is based on journal index, and not mountID.
  ]]--
  local numOfMounts = C_MountJournal.GetNumDisplayedMounts()

  for index = 1, numOfMounts, 1
  do
    local mountID = select(12, C_MountJournal.GetDisplayedMountInfo(index));

    if mountID == ID then
      return index
    end
  end
end

function bar:BarAssistPickUpAction(button)
  --[[
  Function for to pickup all types of actions from BarAssist window
  ]]--

  local actionType = button.types;
  local ID = button.typeID;

  if actionType == "battlepet" then
    C_PetJournal.PickupPet(ID);
  elseif actionType == "equipmentset" then
    C_EquipmentSet.PickupEquipmentSet(ID);
  elseif actionType == "item" then
    PickupItem(ID );
  elseif actionType == "macro" then
    PickupMacro(ID);
  elseif actionType == "mount" then
    local index = bar:findMountIndex(ID)
    C_MountJournal.Pickup(index);
  elseif actionType == "spell" then
    PickupSpell(ID);
  end

  return button
end

function bar:BarAssistRetrieveCursorItem(button)
  --[[
  Function handle then BarAction reciev an action (like a spell) and
  saves it. It's extract all data from what's on cursor
  ]]

  oldButton = {
    ["typeID"] = button.typeID,
    ["types"] = button.types
  }

  if (GetCursorInfo()) then
    local infoType, info1, info2 = GetCursorInfo();

    local nameData, textureData, link, typeID;
    local i = button:GetAttribute("index");

    if infoType == "battlepet" then
      typeID = info1;
      customName = select(2, C_PetJournal.GetPetInfoByPetID(info1));
      nameData, textureData = select(8, C_PetJournal.GetPetInfoByPetID(info1));
    elseif infoType == "equipmentset" then
      typeID = C_EquipmentSet.GetEquipmentSetID(info1);
      nameData, textureData, setID = C_EquipmentSet.GetEquipmentSetInfo(typeID);
    elseif infoType == "item" then
      nameData, link = GetItemInfo(info1);
      textureData = select(10, GetItemInfo(info1));
      local parts = select(3, strsplit("|", link));
      typeID = select(2, strsplit(":", parts));
    elseif infoType == "macro" then
      typeID = info1;
      nameData, textureData = GetMacroInfo(info1);
    elseif infoType == "mount" then
      typeID = info1;
      nameData, _, textureData = C_MountJournal.GetMountInfoByID(info1);
    elseif infoType == "spell" then
      nameData, rank = GetSpellBookItemName(info1, info2);
      textureData = GetSpellTexture(nameData);
      link = GetSpellLink(info1, info2);
      local parts = select(3, strsplit("|", link));
      typeID = select(2, strsplit(":", parts));
    end

    buttonData = {
      ["buttonName"] = "Button" .. i,
      ["infoType"] = infoType,
      ["typeID"] = typeID,
      ["textureData"] = textureData,
      ["nameData"] = nameData
    }

    bar:test(button, buttonData)
    bar:test2(i, buttonData)
  end

  ClearCursor();
  bar:BarAssistPickUpAction(oldButton);
  BA_Vars.buttons = bar.buttons
end

function bar:BarAssistUpdateButtonAction()
  --[[
  Sets button action on all buttons, we need to do this everytime button is
  updated and or created.
  ]]

  local buttonData, button
  local ends = bar:countTable()

  -- test if we can use # instead of function
  for i = 0, ends - 1, 1
  do
    button = bar.buttons[0][i]['button']

    if not button then
      break;
    end

    buttonData = bar.buttons[0][i]
    button:SetScript("PreClick", nil)

    if buttonData['infoType'] == "battlepet" then
      button:SetScript("PreClick", function(self)
        C_PetJournal.SummonPetByGUID(tostring(self['typeID']))
      end);
    elseif buttonData['infoType'] == "equipmentset" then
      button:SetScript("PreClick", function(self)
        C_EquipmentSet.UseEquipmentSet(self['typeID'])
      end);
    elseif buttonData['infoType'] == "item" then
      button:SetAttribute("type", buttonData['infoType']);
      button:SetAttribute(buttonData['infoType'], buttonData['nameData']);
    elseif buttonData['infoType'] == "macro" then
      button:SetAttribute("type", buttonData['infoType']);
      button:SetAttribute(buttonData['infoType'], buttonData['nameData']);
    elseif buttonData['infoType'] == "mount" then
      button:SetScript("PreClick", function(self)
        C_MountJournal.SummonByID(self['typeID'])
      end);
    elseif buttonData['infoType'] == "spell" then
      button:SetAttribute("type", buttonData['infoType']);
      button:SetAttribute(buttonData['infoType'], buttonData['nameData']);
    end

    bar.buttons[0][i] = buttonData
  end
end

-- We need to count how many buttons we got, Lua sucks
function bar:countTable()
  count = 0
  for k, v in pairs(bar.buttons[0]) do
    count = count + 1
  end

  return count
end

function bar:restoreSaved()
  ends = bar:countTable()
  for i = 0, ends - 1, 1
  do
    button = bar.buttons[0][i]

    if button['infoType'] then
      buttonData = button
    else
      buttonData = {
        ["buttonName"] = "",
        ["infoType"] = "",
        ["typeID"] = "",
        ["textureData"] = "",
        ["nameData"] = ""
      }
    end

    bar:test(button['button'], buttonData)
  end

  bar:BarAssistUpdateButtonAction()
end

function bar:test(self, buttonData)
  self.types = buttonData['infoType'];
  self.typeID = buttonData['typeID'];
  self.Texture = buttonData['textureData']
  self.Icon:SetTexture(buttonData['textureData'])
  self:SetText(buttonData['nameData'])
  self:SetAttribute(buttonData['infoType'])
end

function bar:test2(index, buttonData)
  bar.buttons[0][index]['buttonName'] = buttonData['buttonName'];
  bar.buttons[0][index]['nameData'] = buttonData['nameData'];
  bar.buttons[0][index]['typeID'] = buttonData['typeID'];
  bar.buttons[0][index]['infoType'] = buttonData['infoType'];
  bar.buttons[0][index]['textureData'] = buttonData['textureData'];
end
