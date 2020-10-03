local name, bar = ...

function bar:init_vars()
  --[[
  This function is called on ADDON_LOADED
  ]]

  bar.buttons = nil

  if not BA_Vars then
    BA_Vars = {}
  end

  if not BA_Vars.buttons then
    BA_Vars.buttons = {}
    BA_Vars.move = false
  end

  if not BA_Vars.buttons[0] then
    BA_Vars.buttons[0] = {}
  end

  if not BA_Vars.buttons[0][0] then
    BA_Vars.buttons[0][0] = {}
    BA_Vars.buttons[0][1] = {}
    BA_Vars.buttons[0][2] = {}

    BA_Vars.buttons[0][0]['buttonName'] = "Button1";
    BA_Vars.buttons[0][0]['nameData'] = "Ghost Wolf"
    BA_Vars.buttons[0][0]['typeID'] = "2645";
    BA_Vars.buttons[0][0]['infoType'] = "spell";
    BA_Vars.buttons[0][0]['textureData'] = GetSpellTexture("Ghost Wolf");
  end

  bar.buttons = BA_Vars.buttons
end
