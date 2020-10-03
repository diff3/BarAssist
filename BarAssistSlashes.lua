local name, bar = ...

-- Cut string in half at the first blankspace
function bar:SlashFormat(msg)
    msg = string.lower(msg)

    if not string.find(msg, " ") then
        return msg
    end

    -- return msg, param
    return select(3, string.find(msg, "^([^ ]+) (.+)$"))
end

-- Setup slash command for resetting variables and position
function bar.SlashHandler(msg, editbox)
    msg, param = bar:SlashFormat(msg)

    if msg == 'help' then
        print(name .. ": Usages /ba help");
    elseif msg == 'reset' then
        print(name .. "Settings resetted")
        BA_Vars = {}
        bar.buttons = {}
        bar:init_vars()
        bar:createAll()
    elseif msg == 'macro' then
      -- ShowMacroFrame()
      _G['MacroPopupFrame']:Show();
    else
        print(name .. ": Usages /ba help");
    end
end

SlashCmdList["BARASSIST"] = bar.SlashHandler;
SLASH_BARASSIST1 = '/barassist'
SLASH_BARASSIST2 = '/ba'
