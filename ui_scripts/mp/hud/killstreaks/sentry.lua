if Engine.InFrontend() then
    return
end

current_fov_scale = Engine.GetDvarFloat( "cg_fovScale" )
in_sentry = false

local set_enabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "active" )
end

local set_disabled = function ( f3_arg0, f3_arg1 )
	f3_arg0:animateToState( "default" )
end

local ui_sentry_enabled = function(f4_arg0, f4_arg1)
    assert(f4_arg0)
    if Game.GetOmnvar("ui_remote_sentry_enabled") then
        if in_sentry == false then
        current_fov_scale = Engine.GetDvarFloat( "cg_fovScale" )
        Engine.SetDvarFloat( "cg_fovScale", 2.0 )
        in_sentry = true
        end
        
        f4_arg0:dispatchEventToRoot({
            name = "enable_sentry",
            immediate = true
        })
    else
        if in_sentry == true then
        Engine.SetDvarFloat( "cg_fovScale", current_fov_scale )
        in_sentry = false
        end
        
        f4_arg0:dispatchEventToRoot({
            name = "disable_sentry",
            immediate = true
        })
    end
end

_buildsentryOverlay = function ()

    local sentry_overlay = LUI.UIElement.new({
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        top = -15,
        left = -15,
        width = ScreenResolution[currentScreenResolution].width,
        height = ScreenResolution[currentScreenResolution].height,
        alpha = 0,
        handlers = {
			enable = set_enabled,
			disable = set_disabled,
		},
    })

    sentry_overlay:registerAnimationState( "active", {
		alpha = 1
	} )
	sentry_overlay:registerAnimationState( "default", {
		alpha = 0
	} )

    sentry_overlay:animateToState( "default", 0 )

    sentry_overlay:registerEventHandler( "enable_sentry", set_enabled )
	sentry_overlay:registerEventHandler( "disable_sentry", set_disabled )

    sentry_overlay:registerEventHandler( "playerstate_client_changed", ui_sentry_enabled )
    sentry_overlay:registerOmnvarHandler("ui_remote_sentry_enabled", ui_sentry_enabled)

    sentry_overlay.id = "sentry_overlay"

    LUI.MenuBuilder.BuildAddChild(sentry_overlay, {
        type = "UIImage",
        id = "ballistic_overlay",
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        states = {
            default = {
                width = ScreenResolution[currentScreenResolution].width + 32,
                height = ScreenResolution[currentScreenResolution].height + 32,
                material = RegisterMaterial("ballistic_overlay"),
                alpha = 0.2
            }
        }
    })

    local owner_161 = LUI.UIElement.new()
	owner_161.id = "ownerDrawId" .. 161
	owner_161:setupOwnerdraw( 161 )
	owner_161:registerAnimationState( "default", {
		bottom = -200,
        left = 515,
        width = 20,
        height = 20,
        alpha = 0.7,
        scale = 0.01,
        bottomAnchor = true,
        leftAnchor = true,
        font = CoD.TextSettings.BodyFont.Font,
        alignment = LUI.Alignment.Center
	} )
	owner_161:animateToState( "default", 0 )
    sentry_overlay:addElement(owner_161)

    local owner_160 = LUI.UIElement.new()
	owner_160.id = "ownerDrawId" .. 160
	owner_160:setupOwnerdraw( 160 )
	owner_160:registerAnimationState( "default", {
		bottom = -245,
        left = 475,
        width = 20,
        height = 20,
        alpha = 0.7,
        scale = 0.01,
        bottomAnchor = true,
        leftAnchor = true,
        font = CoD.TextSettings.BodyFont.Font,
        alignment = LUI.Alignment.Center
	} )
	owner_160:animateToState( "default", 0 )
    sentry_overlay:addElement(owner_160)

    LUI.MenuBuilder.BuildAddChild(sentry_overlay, {
        type = "UIText",
        id = "sentry_thermalText",
        properties = {
            text = Engine.Localize("@PLATFORM_UI_EXIT_REMOTE_SENTRY")
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = true,
                top = -205,
                bottom = -205 + 16,
                right = -240,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Right,
            }
        }
    })

    LUI.MenuBuilder.BuildAddChild(sentry_overlay, {
        type = "UIText",
        id = "sentry_25mmText",
        properties = {
            text = "25 mm"
        },
        states = {
            default = {
                topAnchor = false,
                bottomAnchor = true,
                leftAnchor = true,
                rightAnchor = false,
                top = -30,
                bottom = -30 + CoD.TextSettings.BodyFont.Height,
                left = 15,
                right = 15,
                font = CoD.TextSettings.BodyFont.Font,
                alignment = LUI.Alignment.Bottom,
                alpha = 1
            }
        }
    })

    -- Overlay Grain --
    LUI.MenuBuilder.BuildAddChild(sentry_overlay, {
        type = "UIImage",
        id = "sentry_overlay_grain",
        topAnchor = true,
        bottomAnchor = false,
        leftAnchor = true,
        rightAnchor = false,
        states = {
            default = {
                width = ScreenResolution[currentScreenResolution].width + 32,
                height = ScreenResolution[currentScreenResolution].height + 32,
                material = RegisterMaterial("ac130_overlay_grain"),
                alpha = 0.4
            }
        }
    })

    return sentry_overlay
end

LUI.MenuBuilder.registerType("sentry_overlay", _buildsentryOverlay)
