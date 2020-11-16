local name, bar = ...

bar.buttonLayout = {
  [0] = {
    frameType = "Button",
    name = "BarAssistButton0",
    relativeTo = "BA_Menu",
    template = "SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerBaseTemplate, BA_MenuSpellButtonTemplate",
    id = 0,
    setPoint = {point = "TOPLEFT", relativePoint = "TOPLEFT", ofsx = 14, ofsy = -25},
    icon = {sizex = 17, sizey = 17, setPoint = {point = "TOPLEFT", relativePoint = "TOPLEFT", ofsx = 2, ofsy = -2}}
  },
  [1] = {
    frameType = "Button",
    name = "BarAssistButton1",
    relativeTo = "BarAssistButton0",
    template = "SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerBaseTemplate, BA_MenuSpellButtonTemplate",
    id = 1,
    setPoint = {
      point = "TOP",
      relativePoint = "BOTTOM",
      ofsx = 0,
      ofsy = -4
    },
    icon = {
      sizex = 17,
      sizey = 17,
      setPoint = {
        point = "TOPLEFT",
        relativePoint = "TOPLEFT",
        ofsx = 2,
        ofsy = -2
      }
    }
  },
  [2] = {
    frameType = "Button",
    name = "BarAssistButton2",
    relativeTo = "BarAssistButton1",
    template = "SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerBaseTemplate, BA_MenuSpellButtonTemplate",
    id = 2,
    setPoint = {
      point = "TOP",
      relativePoint = "BOTTOM",
      ofsx = 0,
      ofsy = -4
    },
    icon = {
      layer = "OVERLAY",
      sizex = 17,
      sizey = 17,
      setPoint = {
        point = "TOPLEFT",
        relativePoint = "TOPLEFT",
        ofsx = 2,
        ofsy = -2
      }
    }
  }
}
