local name, bar = ...

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

function bar:OnEnterShowGameTooltip(self)
  --[[
    Gather data and show basic GameTooltip. SetHyperlink are limited to:
    item, enchant, spell and quest.

    It supposed to work with itemLink as well but I don't get it wot work.
  ]]--

  local infoType = self.infoType
  local typeID = self.typeID

  GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)

  if infoType == "battlepet" then
    local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique, obtainable = C_PetJournal.GetPetInfoByPetID(typeID)
    GameTooltip:SetText(name)
  elseif infoType == "equipmentset" then
    local name, iconFileID, setID, isEquipped, numItems, numEquipped, numInInventory, numLost, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(typeID)
    GameTooltip:SetText(name)
  elseif infoType == "item" then
    GameTooltip:SetHyperlink("item:" .. typeID .. ":0:0:0:0:0:0:0")
  elseif infoType == "macro" then
    local name, icon, body, isLocal = GetMacroInfo(typeID)
    GameTooltip:SetText(name)
  elseif infoType == "mount" then
      _, spellId = C_MountJournal.GetMountInfoByID(typeID);
     GameTooltip:SetHyperlink("spell:" .. spellId .. ":0:0:0:0:0:0:0")
  elseif infoType == "spell" then
     GameTooltip:SetHyperlink("spell:" .. typeID .. ":0:0:0:0:0:0:0")
  else
    return
  end

  GameTooltip:Show()
end

-- We need to count how many buttons we got, Lua sucks
function bar:countTable()
  count = 0
  for k, v in pairs(bar.buttons) do
    count = count + 1
  end

  return count
end

function bar:BarAssistRetrieveCursorItem(btn)
  local i = btn:GetAttribute("index");

  if (GetCursorInfo()) then
    local infoType, info1, info2 = GetCursorInfo();
    local nameData, textureData, link, typeID;

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
      typeID = info1
      nameData, spellId, textureData = C_MountJournal.GetMountInfoByID(info1)
    elseif infoType == "spell" then
      nameData, rank = GetSpellBookItemName(info1, info2);
      textureData = GetSpellTexture(nameData);
      link = GetSpellLink(info1, info2);
      local parts = select(3, strsplit("|", link));
      typeID = select(2, strsplit(":", parts));
    end

    ClearCursor()
    bar:BarAssistPickUpAction(btn)

    btn.infoType = infoType
    btn.typeID = typeID
    btn.Texture = textureData
    btn.Icon:SetTexture(textureData)
    btn:SetText(nameData)

    BA_Vars.buttons[i]['infoType'] = infoType
    BA_Vars.buttons[i]['typeID'] = typeID
    BA_Vars.buttons[i]['Texture'] = textureData
    BA_Vars.buttons[i]['nameData'] = nameData
  end
end

function bar:BarAssistPickUpAction(btn)
  --[[
  Function for to pickup all types of actions from BarAssist window
  ]]--

  local actionType = btn.infoType
  local ID = btn.typeID

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
  else
    return
  end
end

function bar:UpdateButtonActions(btn)
  --[[
  Sets button action on all buttons, we need to do this everytime button is
  updated and or created.
  ]]

  if btn.infoType == "battlepet" then
    btn:SetScript("OnClick", function(self)
      if bar.editMode == false then
        C_PetJournal.SummonPetByGUID(tostring(self.typeID))
      end
    end);
  elseif btn.infoType == "equipmentset" then -- working
    btn:SetScript("OnClick", function(self)
      if bar.editMode == false then
        C_EquipmentSet.UseEquipmentSet(self.typeID)
      end
    end);
  elseif btn.infoType == "item" then
    if bar.editMode == false then
      btn:SetAttribute("type", "item");
      btn:SetAttribute("item", btn.nameData);
    else
      btn:SetAttribute("spell", nil)
      btn:SetAttribute("type", nil)
    end
  elseif btn.infoType == "macro" then
    if bar.editMode == false then
      btn:SetAttribute("type", "macro");
      btn:SetAttribute("macro", btn.nameData);
    else
      btn:SetAttribute("spell", nil)
      btn:SetAttribute("type", nil)
    end
  elseif btn.infoType == "mount" then -- working
    btn:SetScript("OnClick", function(self)
      if bar.editMode == false then
        C_MountJournal.SummonByID(self.typeID)
      end
    end)
  elseif btn.infoType == "spell" then
    if bar.editMode == false then
      btn:SetAttribute("type", "spell")
      btn:SetAttribute("spell", btn.nameData)
    else
      btn:SetAttribute("spell", nil)
      btn:SetAttribute("type", nil)
    end
  end
end

function bar:restoreSavedButtons(btn)
    local index = btn:GetAttribute('index')

    if BA_Vars.buttons[index]['infoType'] then
      btn.infoType = BA_Vars.buttons[index]['infoType']
      btn.typeID = BA_Vars.buttons[index]['typeID']
      btn.Texture = BA_Vars.buttons[index]['Texture']
      btn.Icon:SetTexture(btn.Texture)
      btn.nameData = BA_Vars.buttons[index]['nameData']
      btn:SetText(btn.nameData)
    end
end
