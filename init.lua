local name, bar = ...

function bar:init_vars()
  --[[
  This function is called by ADDON_LOADED
  ]]--

  bar.editMode = false

  if not BA_Vars then
    BA_Vars = {}
  end

  if not BA_Vars.headerText then
    BA_Vars.headerText = "Menu"
  end

  if not BA_Vars.buttons then
    BA_Vars.buttons = {
      [0] = {},
      [1] = {},
      [2] = {},
    }
  end

  bar.headerText = BA_Vars.headerText
end
