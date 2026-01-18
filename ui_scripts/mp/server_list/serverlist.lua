local Lobby = luiglobals.Lobby
local SystemLinkJoinMenu = LUI.mp_menus.SystemLinkJoinMenu

if (not SystemLinkJoinMenu) then
    return
end

local function menu_systemlink_join(f19_arg0, f19_arg1)
    local width = 1145
    -- Text in top left???
    local menu = LUI.MenuTemplate.new(f19_arg0, {
        menu_title = "@MENU_SERVER_BROWSER_CAPS",
        menu_width = width,
        menu_top_indent = 20,
        disableDeco = true,
        spacing = 1,
        do_not_add_friends_helper = true
    })

    -- Event listeners

    LUI.ButtonHelperText.ClearHelperTextObjects(menu.help, {
        side = "all"
    })

    menu:registerEventHandler("go_back", function()
        LUI.FlowManager.RequestLeaveMenu(menu)
    end)

    imgui:openServerBrowser()
    
    -- Remove this again once the rest is fixed
    menu:AddBackButton()
    return menu
end

LUI.MenuBuilder.m_types_build["menu_systemlink_join"] = menu_systemlink_join
