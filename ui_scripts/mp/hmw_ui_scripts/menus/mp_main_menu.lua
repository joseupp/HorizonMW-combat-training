function OnSystemLinkNetwork(buttonContainer, buttonEvent)
    buttonContainer:processEvent({
        name = "button_action",
        controller = buttonEvent.controller,
        noRefocus = true
    })
end

function ProcessGavelMessages(buttonContainer, buttonEvent)
    buttonContainer:processEvent({
        name = "button_action",
        controller = buttonEvent.controller,
        noRefocus = true
    })
end

function OnOnlineDataFetched(buttonContainer, buttonEvent)
    local useOnlineStats = Engine.GetDvarBool("useonlinestats")
    Engine.SetDvarBool("useonlinestats", true)
    CheckGavelMessages(buttonEvent.controller)
    Engine.SetDvarBool("useonlinestats", useOnlineStats)
    buttonContainer:processEvent({
        name = "button_action",
        controller = buttonEvent.controller,
        noRefocus = true
    })
end

function ClearWaitingForOtherType(networkType)
    if GetWaitingForNetworkType() ~= networkType then
        SetWaitingForNetworkType(WaitingForNetworkType.None)
    end
end

function ResolveSignInRefusal(controller)
    if not Engine.IsProfileSignedIn(controller) then
        LUI.FlowManager.RequestAddMenu(nil, "no_profile_force_popmenu", false, controller, false, {})
    end
end

function OnplayButton(menu, event)
    ClearWaitingForOtherType(WaitingForNetworkType.Online)
    Engine.ExecNow("forcenosplitscreencontrol main_XBOXLIVE_1", event.controller)
    if DCache.IsStartupDisabled() then
        LUI.FlowManager.RequestAddMenu(nil, "generic_yesno_popup", true, event.controller, nil, {
            popup_title = Engine.Localize("@MENU_NOTICE"),
            yes_action = function()
                DCache.ClearDCache(1)
                Engine.SystemRestart(Engine.Localize("@LUA_MENU_DCACHE_RESTART"))
            end,
            no_action = function()
                DCache.ClearStartupCount()
                Engine.SystemRestart(Engine.Localize("@LUA_MENU_DCACHE_RESTART"))
            end,
            message_text = Engine.Localize("@LUA_MENU_DCACHE_CLEAR_REQUEST"),
            yes_text = Engine.Localize("@LUA_MENU_YES"),
            no_text = Engine.Localize("@LUA_MENU_NO")
        })
        return
    end
    local canAccessMPMenu, failureCode = Engine.UserCanAccessMPLiveMenu(event.controller)
    if not canAccessMPMenu then
        if Engine.IsXB3() and failureCode == CoD.PlayOnlineFailure.OPFR_XBOXLIVE_MPNOTALLOWED then
            canAccessMPMenu = Engine.ShowXB3GoldUpsell(event.controller)
        elseif Engine.IsPCApp() and failureCode == CoD.PlayOnlineFailure.OPFR_PLATFORM_UPDATE_REQUIRED then
            LUI.FlowManager.RequestAddMenu(menu, "uwp_update_required", true, event.controller)
            return
        end
    end
    if not canAccessMPMenu then
        if Engine.IsPS4() and failureCode == CoD.PlayOnlineFailure.OPFR_XBOXLIVE_SIGNEDOUTOFLIVE then
            Engine.ExecWithResolve("xrequirelivesignin", ResolveSignInRefusal, event.controller)
        elseif Engine.IsPS4() and failureCode == CoD.PlayOnlineFailure.OPFR_XBOXLIVE_MPNOTALLOWED then
            Engine.ExecWithResolve("xrequirelivesignin", ResolveSignInRefusal, event.controller)
        else
            Engine.Exec("xrequirelivesignin", event.controller)
            if WaitingForNetworkType.Online ~= GetWaitingForNetworkType() and failureCode ~= CoD.PlayOnlineFailure.OPFR_PLATFORM_PSPLUS_REQUIRED then
                SetWaitingForNetworkType(WaitingForNetworkType.Online, event.controller)
            end
        end
    elseif not Engine.HasAcceptedEULA(event.controller) then
        LUI.FlowManager.RequestAddMenu(nil, "EULA", true, event.controller, false, {
            callback = function()
                OnplayButton(menu, event)
            end
        })
    elseif CheckCRMBanMessage(menu, event.controller) then
        return
    elseif Lobby.GavelMessagesToShow ~= nil and #Lobby.GavelMessagesToShow > 0 then
        menu:processEvent({
            name = "lose_focus"
        })
        ShowGavelMessage(menu)
    else
        if Engine.UsingStreamingInstall() then
            Engine.ForceUpdateArenas()
        end
        Engine.ExecNow("resetSplitscreenSignIn", event.controller)
        Engine.ExecNow("forcenosplitscreencontrol main_XBOXLIVE_3", event.controller)
        Engine.SetOnlineGame(true)
        Engine.SetSystemLink(false)
        Engine.SetSplitScreen(false)
        Engine.SetDvarBool("xblive_privatematch", false)
        AAR.ClearAAR()
        Engine.SetDvarBool("squad_match", false)
        Engine.ExecNow(MPConfig.default_xboxlive, event.controller)
        Engine.SetDvarInt("party_maxplayers", Engine.IsAliensMode() and 4 or 9)
        Engine.ExecNow("xstartprivateparty", event.controller)
        Engine.Exec("startentitlements", event.controller)
        Engine.ExecNow("upload_playercard", event.controller)
        Cac.SetSelectedControllerIndex(event.controller)
        Engine.CacheUserDataForController(event.controller)
        LUI.FlowManager.RequestAddMenu(menu, "menu_xboxlive", false, event.controller, false, {
            initialController = event.controller
        })
    end
end

function OnSplitscreenButton(menu, event)
    if DCache.IsStartupDisabled() then
        LUI.FlowManager.RequestAddMenu(nil, "generic_yesno_popup", true, controller, nil, {
            popup_title = Engine.Localize("@MENU_NOTICE"),
            yes_action = function()
                DCache.ClearDCache(1)
                Engine.SystemRestart(Engine.Localize("@LUA_MENU_DCACHE_RESTART"))
            end,
            no_action = function()
                DCache.ClearStartupCount()
                Engine.SystemRestart(Engine.Localize("@LUA_MENU_DCACHE_RESTART"))
            end,
            message_text = Engine.Localize("@LUA_MENU_DCACHE_CLEAR_REQUEST"),
            yes_text = Engine.Localize("@LUA_MENU_YES"),
            no_text = Engine.Localize("@LUA_MENU_NO")
        })
        return
    end
    SetWaitingForNetworkType(WaitingForNetworkType.None)
    Engine.Exec("xstopprivateparty")
    Engine.Exec("resetSplitscreenSignIn")
    Engine.Exec("forcesplitscreencontrol main_SPLITSCREEN")
    Engine.SetSystemLink(false)
    Engine.SetSplitScreen(true)
    Engine.SetOnlineGame(false)
    Engine.SetDvarBool("xblive_privatematch", false)
    AAR.ClearAAR()
    Engine.Exec(MPConfig.default_splitscreen)
    Engine.CacheUserDataForController(event.controller)
    if Engine.GetDvarBool("lui_splitscreensignin_menu") then
        LUI.FlowManager.RequestAddMenu(menu, "menu_splitscreensignin", false, event.controller, false)
    else
        assert(not Engine.IsAliensMode(), "Splitscreen sign in UI not supported by .menu.")
        LUI.FlowManager.RequestOldMenu(menu, "menu_splitscreensignin", false)
    end
end

function OnReturnToMainMenu(menu, event)
    LUI.FlowManager.RequestPopupMenu(menu, "main_choose_exe_popup_menu", true, event.controller)
    Engine.Exec("forcenosplitscreencontrol openChooseExe " .. tostring(event.controller))
end

function OnSystemLinkButton(menu, event)
    ClearWaitingForOtherType(WaitingForNetworkType.SystemLink)
    local canAccessSystemLink, failureCode = Engine.UserCanAccessSystemLinkMenu(event.controller)
    if not canAccessSystemLink then
        SetWaitingForNetworkType(WaitingForNetworkType.SystemLink, event.controller)
        LUI.FlowManager.RequestAddMenu(menu, "popup_connecting", false, event.controller, false)
        Engine.Exec("xrequiresignin", event.controller)
        Engine.Exec("forcesplitscreencontrol main_SYSTEMLINK_2", event.controller)
    elseif not Engine.HasAcceptedEULA(event.controller) then
        LUI.FlowManager.RequestAddMenu(nil, "EULA", true, event.controller, false, {
            callback = function()
                OnSystemLinkButton(menu, event)
            end
        })
    else
        if Engine.UsingStreamingInstall() then
            Engine.ForceUpdateArenas()
        end
        LUI.FlowManager.RequestLeaveMenuByName("popup_connecting", nil)
        Engine.ExecNow("resetSplitscreenSignIn", event.controller)
        Engine.Exec("forcenosplitscreencontrol main_SYSTEMLINK_3", event.controller)
        Engine.SetSystemLink(true)
        Engine.SetSplitScreen(false)
        Engine.Exec("clearcontrollermap")
        Engine.SetOnlineGame(false)
        AAR.ClearAAR()
        if Lobby.UsingSystemLinkParty() then
            Engine.SetDvarBool("xblive_privatematch", false)
        else
            Engine.SetDvarBool("xblive_privatematch", false)
        end
        Engine.SetDvarBool("ui_opensummary", false)
        Engine.Exec(MPConfig.default_systemlink, event.controller)
        Engine.MakeLocalClientActive(event.controller)
        Engine.CacheUserDataForController(event.controller)
        Cac.SetSelectedControllerIndex(event.controller)
        if Engine.GetDvarBool("lui_systemlink_menu") then
            LUI.FlowManager.RequestAddMenu(menu, "menu_systemlink", false, event.controller, false)

        else
            assert(not Engine.IsAliensMode(), "SystemLink UI not supported by .menu.")
            LUI.FlowManager.RequestOldMenu(menu, "menu_systemlink", false)
        end
    end
end

function AddStreamingInstallWidget(menu)
    if IsStreamingInstall() then
        local streamingInstallWidget = LUI.StreamingInstallWidget.new()
        menu:addElement(streamingInstallWidget)
        menu.streamingInstall = streamingInstallWidget
    end
end

function ResolveCRPClickThroughAction(controller)
    local canAccessMPMenu, failureCode = Engine.UserCanAccessMPLiveMenu(controller)
    if not canAccessMPMenu and failureCode ~= CoD.PlayOnlineFailure.OPFR_PLATFORM_PSPLUS_REQUIRED then
        SetWaitingForNetworkType(WaitingForNetworkType.Online, controller)
        Engine.ExecNow("forcenosplitscreencontrol main_XBOXLIVE_1", controller)
        Engine.ExecWithResolve("xrequirelivesignin", ResolveCRPClickThroughAction, controller)
    else
        local menuData = LUI.FlowManager.GetMenuScopedDataByMenuName("mp_main_menu")
        OnplayButton(menuData.crpButton, {
            name = "button_action",
            controller = controller
        })
    end
end

function CRPClickThroughAction(menu, event)
    if not IsStreamingInstall() then
        local menuData = LUI.FlowManager.GetMenuScopedDataByMenuName("mp_main_menu")
        ResolveCRPClickThroughAction(menuData.crpController)
    end
end

local function CreateLogoImage(imageContainer)
    local imageProps = CoD.CreateState(nil, nil, 100, 250, CoD.AnchorTypes.TopRight)
    imageProps.material = RegisterMaterial("h2m_mod_logo")
    imageProps.width = 416
    imageProps.height = 234
    --imageContainer:addElement(LUI.UIImage.new(imageProps))
end

LUI.MenuTemplate.AddBuildNumber = function ( f2_arg0 )
	local self = LUI.UIText.new( {
		leftAnchor = true,
		topAnchor = true,
		rightAnchor = false,
		bottomAnchor = false,
        top = 15,
		height = CoD.TextSettings.BodyFontTiny.Height,
		font = CoD.TextSettings.BodyFontTiny.Font,
		width = GenericMenuDims.menu_right_wide - GenericMenuDims.menu_left,
        alpha = 0.2
	} )
	self:setText( Engine.GetBuildNumber() )
	self:addElement( LUI.UITimer.new( 500, "refresh_buildnumber" ) )
	self:registerEventHandler( "refresh_buildnumber", function ( element, event )
		element:setText( Engine.GetBuildNumber() )
	end )
	f2_arg0:addElement( self )
end

function MainMenu(menu, event)
    -- PersistentBackground.FadeFromBlackSlow()
    -- ok this is the worst thing ever but it works
    if (Engine.GetDvarBool("startup_video_played") ~= true) then
	    LUI.FlowManager.RequestAddMenu( nil, "main_attract" )
    end

    local mainMenuTitle = "@MENU_MULTIPLAYER_CAPS"
    local mainMenuBreadcrumb = ""
    local mainMenuUppercaseTitle = nil
    Engine.SetDvarBool("party_playersCoop", false)
    menu = LUI.MenuTemplate.new(menu, {
        menu_top_indent = 0,
        menu_title = mainMenuTitle,
        uppercase_title = mainMenuUppercaseTitle
    })

    menu:AddBuildNumber()

    LUI.MenuTemplate.SetBreadCrumb(menu, mainMenuBreadcrumb)

    local playButton = menu:AddButton("@PLATFORM_PLAY_ONLINE", OnplayButton, IsStreamingInstall)
    playButton:setDisabledRefreshRate(1000)
    playButton:rename("mp_main_menu_play_online2")
    playButton:registerEventHandler("onOnlineDataFetched", OnOnlineDataFetched)
    playButton:registerEventHandler("gavelMessagesProcessed", ProcessGavelMessages)

    --local systemLinkButton = menu:AddButton("@PLATFORM_SYSTEM_LINK", OnSystemLinkButton)
    --systemLinkButton:rename("MainMenu_SystemLink")
    --systemLinkButton:registerEventHandler("onSystemLinkNetwork", OnSystemLinkNetwork)

    menu:AddButton("@MENU_OPTIONS", function ()
        LUI.FlowManager.RequestAddMenu(nil, "pc_controls", true, event.controller, false)
    end)
    menu:AddButton("@MENU_QUIT", OnReturnToMainMenu)
    
    PersistentBackground.ChangeBackground(nil, "h2_sp_menus_bg_start_screen")
    if Engine.IsCoreMode() then
        for controller = 0, Engine.GetMaxControllerCount() - 1 do
            if Engine.HasActiveLocalClient(controller) and Engine.GetProfileData("mp_StartCRPLobby", controller) then
                Engine.Exec("profile_ClearStartCRPLobby", controller)
                Engine.Exec("updategamerprofile")
                playButton.listDefaultFocus = true
                local menuData = LUI.FlowManager.GetMenuScopedDataByMenuName("mp_main_menu")
                menuData.crpButton = playButton
                menuData.crpController = controller
                playButton:registerEventHandler("StartCRPLobby", CRPClickThroughAction)
                playButton:dispatchEventToRoot({
                    name = "StartCRPLobby",
                    target = playButton
                })
                break
            end
        end
    end

    menu:AddOptionsButton(false, true)
    if Engine.IsXB3() or Engine.IsPCApp() then
        LUI.ButtonHelperText.AddSignInAndSwitchUserHelp(menu)
    end

    CreateLogoImage(menu)
    menu:AddBackButton(OnReturnToMainMenu)
    AddStreamingInstallWidget(menu)
    Engine.ExecNow("set xblive_competitionmatch 0")
    Lobby.ClearLocalPlayLoadouts()
    menu:registerEventHandler("refresh_button_helper", refreshHelpButtons)
    IsInitialMenuView = false
    if Engine.IsPC() then
        if not Engine.GetDisplayDriverMeetsMinVer() then
            LUI.FlowManager.RequestAddMenu(self, "PCDriverDialog")
        elseif Engine.ShaderUploadFrontendShouldShowDialog() then
            LUI.FlowManager.RequestAddMenu(self, "ShaderCacheDialog")
        end
    end

    return menu
end

LUI.MenuBuilder.m_types_build["mp_main_menu"] = MainMenu

LUI.MPLobbyMap.Refresh = function ( f2_arg0, f2_arg1 )
	f2_arg0.title:setText( Lobby.GetMapName() )
	if not f2_arg0.isVote then
		f2_arg0:SetMapImage( Lobby.GetMapImage() )
		local f2_local0 = Engine.Localize( Engine.TableLookup( GameTypesTable.File, GameTypesTable.Cols.Ref, Engine.GetDvarString( "ui_gametype" ), GameTypesTable.Cols.Name ) )
		f2_arg0.headerText:setText( f2_local0 )
		local f2_local1, f2_local2, f2_local3, f2_local4 = GetTextDimensions( f2_local0, CoD.TextSettings.Font18.Font, CoD.TextSettings.Font18.Height )
		f2_arg0.headerElement:registerAnimationState( "update", {
			leftAnchor = true,
			topAnchor = true,
			width = f2_local3 - f2_local1 + 42,
			height = 27,
			top = -36
		} )
		f2_arg0.headerElement:animateToState( "update" )
	end
end

local MPLobbyPrivate = LUI.mp_menus.MPLobbyPrivate
local MPLobbyPublic = LUI.mp_menus.MPLobbyPublic

local OnLeaveLobby = function(f10_arg0)
	LUI.FlowManager.RequestLeaveMenuByName("menu_xboxlive_lobby")
	LUI.FlowManager.RequestLeaveMenuByName("FindGameSubMenu")
	LUI.FlowManager.RequestLeaveMenuByName("FindGameMenu")
	Engine.SetDvarBool( "force_ranking", false )
end

LUI.MPLobbyPublic.bonusIconSize = 45
f0_local0 = function ()
	local f1_local0 = Lobby.IsInPrivateParty()
	if f1_local0 then
		f1_local0 = not Lobby.IsAloneInPrivateParty()
	end
	return f1_local0
end

local f0_local1 = function ( f2_arg0 )
	local f2_local0 = Engine.GetDvarInt( "scr_xpscale" )
	local f2_local1 = Engine.GetDvarInt( "scr_xpscalewithparty" )
	local f2_local2 = Engine.GetDvarInt( "scr_depotcreditscale" )
	local f2_local3 = f0_local0()
	local f2_local4 = f2_arg0.bonusIconList
	if f2_arg0.bonusScales.xpScale ~= f2_local0 or f2_arg0.bonusScales.xpPartyScale ~= f2_local1 or f2_arg0.bonusScales.depotCreditScale ~= f2_local2 then
		f2_arg0.bonusScales.xpScale = f2_local0
		f2_arg0.bonusScales.xpPartyScale = f2_local1
		f2_arg0.bonusScales.depotCreditScale = f2_local2
		f2_local4.inParty = not f2_local3
	end
	if f2_local4.inParty ~= f2_local3 then
		f2_local4.inParty = f2_local3
		f2_local4:closeChildren()
		local f2_local5 = CoD.CreateState( 0, 0, nil, nil, CoD.AnchorTypes.TopLeft )
		f2_local5.height = LUI.MPLobbyPublic.bonusIconSize
		f2_local5.width = LUI.MPLobbyPublic.bonusIconSize
		if f2_local0 == 4 and GameX.IsRankedMatch() == true then
			f2_local5.material = RegisterMaterial( "ui_reward_small_quad_xp" )
			f2_local4:addElement( LUI.UIImage.new( f2_local5 ) )
		elseif f2_local0 == 2 then
			f2_local5.material = RegisterMaterial( "ui_reward_small_double_xp" )
			f2_local4:addElement( LUI.UIImage.new( f2_local5 ) )
		elseif f2_local3 and f2_local1 == 2 then
			f2_local5.material = RegisterMaterial( "ui_reward_small_double_party_xp" )
			f2_local4:addElement( LUI.UIImage.new( f2_local5 ) )
		end
		if f2_local2 == 2 then
			f2_local5.material = RegisterMaterial( "depot_currency_credit_2x" )
			f2_local4:addElement( LUI.UIImage.new( f2_local5 ) )
		end
	end
end

local f0_local2 = function ( f3_arg0, f3_arg1 )
	local f3_local0 = f0_local0()
	local f3_local1 = CoD.CreateState( f3_arg1 + 25, 17, nil, nil, CoD.AnchorTypes.TopLeft )
	f3_local1.width = 120
	f3_local1.height = LUI.MPLobbyPublic.bonusIconSize
	
	local bonusIconList = LUI.UIHorizontalList.new( f3_local1 )
	f3_arg0:addElement( bonusIconList )
	f3_arg0.bonusIconList = bonusIconList
	
	bonusIconList.inParty = f3_local0
	local f3_local3 = CoD.CreateState( 0, 0, nil, nil, CoD.AnchorTypes.TopLeft )
	f3_local3.height = LUI.MPLobbyPublic.bonusIconSize
	f3_local3.width = LUI.MPLobbyPublic.bonusIconSize
	if f3_arg0.bonusScales.xpScale == 4 and GameX.IsRankedMatch() == true then
		f3_local3.material = RegisterMaterial( "ui_reward_small_quad_xp" )
		bonusIconList:addElement( LUI.UIImage.new( f3_local3 ) )
	elseif f3_arg0.bonusScales.xpScale == 2 then
		f3_local3.material = RegisterMaterial( "ui_reward_small_double_xp" )
		bonusIconList:addElement( LUI.UIImage.new( f3_local3 ) )
	elseif f3_local0 and f3_arg0.bonusScales.xpPartyScale == 2 then
		f3_local3.material = RegisterMaterial( "ui_reward_small_double_party_xp" )
		bonusIconList:addElement( LUI.UIImage.new( f3_local3 ) )
	end
	if f3_arg0.bonusScales.depotCreditScale == 2 then
		f3_local3.material = RegisterMaterial( "depot_currency_credit_2x" )
		bonusIconList:addElement( LUI.UIImage.new( f3_local3 ) )
	end
	f3_arg0:registerEventHandler( "updatePartyBonusIcons", function ( element, event )
		f0_local1( f3_arg0 )
	end )
	local self = LUI.UITimer.new( 1000, "updatePartyBonusIcons" )
	self.id = "MPLobbyPublic_party_bonus_icon_update_timer"
	f3_arg0.bonusIconUpdateTimer = self
	f3_arg0:addElement( self )
end

LUI.MPLobbyPublic.CheckAddMapAndMarketingPanels = function ( f5_arg0, f5_arg1, f5_arg2 )
	if f5_arg0.addedDeferredContent then
		return true
	elseif Lobby.GetPartyStatus() ~= "" then
		f5_arg0:AddMapDisplay( LUI.MPLobbyMap.new, true )
		local f5_local0 = Engine.Localize( Engine.TableLookup( GameTypesTable.File, GameTypesTable.Cols.Ref, Engine.GetDvarString( "ui_gametype" ), GameTypesTable.Cols.Name ) )        
		if f5_local0 then
			f5_local0 = Engine.ToUpperCase( f5_local0 )
			f5_arg0:dispatchEventToChildren( {
				name = "update_header_text",
				string = f5_local0,
				dispatchChildren = true
			} )
			if f5_arg0.wholeTitle ~= nil and f5_arg0.wholeTitle.dotElement ~= nil then
				f5_arg0.wholeTitle.dotElement:close()
				LUI.MenuTemplate.AddDotElement( f5_arg0.wholeTitle, f5_local0, 0, 0 )
			end
		else
			f5_local0 = ""
		end
		local f5_local1, f5_local2, f5_local3, f5_local4 = LUI.MenuTemplate.GetTitleDimensions( f5_local0 )
		f0_local2( f5_arg0, f5_local3 )
		if f5_arg0.mapTimer ~= nil then
			LUI.UITimer.Stop( f5_arg0.mapTimer )
			f5_arg0:removeElement( f5_arg0.mapTimer )
			f5_arg0.mapTimer = nil
		end
		f5_arg0.addedDeferredContent = true
		return true
	else
		return false
	end
end

local StartGame = function()
	Engine.Exec("xblive_privatematch 1;xpartygo;wait 1;xblive_privatematch 0;map_restart")
end

local serverListButton = function()
	LUI.FlowManager.RequestAddMenu(a1, "menu_systemlink_join", true, nil)
end

function OnGameSetup2( f15_arg0, f15_arg1 )
    Engine.ExecNow("xblive_privatematch 1")
	LUI.FlowManager.RequestAddMenu( f15_arg0, "gamesetup_menu_main", true, f15_arg1.controller, false )
end

menu_xboxlive_lobby_orig = LUI.MenuBuilder.m_types_build["menu_xboxlive_lobby"]
menu_xboxlive_lobby = function(f11_arg0, f11_arg1)
    Engine.ExecNow("com_maxfps 0")
    Engine.ExecNow("xblive_privatematch 0")
	Engine.SetDvarBool( "force_ranking", true )
    Engine.ExecNow( "scr_xpscale 4" )    
	local f11_local0 = false
	if Engine.GetDvarBool( "ui_opensummary" ) then
		f11_local0 = true
	end
	local menu = LUI.MPLobbyBase.new( f11_arg0, {
		menu_title = " ",
		has_match_summary = true
	}, true )
	menu:setClass( LUI.MPLobbyPublic )
	menu:SetBreadCrumb( Engine.ToUpperCase( Engine.Localize( "@MENU_MULTIPLAYER_CAPS" ) ) )
	menu.bonusScales = {}
	if f11_arg1.category and f11_arg1.index then
		menu.bonusScales.xpScale = Playlist.GetPlaylistXpScale( f11_arg1.category, f11_arg1.index )
		menu.bonusScales.xpPartyScale = Playlist.GetPlaylistXpScaleWithParty( f11_arg1.category, f11_arg1.index )
		menu.bonusScales.depotCreditScale = Playlist.GetPlaylistDepotCreditScale( f11_arg1.category, f11_arg1.index )
	else
		menu.bonusScales.xpScale = Engine.GetDvarInt( "scr_xpscale" )
		menu.bonusScales.xpPartyScale = Engine.GetDvarInt( "scr_xpscalewithparty" )
		menu.bonusScales.depotCreditScale = Engine.GetDvarInt( "scr_depotcreditscale" )
	end
	if Engine.IsCoreMode() then
		menu:AddButton("@LUA_MENU_START_GAME", StartGame, false)
        menu:AddButton("@LUA_MENU_GAME_SETUP", OnGameSetup2, false)
		menu:AddCACButton()
		menu:AddBarracksButton()
		menu:AddPersonalizationButton()
		menu:AddDepotButton()
	end

	menu:AddOptionsButton()
	menu:AddMenuDescription( 0 )

	if not menu:CheckAddMapAndMarketingPanels( f11_local0 ) then
		menu:registerEventHandler( "CheckAddMapAndMarketingPanels", function ( element, event )
			LUI.MPLobbyPublic.CheckAddMapAndMarketingPanels( element, f11_local0 )
		end )
		local self = LUI.UITimer.new( 100, "CheckAddMapAndMarketingPanels" )
		self.id = "MPLobbyPublic_add_map_timer"
		menu.mapTimer = self
		menu:addElement( self )
	end

	menu:registerEventHandler( "exit_public_lobby", OnLeaveLobby )
	menu:registerEventHandler( "player_joined", Cac.PlayerJoinedEvent )
	menu:registerEventHandler( "loadout_request", Cac.PlayerJoinedEvent )
	Lobby.EnteredLobby()
	menu:AddCurrencyInfoPanel()
	return menu
end

LUI.MenuBuilder.m_types_build["menu_xboxlive_lobby"] = menu_xboxlive_lobby

-- need to add this for startup shit
local s1MPMainMenu = LUI.mp_menus.s1MPMainMenu
local function StartMenuMusic()
    if (Engine.GetDvarBool("startup_video_played") ~= true) then
	    return
    end
	Engine.PlayMusic( CoD.Music.MainMPMusicList[math.random( 1, #CoD.Music.MainMPMusicList )] )
end
s1MPMainMenu.StartMenuMusic = StartMenuMusic

LUI.MenuBuilder.m_definitions["main_choose_exe_popup_menu"] = function()
    return {
        type = "generic_yesno_popup",
        id = "main_choose_exe_popup_menu_id",
        properties = {
            popup_title = Engine.Localize("@MENU_NOTICE"),
            message_text = Engine.Localize("@MENU_QUIT_WARNING"),
            yes_action = function()
                Engine.Quit()
            end
        }
    }
end