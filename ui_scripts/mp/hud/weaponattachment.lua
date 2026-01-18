function deriveUVType()
    local uvType = 0
    local weaponName = Game.GetPlayerWeaponName()
    if string.find( weaponName, "eotech" ) ~= nil then
        uvType = 1
    elseif string.find( weaponName, "camo006" ) ~= nil or string.find( weaponName, "usrscope" ) ~= nil then
        uvType = 2
    end
    return uvType
end

function weaponChange_updateWeaponUVType( self, event )
    local newUVType = deriveUVType()
    if newUVType ~= self.weaponUVType then
        if self.weaponUVType == 0 then
            
        elseif self.weaponUVType == 1 then
            weaponAttachUpdate_eotechReset( self )
        elseif self.weaponUVType == 2 then
            
        else
            
        end
        if newUVType == 0 then
            Game.EnableViewModelUVAnimTimeOverride( false )
        else
            Game.EnableViewModelUVAnimTimeOverride( true )
            Game.SetViewModelUVAnimTimeOverride( 0 )
        end
        self.weaponUVType = newUVType
    end
end

function timer_updateWeaponAttachment( self, event )
    if self.weaponUVType == -1 then
        weaponChange_updateWeaponUVType( self, event )
    end
    if isEMPed() then
        if self.weaponUVType == 1 then
            weaponAttachUpdate_eotechEMP()
        elseif self.weaponUVType == 2 then
            weaponAttachUpdate_scopeKillsEMP()
        end
    elseif self.weaponUVType == 1 then
        weaponAttachUpdate_eotech( self, event )
    elseif self.weaponUVType == 2 then
        weaponAttachUpdate_scopeKills( self, event )
    end
end

function isEMPed()
    return Game.GetOmnvar( "ui_hud_emp_artifact" ) or Game.GetOmnvar( "ui_hud_static" ) > 0
end

local EOTECH_FRAME_COUNT = 24
local EOTECH_FRAME_STEP = 31.25
function weaponAttachUpdate_eotech( self, event )
    local dmgStats = Game.GetWeaponDamageStats()
    local traceDist = Game.GetCrosshairTraceDistance()
    if traceDist == 0 then
        traceDist = dmgStats.minDamageRange
    end
    local damageFrac = 0
    local rangeDiff = dmgStats.minDamageRange - dmgStats.maxDamageRange
    if rangeDiff ~= 0 then
        damageFrac = 1 - LUI.clamp( (traceDist - dmgStats.maxDamageRange) / rangeDiff, 0, 1 )
    end
    if self.eotechBarDisplayPrev == nil then
        self.eotechBarDisplayPrev = 0
    end
    local interpolatedDisplay = (damageFrac - self.eotechBarDisplayPrev) * 0.25 + self.eotechBarDisplayPrev
    Game.SetViewModelUVAnimTimeOverride( LUI.clamp( math.floor( interpolatedDisplay * EOTECH_FRAME_COUNT ) * EOTECH_FRAME_STEP, EOTECH_FRAME_STEP, EOTECH_FRAME_STEP * (EOTECH_FRAME_COUNT - 1) ) )
    self.eotechBarDisplayPrev = interpolatedDisplay
end

function weaponAttachUpdate_eotechReset( self )
    self.eotechBarDisplayPrev = 0
end

function weaponAttachUpdate_eotechNewClient( self )
    weaponAttachUpdate_eotechReset( self, event )
end

function weaponAttachUpdate_eotechEMP()
    Game.SetViewModelUVAnimTimeOverride( (EOTECH_FRAME_COUNT + 1) * EOTECH_FRAME_STEP )
end

local SCOPE_FRAME_0 = 0
local SCOPE_FRAME_1 = 1
local SCOPE_FRAME_2 = 2
local SCOPE_FRAME_3 = 3
local SCOPE_FRAME_4 = 4
local SCOPE_FRAME_5 = 5
local SCOPE_FRAME_6 = 6
local SCOPE_FRAME_EMP = 7
local SCOPE_FRAME_MULTIPLIER = 125

function omnvarScope_updateSniperScopeState( self, omnvar )
    self.scopeDisplayStateNew = omnvar.value
end

function weaponAttachUpdate_scopeKills( self, event )
    if self.scopeDisplayState == -1 then
        initScopeDisplayState( self, 0, SCOPE_FRAME_0, SCOPE_FRAME_1, -1, 10 )
    end
    if self.scopeDisplayStateNew ~= -1 then
        initScopeDisplayStateByNum( self, self.scopeDisplayStateNew )
        self.scopeDisplayStateNew = -1
    end
    if self.scopeFlashCount == -1 or self.scopeFlashCount > 0 then
        self.scopeUpdates = self.scopeUpdates + 1
        if self.scopeFlashPer <= self.scopeUpdates then
            if self.scopeFrameCurrent == self.scopeFrameA then
                self.scopeFrameCurrent = self.scopeFrameB
            else
                self.scopeFrameCurrent = self.scopeFrameA
            end

            if self.scopeFlashCount ~= -1 then
                self.scopeFlashCount = self.scopeFlashCount - 1
            end
            self.scopeUpdates = 0
        end
    elseif self.scopeFrameCurrent ~= self.scopeFrameA then
        self.scopeFrameCurrent = self.scopeFrameA
    end
    Game.SetViewModelUVAnimTimeOverride( SCOPE_FRAME_MULTIPLIER * self.scopeFrameCurrent )
end

function weaponAttachUpdate_scopeNewClient( self )
    forceScopeDisplayStateByNum( self, Game.GetOmnvar( "weap_sniper_display_state" ) )
end

function forceScopeDisplayStateByNum( self, stateNum )
    initScopeDisplayStateByNum( self, stateNum )
    if self.scopeFlashCount ~= -1 then
        self.scopeFlashCount = 0
    end
end

function initScopeDisplayStateByNum( self, stateNum )
    if stateNum == 0 then
        initScopeDisplayState( self, stateNum, SCOPE_FRAME_0, SCOPE_FRAME_1, -1, 10 )
    elseif stateNum == 1 then
        initScopeDisplayState( self, stateNum, SCOPE_FRAME_2, SCOPE_FRAME_1, 10, 5 )
    elseif stateNum == 2 then
        initScopeDisplayState( self, stateNum, SCOPE_FRAME_3, SCOPE_FRAME_1, 10, 5 )
    elseif stateNum == 3 then
        initScopeDisplayState( self, stateNum, SCOPE_FRAME_4, SCOPE_FRAME_1, 10, 5 )
    elseif stateNum == 4 then
        initScopeDisplayState( self, stateNum, SCOPE_FRAME_6, SCOPE_FRAME_1, 10, 5 )
    end
end

function initScopeDisplayState( self, state, frameA, frameB, flashCount, flashPer )
    self.scopeDisplayState = state
    self.scopeFrameA = frameA
    self.scopeFrameB = frameB
    self.scopeFlashCount = flashCount
    self.scopeFlashPer = flashPer
    self.scopeFrameCurrent = frameA
    self.scopeUpdates = 0
    Game.SetViewModelUVAnimTimeOverride( SCOPE_FRAME_MULTIPLIER * self.scopeFrameCurrent )
end

function weaponAttachUpdate_scopeKillsEMP()
    Game.SetViewModelUVAnimTimeOverride( SCOPE_FRAME_EMP * SCOPE_FRAME_MULTIPLIER )
end

function weaponAttachmentProcessing_init( self )
    self.weaponUVType = -1
    self.eotechBarDisplayPrev = nil
    self.scopeDisplayState = -1
    self.scopeFrameA = SCOPE_FRAME_0
    self.scopeFrameB = SCOPE_FRAME_1
    self.scopeFrameCurrent = self.scopeFrameA
    self.scopeFlashCount = -1
    self.scopeFlashPer = 10
    self.scopeUpdates = 0
    self.scopeDisplayStateNew = -1
end

function clientChanged_updateAttachmentState( self, event )
    weaponAttachmentProcessing_init( self )
    weaponAttachUpdate_eotechNewClient( self )
    weaponAttachUpdate_scopeNewClient( self )
    weaponChange_updateWeaponUVType( self, event )
end

function weaponAttachmentProcessing()
    local self = LUI.UIElement.new()
    self.id = "weapAttachment"
    self:registerEventHandler( "update_weapon_attachment", timer_updateWeaponAttachment )
    self:addElement( LUI.UITimer.new( 50, "update_weapon_attachment" ) )
    self:registerEventHandler( "weapon_change", weaponChange_updateWeaponUVType )
    self:registerOmnvarHandler( "weap_sniper_display_state", omnvarScope_updateSniperScopeState )
    self:registerEventHandler( "playerstate_client_changed", clientChanged_updateAttachmentState )
    weaponAttachmentProcessing_init( self )
    return self
end

LUI.MenuBuilder.registerType( "weaponAttachmentProcessing", weaponAttachmentProcessing )