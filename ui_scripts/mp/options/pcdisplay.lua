local pcdisplay = luiglobals.require("LUI.PCDisplay")


-- HUD COLOR STUFF
local function get_hudcolor_r()
return (Engine.GetDvarFloat("hud_color_r") - SliderBounds.hud_color_r.Min) /
            (SliderBounds.hud_color_r.Max - SliderBounds.hud_color_r.Min)
end

local function get_hudcolor_g()
return (Engine.GetDvarFloat("hud_color_g") - SliderBounds.hud_color_g.Min) /
            (SliderBounds.hud_color_g.Max - SliderBounds.hud_color_g.Min)
end

local function get_hudcolor_b()
return (Engine.GetDvarFloat("hud_color_b") - SliderBounds.hud_color_b.Min) /
            (SliderBounds.hud_color_b.Max - SliderBounds.hud_color_b.Min)
end

local function change_hudcolor_r(value)
    Engine.SetDvarFloat("hud_color_r", math.min(SliderBounds.hud_color_r.Max, math.max(
        SliderBounds.hud_color_r.Min, Engine.GetDvarFloat("hud_color_r") + value)))
end

local function change_hudcolor_g(value)
    Engine.SetDvarFloat("hud_color_g", math.min(SliderBounds.hud_color_g.Max, math.max(
        SliderBounds.hud_color_g.Min, Engine.GetDvarFloat("hud_color_g") + value)))
end

local function change_hudcolor_b(value)
    Engine.SetDvarFloat("hud_color_b", math.min(SliderBounds.hud_color_b.Max, math.max(
        SliderBounds.hud_color_b.Min, Engine.GetDvarFloat("hud_color_b") + value)))
end

local function refreshUI()
    if not Engine.GetDvarBool("virtualLobbyReady") then
        Engine.Exec("lui_restart")
    else
        Engine.Exec("lui_restart")
        Engine.Exec("lui_open menu_xboxlive")
    end
end

pcdisplay.CreateOptions = function(menu)
    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select, "@LUA_MENU_COLORBLIND_FILTER",
        "@LUA_MENU_COLOR_BLIND_DESC", LUI.Options.GetRenderColorBlindText, LUI.Options.RenderColorBlindToggle,
        LUI.Options.RenderColorBlindToggle)

    --[[
    if Engine.IsMultiplayer() and Engine.GetDvarType("cg_paintballFx") == DvarTypeTable.DvarBool then
        LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select,
            "@LUA_MENU_PAINTBALL", "@LUA_MENU_PAINTBALL_DESC",
            LUI.Options.GetDvarEnableTextFunc("cg_paintballFx", false), LUI.Options.ToggleDvarFunc("cg_paintballFx"),
            LUI.Options.ToggleDvarFunc("cg_paintballFx"))
    end
    ]] --

    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select, "@LUA_MENU_BLOOD",
        "@LUA_MENU_BLOOD_DESC", LUI.Options.GetDvarEnableTextFunc("cg_blood", false), LUI.Options
            .ToggleProfiledataFunc("showblood", Engine.GetControllerForLocalClient(0)), LUI.Options
            .ToggleProfiledataFunc("showblood", Engine.GetControllerForLocalClient(0)))

    --[[
    if not Engine.IsMultiplayer() then
        LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select,
            "@LUA_MENU_CROSSHAIR", "@LUA_MENU_CROSSHAIR_DESC",
            LUI.Options.GetDvarEnableTextFunc("cg_drawCrosshairOption", false),
            LUI.Options.ToggleDvarFunc("cg_drawCrosshairOption"), LUI.Options.ToggleDvarFunc("cg_drawCrosshairOption"))

        LUI.Options.CreateOptionButton(menu, "cg_drawDamageFeedbackOption", "@LUA_MENU_HIT_MARKER",
            "@LUA_MENU_HIT_MARKER_DESC", {{
                text = "@LUA_MENU_ENABLED",
                value = true
            }, {
                text = "@LUA_MENU_DISABLED",
                value = false
            }})
    end
    ]] --
    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select, "@MENU_DISPLAY_MEDAL_SPLASHES",
        "@MENU_DISPLAY_MEDAL_SPLASHES_DESC", pcdisplay.GetDisplayMedalSplashesText,
        pcdisplay.DisplayMedalSplashesToggle, pcdisplay.DisplayMedalSplashesToggle)
    
    LUI.Options.CreateOptionButton(menu, "ui_score_popup_style", "@SCORE_POPUP_STYLE",
        "@SCORE_POPUP_STYLE_DESC", {
            {
                text = "@SCORE_POPUP_STYLE_IW4",
                value = 0
            },
            {
                text = "@SCORE_POPUP_STYLE_IW6",
                value = 1
            }
        }, nil, nil, function(value)
        pcall(Engine.SetDvarInt, "ui_score_popup_style", value)
    end)

    do
        local ok, val = pcall(Engine.GetDvarInt, "ui_score_popup_style")
        if not ok or val == nil then
            pcall(Engine.SetDvarInt, "ui_score_popup_style", 0)
        end
    end

    --[[
    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Select, "@MENU_DISPLAY_WEAPON_EMBLEMS",
        "@MENU_DISPLAY_WEAPON_EMBLEMS_DESC", pcdisplay.GetDisplayWeaponEmblemsText,
        pcdisplay.DisplayWeaponEmblemsToggle, pcdisplay.DisplayWeaponEmblemsToggle)
    ]]--

   --[[ TODO: LUI.Options.CreateOptionButton(menu, "cg_xpbar", "@LUA_XPBAR_CAPS", "@LUA_XPBAR_CAPS", {{
        text = "@LUA_MENU_ENABLED",
        value = true
    }, {
        text = "@LUA_MENU_DISABLED",
        value = false
    }}, nil, nil, function(value)
        Engine.SetDvarBool("cg_xpbar", value)
    end) ]]

    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Common, "@MENU_BRIGHTNESS",
        "@MENU_BRIGHTNESS_DESC1", nil, nil, nil, pcdisplay.OpenBrightnessMenu, nil, nil, nil)

    local reddotbounds = {
        step = 0.2,
        max = 4,
        min = 0.2
    }

    createdivider(menu, Engine.Localize("@LUA_MENU_TELEMETRY"))

    LUI.Options.CreateOptionButton(menu, "cg_infobar_ping", "@LUA_MENU_LATENCY", "@LUA_MENU_LATENCY_DESC", {{
        text = "@LUA_MENU_ENABLED",
        value = true
    }, {
        text = "@LUA_MENU_DISABLED",
        value = false
    }}, nil, nil, function(value)
        Engine.SetDvarBool("cg_infobar_ping", value)
        Engine.GetLuiRoot():processEvent({
            name = "update_hud_infobar_settings"
        })
    end)

    LUI.Options.CreateOptionButton(menu, "cg_infobar_fps", "@LUA_MENU_FPS", "@LUA_MENU_FPS_DESC", {{
        text = "@LUA_MENU_ENABLED",
        value = true
    }, {
        text = "@LUA_MENU_DISABLED",
        value = false
    }}, nil, nil, function(value)
        Engine.SetDvarBool("cg_infobar_fps", value)
        Engine.GetLuiRoot():processEvent({
            name = "update_hud_infobar_settings"
        })
    end)

    LUI.Options.CreateOptionButton(menu, "cg_infobar_streak", "@MENU_KILLSTREAK_CAPS", "@LUA_MENU_STREAK_DESC", {{
        text = "@LUA_MENU_ENABLED",
        value = true
    }, {
        text = "@LUA_MENU_DISABLED",
        value = false
    }}, nil, nil, function(value)
        Engine.SetDvarBool("cg_infobar_streak", value)
        Engine.GetLuiRoot():processEvent({
            name = "update_hud_infobar_settings"
        })
    end)

    createdivider(menu, Engine.Localize("@MENU_HUD_COLOR"))
    
    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Slider, "@HUD_COLOR_RED",
        "@HUD_COLOR_RED_DESC", get_hudcolor_r, function() -- less
            change_hudcolor_r(-SliderBounds.hud_color_r.Step)
        end, function() -- more
            change_hudcolor_r(SliderBounds.hud_color_r.Step)
        end)

    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Slider, "@HUD_COLOR_GREEN",
        "@HUD_COLOR_GREEN_DESC", get_hudcolor_g, function() -- less
            change_hudcolor_g(-SliderBounds.hud_color_g.Step)
        end, function() -- more
            change_hudcolor_g(SliderBounds.hud_color_g.Step)
        end)

    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Slider, "@HUD_COLOR_BLUE",
        "@HUD_COLOR_BLUE_DESC", get_hudcolor_b, function() -- less
            change_hudcolor_b(-SliderBounds.hud_color_b.Step)
        end, function() -- more
            change_hudcolor_b(SliderBounds.hud_color_b.Step)
        end)

    LUI.Options.AddButtonOptionVariant(menu, GenericButtonSettings.Variants.Common, "@HUD_COLOR_APPLY",
        "@HUD_COLOR_APPLY_DESC", nil, nil, nil, refreshUI, nil, nil, nil)

    LUI.Options.InitScrollingList(menu.list, nil)

end
