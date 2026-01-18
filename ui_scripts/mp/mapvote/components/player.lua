function textlength(text, font, height)
    local _, _, width = luiglobals.GetTextDimensions(text, font, height)
    return width
end

function trimtext(text, font, height, maxwidth)
    if (maxwidth < 0) then
        return text
    end

    while (textlength(text, font, height) > maxwidth) do
        text = text:sub(1, #text - 1)
    end

    return text
end

function CreatePlayer(player)
    local container = LUI.UIElement.new({
        topAnchor = true,
        rightAnchor = true,
        leftAnchor = true,
        height = 34,
    })

    local background = LUI.UIImage.new({
        topAnchor = true,
        rightAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        material = RegisterMaterial("white"),
        alpha = 0.03
    })

    local playerName = LUI.UIText.new({
        topAnchor = true,
        leftAnchor = true,
        top = 9,
        left = 6,
        width = 340,
        height = 16,
        color = Colors.white,
        font = CoD.TextSettings.H1TitleFont.Font
    })

    local voteContainer = LUI.UIElement.new({
        topAnchor = true,
        rightAnchor = true,
        bottomAnchor = true,
        top = 7,
        right = -6,
        width = 60,
    })

    local votedGlow = LUI.UIImage.new({
        topAnchor = true,
        rightAnchor = true,
        top = 1,
        right = 12,
        width = 74,
        height = 16,
        material = RegisterMaterial("h1_hud_team_score_glow"),
        color = Colors.yellow,
        alpha = player.hasVoted and 0.4 or 0
    })

    local voteStatus = LUI.UIText.new({
        topAnchor = true,
        rightAnchor = true,
        leftAnchor = true,
        top = 3,
        right = 0,
        height = 14,
        color = Colors.white,
        font = CoD.TextSettings.H1TitleFont.Font,
        alignment = LUI.Alignment.Right
    })

    playerName:setText(trimtext(player.name, CoD.TextSettings.H1TitleFont.Font, 16, 235))
    voteStatus:setText(player.hasVoted and "Voted" or "Waiting...")

    container:addElement(background)
    container:addElement(playerName)
    container:addElement(voteContainer)

    voteContainer:addElement(votedGlow)
    voteContainer:addElement(voteStatus)

    local timer = LUI.UITimer.new(100, "updatePlayer"..player.id)
    
    container:addElement(timer)

    container:addEventHandler("updatePlayer"..player.id, function()
        player.hasVoted = Engine.GetDvarBool( "ui_mapvote_player_".. player.id .."_voted" )
        playerName:setText(trimtext(Engine.GetDvarString("ui_mapvote_player_".. player.id .."_name"), CoD.TextSettings.H1TitleFont.Font, 16, 235))
        voteStatus:setText(player.hasVoted and "Voted" or "Waiting...")
        votedGlow:setAlpha(player.hasVoted and 0.4 or 0)
    end)

    return container
end
