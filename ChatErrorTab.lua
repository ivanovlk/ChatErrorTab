local ERROR_CHAT_TAB_NAME = "Lua Errors"

local ChatErrorTab --Error Frame

local function Create(frame)
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
        if name ~= nil then
            -- check if ChatFrame is named "Chat x" (where x is a number)
            if string.find(name, "^Chat %d+$") then
                free = chatFrame
            end
            if ERROR_CHAT_TAB_NAME == name then
                found = true
                free = chatFrame
                break
            end
        end
    end

    if not found and free then 
        Create(free)
        ChatErrorTab = free
    end

    if ChatErrorTab then
        ChatErrorTab:SetMaxLines(1000)
        ChatErrorTab:Show()
    end

    this:UnregisterEvent("ADDON_LOADED")
end

local ErrorLogger = CreateFrame("Frame")
ErrorLogger:RegisterEvent("ADDON_LOADED")
ErrorLogger:SetScript("OnEvent", OnEvent)

-- Hook the default error handler
local originalErrorHandler = geterrorhandler()
seterrorhandler(function(errMsg)
    if ChatErrorTab then
        ChatErrorTab:AddMessage("|cffff0000Lua Error: " .. errMsg.."|r")
    end
    originalErrorHandler(errMsg)
end)