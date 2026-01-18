if (LUI.mp_menus) then
	return
end

RequestLeaveMenu = function(f1_arg0, f1_arg1)
	LUI.FlowManager.RequestLeaveMenu(f1_arg0)
end

local PopupMessage = function(f2_arg0, f2_arg1)
	f2_arg0:setText(f2_arg1.message_text)
	f2_arg0:dispatchEventToRoot({
		name = "resize_popup"
	})
end

local Backout = function(f3_arg0)
	Engine.ExecFirstClient("xpartybackout")
	Engine.ExecFirstClient("disconnect")
end

local DisbandAfterRound = function(f4_arg0)
	Engine.ExecFirstClient("xpartydisbandafterround")
	Engine.ExecFirstClient("disconnect")
end

local OnlineGame = function(f5_arg0)
	return Engine.GetDvarBool("onlinegame")
end

local Quit1 = function(f6_arg0)
	if OnlineGame(f6_arg0) then
		Engine.ExecFirstClient("xstopprivateparty")
		Engine.ExecFirstClient("disconnect")
		Engine.ExecFirstClient("xblive_privatematch 0")
		Engine.SetDvarBool( "force_ranking", false )
		Engine.ExecFirstClient("onlinegame 1")
		Engine.ExecFirstClient("xstartprivateparty")
	else
		Engine.ExecFirstClient("disconnect")
	end
end

local Quit2 = function(f7_arg0)
	Engine.ExecFirstClient("xstopprivateparty")
	Engine.ExecFirstClient("xpartydisbandafterround")
	if Engine.GetDvarBool("sv_running") then
		Engine.NotifyServer("end_game", 1)
		-- Engine.ExecFirstClient("disconnect")
		Engine.ExecFirstClient("xblive_privatematch 0")
		Engine.ExecFirstClient("onlinegame 1")
		Engine.ExecFirstClient("xstartprivateparty")
	else
		Quit1(f7_arg0)
	end
end

local Quit3 = function(f8_arg0, f8_arg1)
	Game.HandleLeavePauseMenu()
	if Engine.GetDvarBool("sv_running") then
		Engine.NotifyServer("end_game", 1)
	else
		Quit1(f8_arg0)
	end
	LUI.FlowManager.RequestCloseAllMenus(f8_arg0)
end

local LeaveWithParty = function(f9_arg0, f9_arg1)
	LUI.FlowManager.RequestLeaveMenu(f9_arg0)
	Game.HandleLeavePauseMenu()
	Engine.Exec("onPlayerQuit")
	if Engine.GetDvarBool("sv_running") then
		DisbandAfterRound(f9_arg0)
	else
		Backout(f9_arg0)
	end
	LUI.FlowManager.RequestCloseAllMenus(f9_arg0)
end

local LeaveSolo = function(f10_arg0, f10_arg1)
	LUI.FlowManager.RequestLeaveMenu(f10_arg0)
	Game.HandleLeavePauseMenu()
	Engine.Exec("onPlayerQuit")
	if Engine.GetDvarBool("sv_running") then
		Engine.NotifyServer("end_game", 2)
		Quit2(f10_arg0)
	else
		Quit1(f10_arg0)
	end
	LUI.FlowManager.RequestCloseAllMenus(f10_arg0)
end

local IsPartyHost = function(f11_arg0)
	local f11_local0 = Lobby.IsInPrivateParty()
	if f11_local0 then
		f11_local0 = Lobby.IsPrivatePartyHost()
		if f11_local0 then
			f11_local0 = not Lobby.IsAloneInPrivateParty()
		end
	end
	return f11_local0
end

local ManualQuit = function(f12_arg0, f12_arg1)
	Engine.ExecNow( "uploadstats", f12_arg1.controller )
	if Lobby.IsInPrivateParty() and Lobby.IsPrivatePartyHost() then
		Quit1(f12_arg0)
	elseif Lobby.IsPrivatePartyHost() and Lobby.IsAloneInPrivateParty() and Lobby.IsAlone() then
		Quit1(f12_arg0)
	elseif IsPartyHost(f12_arg0) then
		LUI.FlowManager.RequestLeaveMenu(f12_arg0, true)
		LUI.FlowManager.RequestAddMenu(f12_arg0, "popup_pull_party", false)
	else
		Game.HandleLeavePauseMenu()
		Engine.Exec("onPlayerQuit")
		if Engine.GetDvarBool("sv_running") then
			Quit2(f12_arg0)
		else
			Quit1(f12_arg0)
		end
		LUI.FlowManager.RequestCloseAllMenus(f12_arg0)
	end
	Engine.SetDvarBool( "force_ranking", false )
end

local EndGamePopup = function()
	local self = LUI.UIElement.new()
	self.id = "end_game_id"
	self:registerAnimationState("default", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = true,
		rightAnchor = true,
		top = 0,
		left = 0,
		bottom = 0,
		right = 0,
		alpha = 1
	})
	self:animateToState("default", 0)
	LUI.MenuBuilder.BuildAddChild(self, {
		type = "generic_yesno_popup",
		id = "privateGame_options_list_id",
		properties = {
			message_text_alignment = LUI.Alignment.Left,
			message_text = Engine.Localize("@LUA_MENU_END_GAME_DESC"),
			popup_title = Engine.Localize("@LUA_MENU_LEAVE_GAME_TITLE"),
			padding_top = 12,
			yes_action = Quit3
		}
	})
	local f13_local1 = LUI.UIBindButton.new()
	f13_local1.id = "endBackToGameStartButton"
	f13_local1:registerEventHandler("button_start", RequestLeaveMenu)
	self:addElement(f13_local1)
	return self
end

local LeaveGamePopup = function()
	local self = LUI.UIElement.new()
	self.id = "leave_game_id"
	self:registerAnimationState("default", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = true,
		rightAnchor = true,
		top = 0,
		left = 0,
		bottom = 0,
		right = 0,
		alpha = 1
	})
	self:animateToState("default", 0)
	LUI.MenuBuilder.BuildAddChild(self, {
		type = "generic_yesno_popup",
		id = "publicGame_options_list_id",
		properties = {
			message_text_alignment = LUI.Alignment.Left,
			message_text = Engine.Localize("@LUA_MENU_LEAVE_GAME_DESC"),
			popup_title = Engine.Localize("@LUA_MENU_LEAVE_GAME_TITLE"),
			padding_top = 12,
			yes_action = ManualQuit
		}
	})
	local f14_local1 = LUI.UIBindButton.new()
	f14_local1.id = "leaveBackToGameStartButton"
	f14_local1:registerEventHandler("button_start", RequestLeaveMenu)
	self:addElement(f14_local1)
	return self
end

local PullPartyPopup = function()
	local self = LUI.UIElement.new()
	self.id = "pull_party_out_id"
	self:registerAnimationState("default", {
		topAnchor = true,
		leftAnchor = true,
		bottomAnchor = true,
		rightAnchor = true,
		top = 0,
		left = 0,
		bottom = 0,
		right = 0,
		alpha = 1
	})
	self:animateToState("default", 0)
	LUI.MenuBuilder.BuildAddChild(self, {
		type = "generic_yesno_popup",
		id = "party_pullout_list_id",
		properties = {
			message_text_alignment = LUI.Alignment.Left,
			message_text = Engine.Localize("@LUA_MENU_PULL_PARTY_DESC"),
			popup_title = Engine.Localize("@LUA_MENU_LEAVE_GAME_TITLE"),
			padding_top = 12,
			yes_action = LeaveWithParty,
			no_action = LeaveSolo,
			cancel_means_no = false
		}
	})
	local f15_local1 = LUI.UIBindButton.new()
	f15_local1.id = "leavePullPartyButton"
	f15_local1:registerEventHandler("button_start", RequestLeaveMenu)
	self:addElement(f15_local1)
	return self
end

LUI.MenuBuilder.m_types_build["popup_end_game"] = EndGamePopup
LUI.MenuBuilder.m_types_build["popup_leave_game"] = LeaveGamePopup
LUI.MenuBuilder.m_types_build["popup_pull_party"] = PullPartyPopup
