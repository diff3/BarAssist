local name, bar = ...

function BarAssistShowFrame()
  if bar.Menu.IsVisible() then
    bar.Menu:Hide()
  else
    bar.Menu:Show()
  end

  --[[
  if (keystate == "down") then
    bar.Menu:Show();
  else
    bar.Menu:Hide();
  end
  ]]
end
