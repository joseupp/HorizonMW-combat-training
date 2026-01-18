--modified by CnR
require('layouts.maps')
require('layouts.players')

local options = luiglobals.require("LUI.mp_hud.OptionsMenu")
local class_select = luiglobals.require("LUI.mp_hud.CharSelectMenu")

local end_game_cb = function(f4_arg0, f4_arg1)
    local f4_local0 = Engine.GetOnlineGame()
    if f4_local0 then
        f4_local0 = not Engine.GetDvarBool("xblive_privatematch")
    end
    local f4_local1 = Engine.GetDvarBool("sv_running")
    if f4_local0 then
        LUI.FlowManager.RequestAddMenu(f4_arg0, "popup_leave_game", true, f4_arg1.controller)
    else
        LUI.FlowManager.RequestAddMenu(f4_arg0, "popup_end_game", true, f4_arg1.controller)
    end
end

local function LeaveMapVoteMenu(f6_arg0, f6_arg1)
    f6_arg0:dispatchEventToRoot({
        name = "toggle_pause_off"
    })
    LUI.FlowManager.RequestAddMenu(f6_arg0, "map_vote_pause_menu", false, f6_arg1.controller)
    Engine.PlaySound(CoD.SFX.PauseMenuResume)
end

local function ReturnToMapVote(f6_arg0, f6_arg1)
    f6_arg0:dispatchEventToRoot({
        name = "toggle_pause_off"
    })
    LUI.FlowManager.RequestLeaveMenu(f6_arg0)
    Engine.PlaySound(CoD.SFX.PauseMenuResume)
end

local function menu_mapvote(f4_arg0, f4_arg1)
    local menu = LUI.MenuTemplate.new(f4_arg0, {
        menu_top_indent = 0,
        menu_title = 'Map Vote',
        disableBack = false
    })

    local timer = LUI.UITimer.new(100, 'update')
    menu:addElement(timer)

    menu:addEventHandler('update', function()
        LUI.MenuTemplate.SetBreadCrumb(menu, 'Time Left: ' .. Engine.GetDvarInt('mapvote_timeleft'))
    end)

    local mapList = CreateMapList()
    menu:addElement(mapList)
    menu:addElement(CreatePlayerList())

    local buttonHandler = LUI.UIBindButton.new()
    buttonHandler.id = "mapVoteButtonBinds"
    buttonHandler:registerEventHandler("button_start", LeaveMapVoteMenu)
    menu:addElement(buttonHandler)

    menu:AddBackButton(LeaveMapVoteMenu)

    menu:registerEventHandler("gain_focus", function()
        menu:processEvent({name = "update"})
    end)

    menu:registerEventHandler("menu_create", function()
        local firstButton = mapList:getFirstChild()
        if firstButton then
            firstButton:processEvent({name = "gain_focus"})
        end
    end)

    return menu
end

-- custom pause menu for map vote
local function map_vote_pause_menu(f7_arg0, f7_arg1)
    local ui_options_menu_sum = false
    if GameX.IsRankedMatch() then
        ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") > 0
    else
        local spectate_allowed = GetPrivateMatchSpectateAllowedLevel()
        if spectate_allowed == 0 then
            ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") > 0
        elseif spectate_allowed == 1 and not GameX.gameModeIsFFA() then
            ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") == 1
        end
    end

    local is_splitscreen = GameX.IsSplitscreen()
    local pause_menu = LUI.inGameBase.new(f7_arg0, {
        menu_title = "@LUA_MENU_PAUSE_CAPS",
        disableBack = false
    })

    local temp_button_var = pause_menu:AddButton("@LUA_MENU_CLASS_EDITOR", function(arg0, arg1)
        LUI.FlowManager.RequestAddMenu(arg0, "h2m_class_editor", true, arg1.controller)
    end, function()
        return true
    end)
    temp_button_var:rename(f7_arg0.type .. "_class_editor")

    if options.CanShowChangeTeamMenuOption() and not Game.GetOmnvar("ui_disable_team_change") then
        local temp_button_var = pause_menu:AddButton("@LUA_MENU_CHANGE_TEAM", options.OnChangeTeam)
        temp_button_var:rename(f7_arg0.type .. "_change_team")
    end

    local f7_local5 = pause_menu:AddOptionsButton(true)
    if is_splitscreen then
        f7_local5.disabledFunc = GameX.IsOptionStateLocked
        f7_local5:setDisabledRefreshRate(100)
    end

    pause_menu:AddButton("@LUA_MENU_MUTE_PLAYERS", function(f3_arg0, f3_arg1)
        LUI.FlowManager.RequestAddMenu(f3_arg0, "MutePlayers", true, f3_arg1.controller)
    end)

    local self = LUI.UIBindButton.new()
    self.id = "inGameButtonBinds"
    self:registerEventHandler("button_start", ReturnToMapVote)
    self:registerEventHandler("button_select", ReturnToMapVote)
    pause_menu:addElement(self)
    pause_menu:AddBackButton(ReturnToMapVote)

    local self = pause_menu:AddButton("@LUA_MENU_END_GAME", end_game_cb)
    self:clearActionSFX()

    return pause_menu
end

LUI.MenuBuilder.m_types_build["mp_pause_menu"] = function(f7_arg0, f7_arg1)
    local ui_options_menu_sum = false
    if GameX.IsRankedMatch() then
        ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") > 0
    else
        local spectate_allowed = GetPrivateMatchSpectateAllowedLevel()
        if spectate_allowed == 0 then
            ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") > 0
        elseif spectate_allowed == 1 and not GameX.gameModeIsFFA() then
            ui_options_menu_sum = Game.GetOmnvar("ui_options_menu") == 1
        end
    end

    local is_splitscreen = GameX.IsSplitscreen()
    local pause_menu = LUI.inGameBase.new(f7_arg0, {
        menu_title = "@LUA_MENU_PAUSE_CAPS",
        disableBack = false
    })

    if options.CanChooseClass() then
        local temp_button_var = pause_menu:AddButton("@LUA_MENU_CHOOSE_CLASS", options.OnChooseClass)
        temp_button_var:rename(f7_arg0.type .. "_choose_class")

        temp_button_var = pause_menu:AddButton("@LUA_MENU_CLASS_EDITOR", function(arg0, arg1)
            LUI.FlowManager.RequestAddMenu(arg0, "h2m_class_editor", true, arg1.controller)
        end, function()
            return true
        end)
        temp_button_var:rename(f7_arg0.type .. "_class_editor")
    end

    if options.CanShowChangeTeamMenuOption() and not Game.GetOmnvar("ui_disable_team_change") then
        local temp_button_var = pause_menu:AddButton("@LUA_MENU_CHANGE_TEAM", options.OnChangeTeam)
        temp_button_var:rename(f7_arg0.type .. "_change_team")
    end

    local f7_local5 = pause_menu:AddOptionsButton(true)
    if is_splitscreen then
        f7_local5.disabledFunc = GameX.IsOptionStateLocked
        f7_local5:setDisabledRefreshRate(100)
    end

    pause_menu:AddButton("@LUA_MENU_MUTE_PLAYERS", function(f3_arg0, f3_arg1)
        LUI.FlowManager.RequestAddMenu(f3_arg0, "MutePlayers", true, f3_arg1.controller)
    end)

    local self = LUI.UIBindButton.new()
    self.id = "inGameButtonBinds"
    self:registerEventHandler("button_start", leave_this_menu)
    self:registerEventHandler("button_select", leave_this_menu)
    pause_menu:addElement(self)
    pause_menu:AddBackButton(leave_this_menu)

    local self = pause_menu:AddButton("@LUA_MENU_END_GAME", end_game_cb)
    self:clearActionSFX()

    return pause_menu
end

LUI.MenuBuilder.m_types_build['menu_mapvote'] = menu_mapvote
LUI.MenuBuilder.m_types_build['map_vote_pause_menu'] = map_vote_pause_menu