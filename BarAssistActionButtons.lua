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
  button.Icon:SetPoint("TOPLEFT", button
  , "TOPLEFT", 2, - 2);

  -- If true, and the SELFCAST modifier is held down, resolves the unit to "player".
  button:SetAttribute("checkselfcast", "1");

  -- If true, and the FOCUSCAST modifier is held down, resolves the unit to "focus".
  button:SetAttribute("checkfocuscast", "1");

  -- MenuItem.myCooldown = CreateFrame("Cooldown", "myCooldown", MenuItem, "CooldownFrameTemplate")
  -- MenuItem.myCooldown:SetAllPoints()

  button:RegisterForDrag("LeftButton");
  return button
end


function bar:BarAssistPickUpAction(button)
  --[[
  Function for to pickup all types of actions from BarAssist window
  ]]--

  actionType = button.types;
  ID = button.typeID
  actionSubType = ""

  if actionType == "mount" then
		C_MountJournal.Pickup(ID);
	elseif actionType == "battlepet" then
		C_PetJournal.PickupPet(ID)
	elseif actionType == "equipmentset" then
		PickupEquipmentSetByName(ID);
	elseif actionType == "item" then
		PickupItem(actionSubType);
	elseif actionType == "macro" then
		PickupMacro(ID);
	elseif actionType == "spell" then
		PickupSpell(ID);
	end

  button.Texture = nil
  button.Icon:SetTexture(nil);
  button:SetText(nil)
  button.types = nil;
  button.typeID = nil;
  button:SetAttribute("type", nil);
  button = nil

  -- does not empty any button at the moment

end

function bar:BarAssistPickUpAction2(ID)
  --[[
  Function for to pickup all types of actions from BarAssist window

  This is just a test to change icons. If you got an icon on pointer and one
  at the menu

  ]]--

  if actionType == "mount" then
		C_MountJournal.Pickup(ID);
	elseif actionType == "battlepet" then
		C_PetJournal.PickupPet(ID)
	elseif actionType == "equipmentset" then
		PickupEquipmentSetByName(ID);
	elseif actionType == "item" then
		PickupItem(actionSubType);
	elseif actionType == "macro" then
		PickupMacro(ID);
	elseif actionType == "spell" then
		PickupSpell(ID);
	end
end

function bar:checkActionBar(button)
  return button.typeID
end

function bar:BarAssistRetrieveCursorItem(test)
  --[[
  Function handle then BarAction reciev an action (like a spell) and
  saves it. It's extract all data from what's on cursor

  at the moment it's just working for spells and macros.
  ]]

  oldButton = bar:checkActionBar(test)

  if (GetCursorInfo()) then
    local infoType, info1, info2 = GetCursorInfo()
    local nameData, rank, textureData, link, ID

    if infoType == "spell" then
      nameData, rank = GetSpellBookItemName( info1, info2 );
      textureData = GetSpellTexture(nameData);
      link = GetSpellLink(info1, info2);
      _, _, parts = strsplit("|", link);
      _, ID = strsplit(":", parts);
    elseif infoType == "macro" then
      nameData, textureData, _ = GetMacroInfo(info1);
      ID = info1
    end

    ClearCursor();
    -- Sets what the button is a spell and what spell to vast
    test.Texture = textureData;
    test.Icon:SetTexture(textureData);
    test:SetText(nameData);

    test.types = infoType;
    test.typeID = ID;

    -- We don't wan't to set an action cos then we can use spells in edit mode
    -- test:SetAttribute("type", infoType);
    -- test:SetAttribute(infoType, nameData);
    i = test:GetAttribute("index")

    bar.buttons[0][i]['buttonName'] = "Button" .. i;
    bar.buttons[0][i]['nameData'] = nameData
    bar.buttons[0][i]['typeID'] = ID;
    bar.buttons[0][i]['infoType'] = infoType;
    bar.buttons[0][i]['textureData'] = textureData

    bar:BarAssistPickUpAction2(oldButton)
  end

  BA_Vars.buttons = bar.buttons
end

-- We need to count how many buttons we got, Lua sucks
function bar:countTable()
  count = 0
  for k,v in pairs(bar.buttons[0]) do
    count = count + 1
  end

  return count
end

function bar:restoreSaved()
  ends = bar:countTable()
  for i=0, ends-1, 1
  do
    buttonData = bar.buttons[0][i]
    button = buttonData['button']
    button:SetAttribute("type", buttonData['infoType']);
    button:SetAttribute(buttonData['infoType'], buttonData['typeID']);
    button.types = buttonData['infoType'];
    button.typeID = buttonData['typeID'];
    button.Texture = buttonData['textureData']
    button.Icon:SetTexture(buttonData['textureData'])
    button:SetText(buttonData['nameData'])
  end
end
