local name, bar = ...

bar.eventFrame = CreateFrame("Frame", "eventFrame")
bar.eventFrame:RegisterEvent("ADDON_LOADED")
-- bar.eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

-- this function let us create funtions of all the events, looks nicer.
bar.eventFrame:SetScript("OnEvent",
    function(self, event, ...)
        if (type(bar[event]) == 'function') then
            bar[event](self, event, ...);
        end
    end
)

function bar:ADDON_LOADED(self, event)
    if event == "BarAssist" then
      print("BarAssist loaded");

      -- It's not until now all between session variables is loaded, if we
      -- run init or create all before this point we will reciev an error
      bar:init_vars()
      bar:createAll()
    end
end

-- test to show an cooldown animation on buttons
function bar:UNIT_SPELLCAST_SUCCEEDED(self, arg1, arg2, arg3)
  name, rank, spellid, castTime, minRange, maxRange, spellId = GetSpellInfo(arg3)
  if arg1 == "player" then
    -- we need to wait 0.2 secounds or we won't get any information from GetSpellCooldown
    C_Timer.After(0.2, function()
      local start, duration, enabled, modRate = GetSpellCooldown(arg3)
      bar.buttons[0].myCooldown:SetCooldown(start, duration)
    end)
  end
end
