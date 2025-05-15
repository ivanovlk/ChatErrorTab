local ERROR_CHAT_TAB_NAME = "Lua Errors"

local frame

local function Create(frame)
    frame:Show()
    FCF_DockFrame(frame)
    FCF_SetWindowName(frame, ERROR_CHAT_TAB_NAME)
    FCF_SelectDockFrame(ChatFrame1)

    ChatFrame_RemoveAllMessageGroups(frame)
    ChatFrame_RemoveAllChannels(frame)
end

local function OnEvent()
    -- Create a new chat tab if it doesn't exist
    local found
    local free

    for i = NUM_CHAT_WINDOWS, 1, -1 do
        local chatFrame = getglobal("ChatFrame"..i)
        local tab = getglobal("ChatFrame"..i.."Tab")
        local name = tab:GetText()
        -- check if ChatFrame is named "Chat x" (where x is a number)
        if string.find(name, "^Chat %d+$") then
            free = chatFrame
        end
        if ERROR_CHAT_TAB_NAME == name then
            found = true
            frame = chatFrame
            break
        end
    end

    if not found and free then
        Create(free)
        frame = free
    end

    if frame then
        frame:SetMaxLines(1000)
    end

    this:UnregisterEvent("ADDON_LOADED")
end

local ErrorLogger = CreateFrame("Frame")
ErrorLogger:RegisterEvent("ADDON_LOADED")
ErrorLogger:SetScript("OnEvent", OnEvent)

-- Hook the default error handler
local originalErrorHandler = geterrorhandler()
seterrorhandler(function(errMsg)
    if frame then
        frame:AddMessage("|cffff0000Lua Error: " .. errMsg.."|r")
    end
    originalErrorHandler(errMsg)
end)