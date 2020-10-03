local name, bar = ...

function bar:BarAssistShowFrame()
  if (keystate == "down") then
    bar.Menu:Show();
  else
    bar.Menu:Hide();
  end
end
