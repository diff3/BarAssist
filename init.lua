local name, bar = ...

function bar:init_vars()
  --[[
  This function is called on ADDON_LOADED
  ]]

  bar.buttons = nil

  if not BA_Vars.buttons then
    BA_Vars.buttons = {
      ['move'] = false,
      ['headerText'] = "Menu",
      [0] = {
        [0] = {},
        [1] = {},
        [2] = {},
      }
    }
  end

  bar.buttons = BA_Vars.buttons
end
