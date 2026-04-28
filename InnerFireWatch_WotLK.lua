-- InnerFireWatch (WoW 3.3.5 / Epoch)
-- Clean build v2.0

InnerFireWatchDB = InnerFireWatchDB or {}

local frame = CreateFrame("Frame")
local optionsFrame

local COLOR_PRESETS = {
  { key = "white",  text = "White",  r = 1.0, g = 1.0, b = 1.0 },
  { key = "green",  text = "Green",  r = 0.0, g = 1.0, b = 0.0 },
  { key = "blue",   text = "Blue",   r = 0.0, g = 0.4, b = 1.0 },
  { key = "red",    text = "Red",    r = 1.0, g = 0.0, b = 0.0 },
  { key = "yellow", text = "Yellow", r = 1.0, g = 1.0, b = 0.0 },
  { key = "purple", text = "Purple", r = 0.7, g = 0.0, b = 1.0 },
}

local CLASS_COLORS_IFW = {
  WARRIOR = { r = 0.78, g = 0.61, b = 0.43 },
  MAGE    = { r = 0.41, g = 0.80, b = 0.94 },
  PRIEST  = { r = 1.00, g = 1.00, b = 1.00 },
  SHAMAN  = { r = 0.00, g = 0.44, b = 0.87 },
}

local DEFAULTS = {
  soundEnabled = true,
  useCustomSound = false,
  gainedMessage = false,
  largeMessageEnabled = true,
  largeMessageR = 1,
  largeMessageG = 0,
  largeMessageB = 0,
  colorPreset = "red",
  customSoundPath = "Interface\\AddOns\\InnerFireWatch_WotLK\\sounds\\expire.wav",
  fallbackSound = "RaidWarning",
}

local trackers = {}

local function ApplyDefaults()
  for k, v in pairs(DEFAULTS) do
    if InnerFireWatchDB[k] == nil then
      InnerFireWatchDB[k] = v
    end
  end
end

local function SetColorPresetByKey(key)
  local i
  for i = 1, #COLOR_PRESETS do
    local p = COLOR_PRESETS[i]
    if p.key == key then
      InnerFireWatchDB.colorPreset = p.key
      InnerFireWatchDB.largeMessageR = p.r
      InnerFireWatchDB.largeMessageG = p.g
      InnerFireWatchDB.largeMessageB = p.b
      return
    end
  end
end

local function GetCurrentColorPresetText()
  local i
  for i = 1, #COLOR_PRESETS do
    if COLOR_PRESETS[i].key == InnerFireWatchDB.colorPreset then
      return COLOR_PRESETS[i].text
    end
  end
  return "Red"
end

local function GetDetectedClassText()
  local className = UnitClass("player")
  return className or "Unknown"
end

local function GetDetectedClassColor()
  local _, classToken = UnitClass("player")
  if classToken and CLASS_COLORS_IFW[classToken] then
    return CLASS_COLORS_IFW[classToken].r, CLASS_COLORS_IFW[classToken].g, CLASS_COLORS_IFW[classToken].b
  end
  return 0.8, 0.8, 0.8
end

local function ClassHasFeatures()
  local _, classToken = UnitClass("player")
  return classToken == "PRIEST" or classToken == "WARRIOR" or classToken == "SHAMAN" or classToken == "MAGE"
end

-- Large center message
local CenterAlert = CreateFrame("Frame", "InnerFireWatchCenterAlert", UIParent)
CenterAlert:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
CenterAlert:SetWidth(700)
CenterAlert:SetHeight(90)
CenterAlert:Hide()

CenterAlert.text = CenterAlert:CreateFontString(nil, "OVERLAY")
CenterAlert.text:SetAllPoints(CenterAlert)
CenterAlert.text:SetFont("Fonts\\FRIZQT__.TTF", 32, "OUTLINE")
CenterAlert.text:SetJustifyH("CENTER")
CenterAlert.text:SetJustifyV("MIDDLE")

local function ShowCenterAlert(msg)
  CenterAlert:SetAlpha(1)
  CenterAlert.text:SetText(msg or "")
  CenterAlert.text:SetTextColor(InnerFireWatchDB.largeMessageR, InnerFireWatchDB.largeMessageG, InnerFireWatchDB.largeMessageB)
  CenterAlert:Show()
  CenterAlert.startTime = GetTime()
end

CenterAlert:SetScript("OnUpdate", function(self)
  if not self:IsShown() then return end

  local elapsed = GetTime() - (self.startTime or 0)
  if elapsed >= 2.5 then
    self:Hide()
    return
  end

  self:SetAlpha(1 - (elapsed / 2.5))
end)

local function PlayExpireSound()
  if not InnerFireWatchDB.soundEnabled then return end

  if InnerFireWatchDB.useCustomSound then
    if PlaySoundFile then
      PlaySoundFile(InnerFireWatchDB.customSoundPath)
    end
    return
  end

  if PlaySound then
    PlaySound(InnerFireWatchDB.fallbackSound)
  end
end

local function NotifyExpired(buffLabel)
  local msg = buffLabel .. " has expired!"

  DEFAULT_CHAT_FRAME:AddMessage("|cffff3333" .. msg .. "|r")

  if InnerFireWatchDB.largeMessageEnabled then
    ShowCenterAlert(string.upper(buffLabel) .. " EXPIRED!")
  end

  if UIErrorsFrame and UIErrorsFrame.AddMessage then
    UIErrorsFrame:AddMessage(msg, 1.0, 0.1, 0.1, 53, 5)
  end

  PlayExpireSound()
end

local function NotifyGained(buffLabel)
  if not InnerFireWatchDB.gainedMessage then return end
  DEFAULT_CHAT_FRAME:AddMessage("|cff33ff33" .. buffLabel .. " active.|r")
end

local function HasBuffByName(unit, buffName)
  local i = 1
  while true do
    local name = UnitBuff(unit, i)
    if not name then
      break
    end

    if name == buffName then
      return true
    end

    i = i + 1
  end

  return false
end

local function BuildTrackers()
  trackers = {}

  local _, classToken = UnitClass("player")

  if classToken == "PRIEST" then
    table.insert(trackers, { label = "Inner Fire", name = "Inner Fire", active = false })
  elseif classToken == "WARRIOR" then
    table.insert(trackers, { label = "Battle Shout", name = "Battle Shout", active = false })
  elseif classToken == "SHAMAN" then
    table.insert(trackers, { label = "Lightning Shield", name = "Lightning Shield", active = false })
    table.insert(trackers, { label = "Water Shield", name = "Water Shield", active = false })
    table.insert(trackers, { label = "Earth Shield", name = "Earth Shield", active = false })
  elseif classToken == "MAGE" then
    table.insert(trackers, { label = "Frost Armor", name = "Frost Armor", active = false })
    table.insert(trackers, { label = "Ice Armor", name = "Ice Armor", active = false })
    table.insert(trackers, { label = "Mage Armor", name = "Mage Armor", active = false })
  end

  local i
  for i = 1, #trackers do
    trackers[i].active = HasBuffByName("player", trackers[i].name)
  end
end

local function CheckBuffs()
  if not trackers or #trackers == 0 then return end

  local i
  for i = 1, #trackers do
    local t = trackers[i]
    local nowActive = HasBuffByName("player", t.name)

    if t.active and not nowActive then
      NotifyExpired(t.label)
    elseif (not t.active) and nowActive then
      NotifyGained(t.label)
    end

    t.active = nowActive
  end
end

-- Options UI helpers
local function ApplyOptionsBackdrop(parent)
  if parent.bg then return end

  parent.bg = parent:CreateTexture(nil, "BACKGROUND")
  parent.bg:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, -8)
  parent.bg:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -8, 8)
  parent.bg:SetTexture(0, 0, 0, 0.90)

  parent.border = CreateFrame("Frame", nil, parent)
  parent.border:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -4)
  parent.border:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -4, 4)
  parent.border:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  })
end

local function CreateCheckbox(parent, labelText, x, y, getter, setter)
  local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  cb:SetWidth(24)
  cb:SetHeight(24)
  cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

  local text = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  text:SetPoint("LEFT", cb, "RIGHT", 4, 0)
  text:SetText(labelText)

  cb:SetScript("OnClick", function(self)
    setter(self:GetChecked() and true or false)
  end)

  cb.Refresh = function(self)
    self:SetChecked(getter() and true or false)
  end

  return cb
end

local function RefreshOptionsUI()
  if not optionsFrame then return end

  if optionsFrame.classText then
    optionsFrame.classText:SetText("Class Detected: " .. GetDetectedClassText())
    optionsFrame.classText:SetTextColor(GetDetectedClassColor())
  end

  if optionsFrame.noFeaturesText then
    if ClassHasFeatures() then
      optionsFrame.noFeaturesText:SetText("")
    else
      optionsFrame.noFeaturesText:SetText("No features are available for this class.")
    end
  end

  if optionsFrame.soundCB then optionsFrame.soundCB:Refresh() end
  if optionsFrame.customSoundCB then optionsFrame.customSoundCB:Refresh() end
  if optionsFrame.gainedCB then optionsFrame.gainedCB:Refresh() end
  if optionsFrame.largeCB then optionsFrame.largeCB:Refresh() end
  if optionsFrame.colorText then optionsFrame.colorText:SetText(GetCurrentColorPresetText()) end
end

local function CreateOptionsWindow()
  if optionsFrame then return end

  local f = CreateFrame("Frame", "InnerFireWatchOptionsFrame", UIParent)
  f:SetWidth(360)
  f:SetHeight(385)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  f:SetFrameStrata("DIALOG")
  f:SetFrameLevel(20)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  f:Hide()

  ApplyOptionsBackdrop(f)
  table.insert(UISpecialFrames, "InnerFireWatchOptionsFrame")

  local title = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOP", f, "TOP", 0, -14)
  title:SetText("InnerFireWatch")

  local subtitle = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  subtitle:SetPoint("TOP", title, "BOTTOM", 0, -4)
  subtitle:SetText("Made for Epoch")

  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)

  local x = 22
  local y = -52
  local rowGap = 10

  f.classText = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  f.classText:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
  f.classText:SetText("Class Detected: ")
  y = y - 12 - 4

  f.noFeaturesText = f:CreateFontString(nil, "ARTWORK", "GameFontRedSmall")
  f.noFeaturesText:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
  f.noFeaturesText:SetText("")
  y = y - 14 - rowGap

  f.soundCB = CreateCheckbox(f, "Enable sound", x - 4, y, function()
    return InnerFireWatchDB.soundEnabled
  end, function(value)
    InnerFireWatchDB.soundEnabled = value
  end)
  y = y - 24 - rowGap

  f.customSoundCB = CreateCheckbox(f, "Use Custom Sound File", x - 4, y, function()
    return InnerFireWatchDB.useCustomSound
  end, function(value)
    InnerFireWatchDB.useCustomSound = value
  end)
  y = y - 24 - 4

  local soundNote = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
  soundNote:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
  soundNote:SetText("Sounds/expire.wav file in AddOn Folder")
  y = y - 14 - rowGap

  local testSound = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  testSound:SetWidth(90)
  testSound:SetHeight(22)
  testSound:SetPoint("TOPLEFT", f, "TOPLEFT", x - 4, y)
  testSound:SetText("Test Sound")
  testSound:SetScript("OnClick", function()
    PlayExpireSound()
  end)
  y = y - 22 - rowGap

  f.gainedCB = CreateCheckbox(f, "Show gained message", x - 4, y, function()
    return InnerFireWatchDB.gainedMessage
  end, function(value)
    InnerFireWatchDB.gainedMessage = value
  end)
  y = y - 24 - rowGap

  f.largeCB = CreateCheckbox(f, "Show large center message", x - 4, y, function()
    return InnerFireWatchDB.largeMessageEnabled
  end, function(value)
    InnerFireWatchDB.largeMessageEnabled = value
  end)
  y = y - 24 - rowGap

  local colorLabel = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  colorLabel:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
  colorLabel:SetText("Large message color:")
  y = y - 30

  local dd = CreateFrame("Frame", "InnerFireWatchColorDropdown", f, "UIDropDownMenuTemplate")
  dd:SetPoint("TOPLEFT", f, "TOPLEFT", x - 12, y + 8)
  UIDropDownMenu_SetWidth(dd, 140)

  f.colorText = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  f.colorText:SetPoint("LEFT", dd, "RIGHT", -10, 2)
  f.colorText:SetText("")

  UIDropDownMenu_Initialize(dd, function(self, level)
    local i
    for i = 1, #COLOR_PRESETS do
      local p = COLOR_PRESETS[i]
      local info = UIDropDownMenu_CreateInfo()
      info.text = p.text
      info.func = function()
        SetColorPresetByKey(p.key)
        UIDropDownMenu_SetSelectedID(dd, i)
        RefreshOptionsUI()
      end
      UIDropDownMenu_AddButton(info, level)
    end
  end)

  local i
  for i = 1, #COLOR_PRESETS do
    if COLOR_PRESETS[i].key == InnerFireWatchDB.colorPreset then
      UIDropDownMenu_SetSelectedID(dd, i)
      break
    end
  end

  local preview = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  preview:SetWidth(90)
  preview:SetHeight(22)
  preview:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 18, 18)
  preview:SetText("Preview")
  preview:SetScript("OnClick", function()
    ShowCenterAlert("PREVIEW MESSAGE")
    PlayExpireSound()
  end)

  local closeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  closeBtn:SetWidth(120)
  closeBtn:SetHeight(22)
  closeBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -18, 18)
  closeBtn:SetText("Save & Close")
  closeBtn:SetScript("OnClick", function()
    f:Hide()
  end)

  optionsFrame = f
  RefreshOptionsUI()
end

local function ToggleOptionsWindow()
  if not optionsFrame then
    CreateOptionsWindow()
  end

  if optionsFrame:IsShown() then
    optionsFrame:Hide()
  else
    RefreshOptionsUI()
    optionsFrame:Show()
  end
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UNIT_AURA")

frame:SetScript("OnEvent", function(self, event, arg1)
  if event == "PLAYER_LOGIN" then
    ApplyDefaults()
    SetColorPresetByKey(InnerFireWatchDB.colorPreset or "red")
    BuildTrackers()
    CreateOptionsWindow()
    return
  end

  if event == "UNIT_AURA" and arg1 == "player" then
    CheckBuffs()
  end
end)

SLASH_INNERFIREWATCH1 = "/ifw"
SlashCmdList["INNERFIREWATCH"] = function(msg)
  msg = msg and string.lower(msg) or ""

  if msg == "help" then
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffInnerFireWatch Help|r")
    DEFAULT_CHAT_FRAME:AddMessage("  /ifw - Open options window")
    DEFAULT_CHAT_FRAME:AddMessage("  /ifw help - Show this message")
  else
    ToggleOptionsWindow()
  end
end
