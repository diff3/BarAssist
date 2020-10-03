local name, bar = ...

function bar:init_vars()
  --[[
  This function is called on ADDON_LOADED
  ]]

  bar.buttons = nil

  --if not BA_Vars then
  --  BA_Vars = {}
  --end

  if not BA_Vars.buttons then
    BA_Vars.buttons = {
      ['move'] = false,
      [0] = {
        [0] = {
          ['buttonName'] = "Button1",
          ['nameData'] = "Ghost Wolf",
          ['typeID'] = "2645",
          ['infoType'] = "spell",
          ['textureData'] = GetSpellTexture("Ghost Wolf")
        },
        [1] = {},
        [2] = {},
      }
    }
  end

  bar.buttons = BA_Vars.buttons
end
