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


function bar:BarAssistPickUpAction(button)
  --[[
  Function for to pickup all types of actions from BarAssist window
  ]]--

  actionType = button.types;
  ID = button.typeID
  actionSubType = ""

  if actionType == "mount" then
    local index = bar:getFuckingMounth(ID)
		C_MountJournal.Pickup(index);
	elseif actionType == "battlepet" then
		C_PetJournal.PickupPet(ID)
	elseif actionType == "equipmentset" then
		C_EquipmentSet.PickupEquipmentSet(ID);
	elseif actionType == "item" then
		PickupItem(actionSubType);
	elseif actionType == "macro" then
		PickupMacro(ID);
	elseif actionType == "spell" then
		PickupSpell(ID);
	end

  i = button:GetAttribute("index")
  button.Texture = nil
  button.Icon:SetTexture(nil);
  button:SetText(nil)
  button.types = nil;
  button.typeID = nil;
  button:SetAttribute("type", nil);
  button = nil

  bar.buttons[0][i]['buttonName'] = "Button" .. i;
  bar.buttons[0][i]['nameData'] = nameData
  bar.buttons[0][i]['typeID'] = ID;
  bar.buttons[0][i]['infoType'] = infoType;
  bar.buttons[0][i]['textureData'] = textureData
end

function bar:getFuckingMounth(ID)
  ant = C_MountJournal.GetNumDisplayedMounts()

  for index=1, ant, 1
  do
    _,_,_,_,_,_,_,_,_,_,_,mountID = C_MountJournal.GetDisplayedMountInfo(index)

    if mountID == ID then
      return index
    end

  end

end

function bar:BarAssistPickUpAction2(ID, actionType)
  --[[
  Function for to pickup all types of actions from BarAssist window
  ]]--

  if actionType == "mount" then
    local index = bar:getFuckingMounth(ID)
    C_MountJournal.Pickup(index);
	elseif actionType == "battlepet" then
		C_PetJournal.PickupPet(ID)
	elseif actionType == "item" then
		PickupItem(ID);
	elseif actionType == "macro" then
		PickupMacro(ID);
	elseif actionType == "spell" then
		PickupSpell(ID);
  elseif actionType == "equipmentset" then
		C_EquipmentSet.PickupEquipmentSet(ID);
	end
end

function bar:BarAssistRetrieveCursorItem(test)
  --[[
  Function handle then BarAction reciev an action (like a spell) and
  saves it. It's extract all data from what's on cursor
  ]]

  oldButton = test.typeID
  oldInfoType = test.types

  if (GetCursorInfo()) then
    local infoType, info1, info2 = GetCursorInfo()
    local nameData, rank, textureData, link, ID
    local i = test:GetAttribute("index")

    if infoType == "spell" then
      nameData, rank = GetSpellBookItemName( info1, info2 );
      textureData = GetSpellTexture(nameData);
      link = GetSpellLink(info1, info2);
      _, _, parts = strsplit("|", link);
      _, ID = strsplit(":", parts);
    elseif infoType == "macro" then
      nameData, textureData, _ = GetMacroInfo(info1);
      ID = info1
    -- elseif infoType == "companion" then

  		--	_, nameData = GetCompanionInfo(info1, info2);
  	elseif infoType == "item" then
  			nameData, link, _, _, _, _, _, _, _, textureData = GetItemInfo(info1);
  			local _, _, parts = strsplit("|", link);

  			_, ID = strsplit(":", parts);
    elseif infoType == "mount" then
      creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected, mountID = C_MountJournal.GetMountInfoByID(info1)
      print(spellID)
      print(mountID)
     nameData, _, textureData = C_MountJournal.GetMountInfoByID(info1);
      ID = info1
  	elseif infoType == "battlepet" then
        ID = info1
      _, customName, _, _, _, _, _, nameData, textureData = C_PetJournal.GetPetInfoByPetID(info1)
    elseif infoType == "equipmentset" then
      equipmentSetID = C_EquipmentSet.GetEquipmentSetID(info1)
      nameData, textureData, setID = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID)
      ID = equipmentSetID
    end

    ClearCursor();
    -- Sets what the button is a spell and what spell to vast
    test.Texture = textureData;
    test.Icon:SetTexture(textureData);
    test:SetText(nameData);

    test.types = infoType;
    test.typeID = ID;

    -- We don't wan't to set an action cos then we can use spells in edit mode
    i = test:GetAttribute("index")

    bar.buttons[0][i]['buttonName'] = "Button" .. i;
    bar.buttons[0][i]['nameData'] = nameData
    bar.buttons[0][i]['typeID'] = ID;
    bar.buttons[0][i]['infoType'] = infoType;
    bar.buttons[0][i]['textureData'] = textureData

    bar:BarAssistPickUpAction2(oldButton, oldInfoType)
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
    if bar.buttons[0][i]['infoType'] then
    buttonData = bar.buttons[0][i]
    button = buttonData['button']
    button.types = buttonData['infoType'];
    button.typeID = buttonData['typeID'];
    button.Texture = buttonData['textureData']
    button.Icon:SetTexture(buttonData['textureData'])
    button:SetText(buttonData['nameData'])
  else
    button = bar.buttons[0][i]['button']
    if button then
    button.types = ""
    button.typeID = ""
    button.Texture = ""
    button.Icon:SetTexture("")
    button:SetText("")
  end
  end
  end
  bar:createButtonsNew()
end
