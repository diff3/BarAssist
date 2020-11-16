# Assets

## music
https://www.youtube.com/watch?v=I-cC3wSKAGk

## Frame
https://wow.gamepedia.com/API_CreateFrame
https://wowwiki.fandom.com/wiki/API_Region_IsVisible
https://www.mmo-champion.com/threads/975107-Addon-SecureActionButtonTemplate-with-an-OnClick-script
https://www.wowinterface.com/forums/showthread.php?t=28224

## Pupup dialogboxes
https://wowwiki.fandom.com/wiki/Creating_simple_pop-up_dialog_boxes

## Hooks
https://wow.gamepedia.com/Secure_Execution_and_Tainting

## Lua
https://www.tutorialspoint.com/lua/lua_tables.htm
https://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
https://stackoverflow.com/questions/12674345/lua-retrieve-list-of-keys-in-a-table
https://www.tutorialspoint.com/lua/lua_tables.htm
http://lua-users.org/wiki/TablesTutorial

## spells
https://classic.wowhead.com/spell=2645/ghost-wolf

## bindings
https://wow.gamepedia.com/Creating_key_bindings#Specifying_bindings

## macro conditionals
https://wow.gamepedia.com/Macro_conditionals
https://wowwiki.fandom.com/wiki/API_GetMacroIconInfo

## addons examble
https://github.com/diff3/Ghost





  -- COOLDOWN
  -- bar.buttons[0].myCooldown:SetCooldown(GetTime() - 5, 20)
  -- bar.buttons[1].myCooldown:SetCooldown(GetTime() - 5, 40)
  -- bar.buttons[2].myCooldown:SetCooldown(GetTime() - 5, 60)
  -- Show everything

-- BINDINGS
--bar.buttons[0][0]['button']:SetAttribute("_onstate-wpbinding", [[
-- if newstate == "on" then
--  self:SetBindingSpell(false, "SHIFT-T", "Ghost Wolf")
-- elseif newstate == "off" then
--  self:ClearBindings()
-- end
--]])
-- RegisterStateDriver(bar.buttons[0][0]['button'], "wpbinding", "[@target,harm] on; off")
-- RegisterStateDriver(bar.buttons[0][0]['button'], "wpbinding", "[_onclick]")
-- Bindings.


--BarAssistHeader:RegisterForClicks("AnyDown","AnyUp")
--BarAssistHeader:SetAttribute("_onclick", [[
--self:SetPoint("CENTER", "$cursor")
--print("hello")
--if down then
--  self:Show()
--else
--  self:Hide()
--end

--]])


--BINDING_HEADER_BARASSISTHEADER = name
--_G["BINDING_NAME_CLICK BarAssistHeader:LeftButton"] = localKeybind["FRAMEBINDSET"]





Bara göra ett begränsant antal knappar.



Buttons:

button:SetAttribute - only button ID
textureData
nameData

Vars

ID - spellid, itemid etc.
buttonID
infotype - battlepet, equipmentset, item, macro, mount
<id> = true för att söka
realID
bookID




bar.buttons[0][index]['buttonName'] = buttonData['buttonName'];
bar.buttons[0][index]['nameData'] = buttonData['nameData'];
bar.buttons[0][index]['typeID'] = buttonData['typeID'];
bar.buttons[0][index]['infoType'] = buttonData['infoType'];
bar.buttons[0][index]['textureData'] = buttonData['textureData'];
bar.buttons[0][index]['spellId'] = buttonData['spellId'];
end
