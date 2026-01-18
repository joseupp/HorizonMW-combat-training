local function build_iw4_points_popup(main_element)
    local default_scale = 0
    local text_element = LUI.UIText.new({
        font = CoD.TextSettings.H1TitleFont.Font,
        alignment = LUI.Alignment.Center,
        topAnchor = true, bottomAnchor = false, leftAnchor = true, rightAnchor = true,
        left = -40, top = -85, right = 0, height = 30, alpha = 1, scale = default_scale,
        color = Colors.mw1_green
    })
    text_element.id = "points_iw4"
    text_element:setTextStyle(CoD.TextStyle.ShadowedMore)
    text_element:registerAnimationState("start", { scale = default_scale, alpha = 1 })
    text_element:registerAnimationState("pop", { scale = 2, alpha = 1 })
    text_element:registerAnimationState("hidden", { scale = default_scale, alpha = 0 })

    text_element:registerEventHandler("fade", function(element, event)
        element.active = false
        element:animateToState("hidden", 600)
    end)

    text_element:registerEventHandler("reset", function(element, event)
        element:setText("")
        element:animateToState("default")
    end)

    local function iw4_on_points(eventValue)
        if eventValue > 0 then
            main_element.ttl = Game.GetTime() + 1180
            if not main_element.visible then
                main_element:processEvent({ name = "reset" })
            end
            main_element.visible = true
            if not main_element.timer then
                main_element.timer = LUI.UITimer.new(100, "monitor_ttl")
                main_element.timer.id = "timer"
                main_element:addElement(main_element.timer)
                main_element:registerEventHandler("monitor_ttl", function(element, event)
                    if element.ttl < Game.GetTime() and not Game.InKillCam() then
                        main_element.timer:close()
                        main_element.timer = nil
                        main_element:processEvent({ name = "fade" })
                        main_element.visible = false
                    end
                end)
            end

            text_element:setText("+" .. eventValue)
            text_element.active = true
            local animator = MBh.AnimateSequence({
                { "default", 20 },
                { "pop", 100 },
                { "default", 118 }
            })
            animator(text_element, {})
        end
    end

    main_element:addElement(text_element)
    main_element._iw4_on_points = iw4_on_points
end

local function build_iw6_points_popup(main_element)
    local f0_local0 = 1250
    local f0_local1 = 100
    local flash_material = RegisterMaterial("pointflash")

    local bg_flash = LUI.UIImage.new()
    bg_flash.id = "pointsBgImage"
    bg_flash:registerAnimationState("default", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -128, left = -128, bottom = 128, right = 128, material = flash_material, alpha = 0
    })
    bg_flash:animateToState("default", 0)
    bg_flash:registerAnimationState("active", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -128, left = -128, bottom = 128, right = 128, material = flash_material, alpha = 1
    })
    bg_flash:registerAnimationState("closing", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = 256, left = -640, bottom = -256, right = 640, material = flash_material, alpha = 0
    })

    local half_font_h = CoD.TextSettings.TitleFontTiny.Height * 0.5
    local size_val = 128

    local points_container = LUI.UIElement.new()
    points_container.id = "pointsContainer_iw6"
    points_container:registerAnimationState("default", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h, left = -size_val, bottom = half_font_h, right = size_val, alpha = 0
    })
    points_container:animateToState("default", 0)
    points_container:registerAnimationState("opening", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h * 10, left = -size_val * 10, bottom = half_font_h * 10, right = size_val * 10, alpha = 0
    })
    points_container:registerAnimationState("active", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h, left = -size_val, bottom = half_font_h, right = size_val, alpha = 1
    })

    local points_value_text = LUI.UIText.new()
    points_value_text.id = "pointsValueText_iw6"
    points_value_text:setText("")
    points_value_text:setTextStyle(CoD.TextStyle.Shadowed)
    points_value_text:registerAnimationState("default", {
        topAnchor = true, leftAnchor = true, bottomAnchor = true, rightAnchor = true,
        font = CoD.TextSettings.TitleFontTiny.Font, alignment = LUI.Alignment.Center
    })
    points_value_text:animateToState("default", 0)
    points_container:addElement(points_value_text)

    local ghosted_container = LUI.UIElement.new()
    ghosted_container.id = "ghostedPointsContainer_iw6"
    ghosted_container:registerAnimationState("default", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h, left = -size_val, bottom = half_font_h, right = size_val, alpha = 0
    })
    ghosted_container:animateToState("default", 0)
    ghosted_container:registerAnimationState("active", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h, left = -size_val, bottom = half_font_h, right = size_val, alpha = 0.75
    })
    ghosted_container:registerAnimationState("closing", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h * 2, left = -size_val * 2, bottom = half_font_h * 2, right = size_val * 2, alpha = 0
    })

    local ghosted_value_text = LUI.UIText.new()
    ghosted_value_text.id = "ghostedPointsValueText_iw6"
    ghosted_value_text:setText("")
    ghosted_value_text:setTextStyle(CoD.TextStyle.Shadowed)
    ghosted_value_text:registerAnimationState("default", {
        topAnchor = true, leftAnchor = true, bottomAnchor = true, rightAnchor = true,
        font = CoD.TextSettings.TitleFontTiny.Font, alignment = LUI.Alignment.Center
    })
    ghosted_value_text:animateToState("default", 0)
    ghosted_container:addElement(ghosted_value_text)

    local desc_text = LUI.UIText.new()
    desc_text.id = "pointsDescText_iw6"
    desc_text:setText("")
    desc_text:setTextStyle(CoD.TextStyle.Shadowed)
    desc_text:registerAnimationState("default", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h + 20, left = -size_val, bottom = half_font_h + 20, right = size_val,
        font = CoD.TextSettings.TitleFontTiny.Font, alignment = LUI.Alignment.Center, alpha = 0
    })
    desc_text:animateToState("default", 0)
    desc_text:registerAnimationState("opening", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h + 20, left = -size_val - 100, bottom = half_font_h + 20, right = size_val - 100, alpha = 0
    })
    desc_text:registerAnimationState("active", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h + 20, left = -size_val, bottom = half_font_h + 20, right = size_val, alpha = 1
    })
    desc_text:registerAnimationState("closing", {
        topAnchor = false, leftAnchor = false, bottomAnchor = false, rightAnchor = false,
        top = -half_font_h + 20, left = -size_val + 100, bottom = half_font_h + 20, right = size_val + 100, alpha = 0
    })

    main_element:addElement(bg_flash)
    main_element:addElement(ghosted_container)
    main_element:addElement(points_container)
    main_element:addElement(desc_text)

    ghosted_value_text:registerOmnvarHandler("ui_points_popup", function(element, event)
        if event.value == -1 then
            return
        end
        if Game.InKillCam() and not MLG.IsMLGSpectator() then
            return
        end

        local ok, style = pcall(Engine.GetDvarInt, "ui_score_popup_style")
        if not ok or style == nil then style = 0 end

        if style == 0 then
            if main_element._iw4_on_points then
                main_element._iw4_on_points(event.value)
            end
            return
        end

        if event.value ~= 0 and main_element.processOmnvarEvent then
            if event.value >= 0 then
                points_value_text:setText("+" .. event.value)
                ghosted_value_text:setText("+" .. event.value)
            else
                points_value_text:setText(tostring(event.value))
                ghosted_value_text:setText(tostring(event.value))
            end

            main_element.visible = true

            local seq_points = MBh.AnimateSequence({
                { "opening", 0 }, { "active", f0_local1 }, { "active", f0_local0 },
                { "default", 50 }, { "default", 50 }, { "active", 0 }, { "active", 50 },
                { "default", 50 }, { "default", 50 }, { "active", 0 }, { "active", 50 },
                { "default", 150 }
            })
            seq_points(points_container)

            local seq_ghost = MBh.AnimateSequence({
                { "default", 0 }, { "default", f0_local1 }, { "active", 0 }, { "closing", 350 }
            })
            seq_ghost(ghosted_container)

            local seq_flash = MBh.AnimateSequence({
                { "default", 0 }, { "default", f0_local1 }, { "active", 0 }, { "closing", 250 }
            })
            seq_flash(bg_flash)
        end
    end)

    ghosted_value_text:registerOmnvarHandler("ui_points_popup_desc", function(element, event)
        if event.value == -1 then
            return
        end
        if Game.InKillCam() and not MLG.IsMLGSpectator() then
            return
        end

        local ok, style = pcall(Engine.GetDvarInt, "ui_score_popup_style")
        if not ok or style == nil then style = 0 end

        if style ~= 1 then
            return
        end

        local desc_el = main_element:getChildById("pointsDescText_iw6")
        if desc_el then
            if XPEventTable and XPEventTable.File and XPEventTable.Cols and XPEventTable.Cols.Name then
                desc_el:setText(Engine.Localize("@" .. Engine.TableLookupByRow(XPEventTable.File, event.value, XPEventTable.Cols.Name)))
            else
                desc_el:setText(Engine.Localize(tostring(event.value)))
            end

            local seq = MBh.AnimateSequence({
                { "opening", 0 }, { "opening", f0_local1 }, { "active", 150 }, { "active", f0_local0 }, { "closing", 100 }
            })
            seq(desc_el)

            if XPEventTable and XPEventTable.File and XPEventTable.Cols and XPEventTable.Cols.Sound then
                local soundName = Engine.TableLookupByRow(XPEventTable.File, event.value, XPEventTable.Cols.Sound)
                if soundName and soundName ~= "null" then
                    Engine.PlaySound(soundName)
                end
            end
        end
    end)

    main_element._iw6_on_points = function(val)
        local ok, _ = pcall(function() ghosted_value_text:processEvent({ name = "omnvar", omnvar = "ui_points_popup", value = val }) end)
        if not ok then
            if val ~= 0 and main_element.processOmnvarEvent then
                if val >= 0 then
                    points_value_text:setText("+" .. val)
                    ghosted_value_text:setText("+" .. val)
                else
                    points_value_text:setText(tostring(val))
                    ghosted_value_text:setText(tostring(val))
                end
            end
        end
    end

    main_element._iw6_on_desc = function(val)
        local ok, _ = pcall(function() ghosted_value_text:processEvent({ name = "omnvar", omnvar = "ui_points_popup_desc", value = val }) end)
        if not ok then
            local desc_el = main_element:getChildById("pointsDescText_iw6")
            if desc_el then
                desc_el:setText(Engine.Localize(tostring(val)))
            end
        end
    end
end

LUI.MenuBuilder.m_types_build["pointsPopup"] = function()
    local main_element = LUI.UIElement.new({
        topAnchor = false, bottomAnchor = false, leftAnchor = false, rightAnchor = false,
        top = 10, height = 0, left = 20, width = 0
    })

    main_element.id = "pointsPopup"
    main_element.processOmnvarEvent = true

    build_iw4_points_popup(main_element)
    build_iw6_points_popup(main_element)

    main_element.curClientNum = Game.GetPlayerstateClientnum()
    main_element:registerEventHandler("playerstate_client_changed", function(element, event)
        local clientNum = Game.GetPlayerstateClientnum()
        if main_element.curClientNum ~= clientNum then
            main_element.curClientNum = clientNum
            main_element.processOmnvarEvent = not Game.InKillCam()
        end
    end)

    return main_element
end
