-- InnerFireWatch (Turtle WoW / 1.12.1)
-- Alerts when "Inner Fire" buff falls off.

InnerFireWatchDB = InnerFireWatchDB or {}

local f = CreateFrame("Frame")
local wasActive = false

local DEFAULTS = {
  enabled = true,
  soundEnabled = true,
  gainedMessage = false,
  largeMessageEnabled = true,
  useCustomSound = true,
  customSoundPath = "Interface\\AddOns\\InnerFireWatch\\sounds\\expire.wav",
  fallbackSound = "igQuestFailed",
}

-- Big center-screen text (independent of UIErrorsFrame)
local CenterAlert = CreateFrame("Frame", "InnerFireWatchCenterAlert", UIParent)
CenterAlert:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
CenterAlert:SetWidth(600)
CenterAlert:SetHeight(80)
CenterAlert:Hide()

CenterAlert.text = CenterAlert:CreateFontString(nil, "OVERLAY")
CenterAlert.text:SetAllPoints(CenterAlert)
CenterAlert.text:SetFont("Fonts\\FRIZQT__.TTF", 32, "OUTLINE")
CenterAlert.text:SetJustifyH("CENTER")
CenterAlert.text:SetJustifyV("MIDDLE")

local function ShowCenterAlert(msg, r, g, b)
  CenterAlert.text:SetText(msg or "")
  CenterAlert.text:SetTextColor(r or 1, g or 0.1, b or 0.1)
  CenterAlert:Show()
  CenterAlert.startTime = GetTime()
end

-- Fade out over ~1.6s
CenterAlert:SetScript("OnUpdate", function()
  if not CenterAlert:IsShown() then return end
  local t = GetTime() - (CenterAlert.startTime or 0)
  if t >= 1.6 then
    CenterAlert:Hide()
    return
  end
  -- 0.0 -> 1.6
  local alpha = 1 - (t / 1.6)
  CenterAlert:SetAlpha(alpha)
end)

local function ApplyDefaults()
  for k, v in pairs(DEFAULTS) do
    if InnerFireWatchDB[k] == nil then
      InnerFireWatchDB[k] = v
    end
  end
end

local function HasInnerFire()
  local i = 1
  while true do
    local texture = UnitBuff("player", i)
    if not texture then break end

    texture = string.lower(texture)
    if string.find(texture, "spell_holy_innerfire") then
      return true
    end

    i = i + 1
  end
  return false
end

local function PlayExpireSound()
  if not InnerFireWatchDB.soundEnabled then return end

  if InnerFireWatchDB.useCustomSound and PlaySoundFile then
    PlaySoundFile(InnerFireWatchDB.customSoundPath)
    return
  end

  if PlaySound then
    PlaySound(InnerFireWatchDB.fallbackSound)
  end
end

local function NotifyExpired()
  DEFAULT_CHAT_FRAME:AddMessage("|cffff3333Inner Fire has expired!|r")
  if InnerFireWatchDB.largeMessageEnabled then
    ShowCenterAlert("INNER FIRE EXPIRED!")
  end


  if UIErrorsFrame and UIErrorsFrame.AddMessage then
    UIErrorsFrame:AddMessage("Inner Fire expired!", 1.0, 0.1, 0.1, 1.0, 5)
  end

  PlayExpireSound()
end

local function NotifyGained()
  if not InnerFireWatchDB.gainedMessage then return end
  DEFAULT_CHAT_FRAME:AddMessage("|cff33ff33Inner Fire active.|r")
end

local function Check()
  if not InnerFireWatchDB.enabled then return end

  local active = HasInnerFire()

  if wasActive and not active then
    NotifyExpired()
  elseif (not wasActive) and active then
    NotifyGained()
  end

  wasActive = active
end

f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_AURAS_CHANGED")

f:SetScript("OnEvent", function()
  Check()
end)

f:SetScript("OnUpdate", function()
  f:SetScript("OnUpdate", nil)
  ApplyDefaults()
  wasActive = HasInnerFire()
end)

SLASH_INNERFIREWATCH1 = "/ifw"
SlashCmdList["INNERFIREWATCH"] = function(msg)
  msg = msg and string.lower(msg) or ""

  if msg == "on" then
    InnerFireWatchDB.enabled = true
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: enabled")
  elseif msg == "off" then
    InnerFireWatchDB.enabled = false
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: disabled")

  elseif msg == "sound on" then
    InnerFireWatchDB.soundEnabled = true
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: sound enabled")
  elseif msg == "sound off" then
    InnerFireWatchDB.soundEnabled = false
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: sound disabled")

  elseif msg == "custom on" then
    InnerFireWatchDB.useCustomSound = true
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: custom sound enabled")
  elseif msg == "custom off" then
    InnerFireWatchDB.useCustomSound = false
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: custom sound disabled")

  elseif msg == "gained on" then
    InnerFireWatchDB.gainedMessage = true
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: gained message enabled")
  elseif msg == "gained off" then
    InnerFireWatchDB.gainedMessage = false
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: gained message disabled")

  elseif msg == "large on" then
    InnerFireWatchDB.largeMessageEnabled = true
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: large message enabled")
  elseif msg == "large off" then
    InnerFireWatchDB.largeMessageEnabled = false
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch: large message disabled")

  else
    DEFAULT_CHAT_FRAME:AddMessage("InnerFireWatch commands:")
    DEFAULT_CHAT_FRAME:AddMessage("  /ifw on|off")
    DEFAULT_CHAT_FRAME:AddMessage("  /ifw sound on|sound off")
    DEFAULT_CHAT_FRAME:AddMessage("  /ifw custom on|custom off")
    DEFAULT_CHAT_FRAME:AddMessage("  /ifw gained on|gained off")
    DEFAULT_CHAT_FRAME:AddMessage("  /ifw large on|large off")
  end
end
