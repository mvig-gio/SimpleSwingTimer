--[[
    SimpleSwingTimer - Simple swing timer bar for WoW 3.3.5a (WotLK)
    Shows a single swing timer bar for melee attacks
]]

local addonName, addon = ...
local frame = CreateFrame("Frame", "SimpleSwingTimerFrame", UIParent)
local swingBar, swingText
local swingStart, swingDuration
local isLocked = true

-- Default settings
local settings = {
    x = 300,
    y = 300,
    width = 200,
    height = 20,
    barColor = {1, 1, 0}, -- Yellow
    alpha = 0.8
}

-- Create the main frame
frame:SetFrameStrata("HIGH")
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:SetSize(settings.width, settings.height)
frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", settings.x, settings.y)

-- Create swing bar
swingBar = CreateFrame("StatusBar", nil, frame)
swingBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
swingBar:SetSize(settings.width, settings.height)
swingBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
swingBar:SetStatusBarColor(unpack(settings.barColor))
swingBar:SetMinMaxValues(0, 1)

-- Create text label
swingText = swingBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
swingText:SetPoint("CENTER", swingBar, "CENTER")
swingText:SetText("Swing Timer")

-- Set frame properties
frame:SetAlpha(settings.alpha)
frame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    tile = true,
    tileSize = 16
})
frame:SetBackdropColor(0, 0, 0, 0.5)

-- Hide bar initially
swingBar:Hide()

-- Update function
local function OnUpdate()
    local currentTime = GetTime()
    
    if swingStart and swingDuration then
        local elapsed = currentTime - swingStart
        local remaining = swingDuration - elapsed
        
        if remaining <= 0 then
            swingBar:Hide()
            frame:Hide()
            swingStart = nil
            swingDuration = nil
            frame:SetScript("OnUpdate", nil)
        else
            local progress = elapsed / swingDuration
            swingBar:SetValue(progress)
            swingText:SetFormattedText("%.1fs", remaining)
        end
    end
end

-- Event handling
local function OnEvent(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, combatEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName = ...
        
        -- Check if it's our swing
        if sourceGUID == UnitGUID("player") then
            if combatEvent == "SWING_DAMAGE" or combatEvent == "SWING_MISSED" then
                -- Start swing timer
                swingStart = GetTime()
                swingDuration = UnitAttackSpeed("player")
                swingBar:Show()
                frame:Show()
                frame:SetScript("OnUpdate", OnUpdate)
            end
        end
    elseif event == "PLAYER_ENTER_COMBAT" then
        -- Don't reset timer when entering combat - just let it continue
        -- This prevents the bar from disappearing when changing targets
    elseif event == "PLAYER_LEAVE_COMBAT" then
        -- Only hide bar when actually leaving combat
        if swingStart and swingDuration then
            local currentTime = GetTime()
            local elapsed = currentTime - swingStart
            -- Only hide if the swing timer has actually finished
            if elapsed >= swingDuration then
                frame:Hide()
                frame:SetScript("OnUpdate", nil)
                swingStart = nil
                swingDuration = nil
            end
        else
            frame:Hide()
            frame:SetScript("OnUpdate", nil)
        end
    end
end

-- Register events
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_ENTER_COMBAT")
frame:RegisterEvent("PLAYER_LEAVE_COMBAT")

-- Set event handler
frame:SetScript("OnEvent", OnEvent)

-- Drag functionality
local function OnDragStart()
    if not isLocked then
        frame:StartMoving()
    end
end

local function OnDragStop()
    if not isLocked then
        frame:StopMovingOrSizing()
        -- Save position
        local point, _, _, x, y = frame:GetPoint()
        settings.x = x
        settings.y = y
    end
end

frame:SetScript("OnDragStart", OnDragStart)
frame:SetScript("OnDragStop", OnDragStop)

-- Slash commands
SLASH_SIMPLESWINGTIMER1 = "/sst"
SLASH_SIMPLESWINGTIMER2 = "/simpleswingtimer"

SlashCmdList["SIMPLESWINGTIMER"] = function(msg)
    msg = msg:lower()
    
    if msg == "lock" then
        isLocked = true
        frame:EnableMouse(false)
        -- Hide test bar if it was shown for positioning
        if swingStart and swingDuration and swingDuration == 10 then
            swingBar:Hide()
            frame:Hide()
            frame:SetScript("OnUpdate", nil)
            swingStart = nil
            swingDuration = nil
        end
        print("SimpleSwingTimer: Locked")
    elseif msg == "unlock" then
        isLocked = false
        frame:EnableMouse(true)
        -- Show a test bar so user can see and move it
        swingStart = GetTime()
        swingDuration = 10 -- 10 second test bar
        swingBar:Show()
        frame:Show()
        frame:SetScript("OnUpdate", OnUpdate)
        print("SimpleSwingTimer: Unlocked - Test bar showing for 10 seconds")
    elseif msg == "reset" then
        frame:ClearAllPoints()
        frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", settings.x, settings.y)
        print("SimpleSwingTimer: Position reset")
    elseif msg == "test" then
        -- Test mode - show bar for 5 seconds
        swingStart = GetTime()
        swingDuration = 5
        swingBar:Show()
        frame:Show()
        frame:SetScript("OnUpdate", OnUpdate)
        print("SimpleSwingTimer: Test mode - bar will show for 5 seconds")
    elseif msg == "status" then
        local status = isLocked and "Locked" or "Unlocked"
        local barStatus = swingStart and "Active" or "Inactive"
        local position = string.format("X: %.0f, Y: %.0f", settings.x, settings.y)
        print("SimpleSwingTimer Status:")
        print("- Bar: " .. barStatus)
        print("- Position: " .. status)
        print("- Coordinates: " .. position)
    else
        print("SimpleSwingTimer commands:")
        print("/sst lock - Lock the bar")
        print("/sst unlock - Unlock the bar for moving")
        print("/sst reset - Reset bar position")
        print("/sst test - Test the bar")
        print("/sst status - Show current status")
    end
end

-- Initialize
frame:EnableMouse(false) -- Start locked

-- Version check
local version = "1.1"
print("SimpleSwingTimer v" .. version .. " loaded. Use /sst for commands.")
