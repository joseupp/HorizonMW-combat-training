LUI.MenuBuilder.registerType("dz_hud_def", function ()
    local is_splitscreen = GameX.IsSplitscreen()
    local panel_width    = 208
    local row_height     = 20
    local team_icon_size = 32
    local row_gap        = 2

    local top_pos  = is_splitscreen and 3   or 208
    local left_pos = is_splitscreen and 210 or -5

    local padding      = 4
    local column_width = (panel_width - 2 * padding) / 3

    local root = LUI.UIElement.new({
        topAnchor = true, leftAnchor = true,
        bottomAnchor = false, rightAnchor = false,
        top = top_pos, left = left_pos,
        width = panel_width,
        height = row_height * 2 + row_gap,
        alpha = 1
    })

    root.id = "dz_hud_id"

    local current_left = 0

    local bg1 = CoD.CreateState(current_left, 0, nil, nil, CoD.AnchorTypes.TopLeft)
    bg1.material = RegisterMaterial("white")
    bg1.width = column_width
    bg1.height = row_height
    bg1.alpha = 0.75
    bg1.color = { r = 0.08, g = 0.08, b = 0.08 }
    root:addElement(LUI.UIImage.new(bg1))

    local title_h = Engine.IsPC() and 10 or 12
    local title1 = CoD.CreateState(0, (row_height - title_h) / 2, nil, nil, CoD.AnchorTypes.TopLeft)
    title1.height = title_h
    title1.width  = column_width
    title1.alignment = LUI.Alignment.Center
    title1.font = CoD.TextSettings.TitleFontSmallBold.Font
    title1.textStyle = CoD.TextStyle.Shadowed

    local onzone_title_text = LUI.UIText.new(title1)
    onzone_title_text:setText(Engine.Localize("@MP_ONZONE_CAPS"))
    root:addElement(onzone_title_text)

    local ammo_h = CoD.TextSettings.SP_HudItemAmmoFont.Height * 0.75

    current_left = current_left + padding + column_width
    bg1.left = current_left
    root:addElement(LUI.UIImage.new(bg1))

    local icon_blue = CoD.CreateState(current_left + padding, (row_height - team_icon_size) / 2, nil, nil, CoD.AnchorTypes.TopLeft)
    icon_blue.material = RegisterMaterial("h1_hud_sd_teamicon_blue")
    icon_blue.height = team_icon_size
    icon_blue.width  = team_icon_size
    root:addElement(LUI.UIImage.new(icon_blue))

    local blue_state = CoD.CreateState(current_left + team_icon_size - padding, (row_height - ammo_h) / 2, nil, nil, CoD.AnchorTypes.TopLeft)
    blue_state.width = column_width - team_icon_size - padding
    blue_state.height = ammo_h
    blue_state.alignment = LUI.Alignment.Center
    blue_state.font = CoD.TextSettings.SP_HudItemAmmoFont.Font
    blue_state.textStyle = CoD.TextStyle.Shadowed

    local blue_count = LUI.UIText.new(blue_state)
    blue_count:setText("")
    root:addElement(blue_count)
    root.blue_team = blue_count
    root.blue_team.team = Teams.allies

    current_left = current_left + padding + column_width
    bg1.left = current_left
    root:addElement(LUI.UIImage.new(bg1))

    local icon_red = CoD.CreateState(current_left + padding, (row_height - team_icon_size) / 2, nil, nil, CoD.AnchorTypes.TopLeft)
    icon_red.material = RegisterMaterial("h1_hud_sd_teamicon_red")
    icon_red.height = team_icon_size
    icon_red.width  = team_icon_size
    root:addElement(LUI.UIImage.new(icon_red))

    local red_state = CoD.CreateState(current_left + team_icon_size - padding, (row_height - ammo_h) / 2, nil, nil, CoD.AnchorTypes.TopLeft)
    red_state.width = column_width - team_icon_size - padding
    red_state.height = ammo_h
    red_state.alignment = LUI.Alignment.Center
    red_state.font = CoD.TextSettings.SP_HudItemAmmoFont.Font
    red_state.textStyle = CoD.TextStyle.Shadowed

    local red_count = LUI.UIText.new(red_state)
    red_count:setText("")
    root:addElement(red_count)
    root.red_team = red_count
    root.red_team.team = Teams.axis

    local function update_onzone_handler(element, _)
        local dvar_name =
            (element.team == Teams.allies and "allies_onzone_count") or
            (element.team == Teams.axis   and "axis_onzone_count")   or
            nil
        local count = dvar_name and (Engine.GetDvarInt(dvar_name) or 0) or 0
        element:setText(count)
    end

    blue_count:registerEventHandler("update_onzone_count", update_onzone_handler)
    red_count:registerEventHandler("update_onzone_count", update_onzone_handler)

    root:registerEventHandler("playerstate_client_changed", function (element, _)
        if Game.InKillCam() == false then
            local my_team = Game.GetPlayerTeam()
            if my_team == Teams.spectator then my_team = Teams.allies end
            local opposing_team = GameX.GetPlayerOpposingTeam(my_team)
            element.blue_team.team = my_team
            element.red_team.team  = opposing_team
        end
    end)

    local row2_top = row_height + row_gap
    local left_span_width = (column_width * 2) + padding

    local row2_bg_left = CoD.CreateState(0, row2_top, nil, nil, CoD.AnchorTypes.TopLeft)
    row2_bg_left.material = RegisterMaterial("white")
    row2_bg_left.width  = left_span_width
    row2_bg_left.height = row_height
    row2_bg_left.alpha  = 0.75
    row2_bg_left.color  = { r = 0.08, g = 0.08, b = 0.08 }
    root:addElement(LUI.UIImage.new(row2_bg_left))

    local right_left = left_span_width + padding
    local row2_bg_right = CoD.CreateState(right_left, row2_top, nil, nil, CoD.AnchorTypes.TopLeft)
    row2_bg_right.material = RegisterMaterial("white")
    row2_bg_right.width  = column_width
    row2_bg_right.height = row_height
    row2_bg_right.alpha  = 0.75
    row2_bg_right.color  = { r = 0.08, g = 0.08, b = 0.08 }
    root:addElement(LUI.UIImage.new(row2_bg_right))

    local row2_label_state = CoD.CreateState(0, row2_top + (row_height - title_h) / 2, nil, nil, CoD.AnchorTypes.TopLeft)
    row2_label_state.width = left_span_width
    row2_label_state.height = title_h
    row2_label_state.alignment = LUI.Alignment.Center
    row2_label_state.font = CoD.TextSettings.TitleFontSmallBold.Font
    row2_label_state.textStyle = CoD.TextStyle.Shadowed

    local row2_label = LUI.UIText.new(row2_label_state)
    row2_label:setText(Engine.Localize("@MP_ZONE_AVAILABLE_IN"))
    row2_label:registerAnimationState("visible", { alpha = 1 })
    row2_label:registerAnimationState("hidden",  { alpha = 0 })
    row2_label:animateToState("visible", 0)
    root:addElement(row2_label)

    local timer_font_h = ammo_h
    local placeholder_state = CoD.CreateState(right_left, row2_top + (row_height - timer_font_h) / 2, nil, nil, CoD.AnchorTypes.TopLeft)
    placeholder_state.width = column_width
    placeholder_state.height = timer_font_h
    placeholder_state.alignment = LUI.Alignment.Center
    placeholder_state.font = CoD.TextSettings.SP_HudItemAmmoFont.Font
    placeholder_state.textStyle = CoD.TextStyle.Shadowed

    local row2_placeholder = LUI.UIText.new(placeholder_state)
    row2_placeholder:setText("-:--")
    row2_placeholder:registerAnimationState("visible", { alpha = 1 })
    row2_placeholder:registerAnimationState("hidden",  { alpha = 0 })
    row2_placeholder:animateToState("visible", 0)
    root:addElement(row2_placeholder)

    local row2_timer = LUI.UICountdown.new({})
    row2_timer.id = "dz_next_zone_timer"
    row2_timer:registerAnimationState("default", {
        topAnchor = true, leftAnchor = true,
        rightAnchor = false, bottomAnchor = false,
        top = row2_top + (row_height - timer_font_h) / 2,
        left = right_left,
        width = column_width,
        height = timer_font_h,
        font = CoD.TextSettings.SP_HudItemAmmoFont.Font,
        alignment = LUI.Alignment.Center,
        color = (Swatches.HUD and Swatches.HUD.Normal) or Colors.white
    })

    row2_timer:registerAnimationState("visible", { alpha = 1 })
    row2_timer:registerAnimationState("hidden",  { alpha = 0 })

    row2_timer:animateToState("default", 0)
    row2_timer:animateToState("hidden", 0)
    root:addElement(row2_timer)

    local function fade_swap_label(new_text)
        if root._dz_label_swap_timer then
            root._dz_label_swap_timer:close()
            root._dz_label_swap_timer = nil
        end

        row2_label:animateToState("hidden", 200)
        root._dz_label_pending = new_text

        root:registerEventHandler("dz_label_swap", function(element, _)
            if element._dz_label_pending then
                row2_label:setText(element._dz_label_pending)
                element._dz_label_pending = nil
            end
            row2_label:animateToState("visible", 200)
            if element._dz_label_swap_timer then
                element._dz_label_swap_timer:close()
                element._dz_label_swap_timer = nil
            end
        end)

        local t = LUI.UITimer.new(200, "dz_label_swap")
        t.id = "dz_label_swap_timer"
        root._dz_label_swap_timer = t
        root:addElement(t)
    end

    local last_stage = nil
    local placeholder_retired = false

    root:registerEventHandler("dz_placeholder_destroy", function(element, _)
        if row2_placeholder then
            row2_placeholder:close()
            row2_placeholder = nil
        end
    end)

    local function dz_update_zone_timer(_, _)
        local stage = Engine.GetDvarInt("ui_zonetimer_stage") or 0
        if stage ~= last_stage then
            if stage == 1 then
                fade_swap_label(Engine.Localize("@MP_NEXT_DROP_ZONE_IN"))
            else
                fade_swap_label(Engine.Localize("@MP_ZONE_AVAILABLE_IN"))
            end
            last_stage = stage
        end

        local end_ms = Engine.GetDvarInt("ui_zonetimer") or 0
        if end_ms > Game.GetTime() then
            if row2_timer.current_state ~= "visible" then
                row2_timer:animateToState("visible", 200)
            end
            if row2_placeholder and row2_placeholder.current_state ~= "hidden" then
                row2_placeholder:animateToState("hidden", 200)
                if not placeholder_retired then
                    placeholder_retired = true
                    local t = LUI.UITimer.new(220, "dz_placeholder_destroy")
                    t.id = "dz_placeholder_destroy_timer"
                    root:addElement(t)
                end
            end
            row2_timer:setEndTime(end_ms)
        else
            if row2_timer.current_state ~= "hidden" then
                row2_timer:animateToState("hidden", 200)
            end
        end
    end

    root:registerEventHandler("dz_update_zone_timer", dz_update_zone_timer)
    local update_zone_timer_tick = LUI.UITimer.new(100, "dz_update_zone_timer")
    update_zone_timer_tick.id = "dz_update_zone_timer_tick"
    root:addElement(update_zone_timer_tick)

    local update_counts_timer = LUI.UITimer.new(100, "update_onzone_count")
    update_counts_timer.id = "update_onzone_count_timer"
    root:addElement(update_counts_timer)

    return root
end)
