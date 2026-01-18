require('utils')

function CreateMap(id)
    local map = Engine.GetDvarString('ui_mapvote_name_' .. id) or ""
    local mode = Engine.GetDvarString('ui_mapvote_mode_' .. id) or ""

    local container = LUI.UIElement.new({
        width = 300,
        height = 150
    })

    local background = LUI.UIImage.new({
        topAnchor = true,
        rightAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        material = RegisterMaterial(id < 2 and Utils.getLoadscreen(map) or 'ui_mapvote_random'),
        alpha = 1
    })

    local infoContainer = LUI.UIElement.new({
        bottomAnchor = true,
        rightAnchor = true,
        leftAnchor = true,
        height = 26,
    })

    local infoBg = LUI.UIImage.new({
        topAnchor = true,
        rightAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        material = RegisterMaterial("black"),
        alpha = 0.5
    })

    local label = LUI.UIText.new({
        bottomAnchor = true,
        leftAnchor = true,
        bottom = -6,
        left = 6,
        width = 70,
        height = 14,
        color = Colors.white,
        font = CoD.TextSettings.H1TitleFont.Font
    })

    local votes = LUI.UIText.new({
        bottomAnchor = true,
        rightAnchor = true,
        bottom = -6,
        right = -6,
        width = 70,
        height = 14,
        color = Colors.white,
        font = CoD.TextSettings.H1TitleFont.Font
    })

    label:setText(id < 2 and (Utils.formatMapName(map) .. ' - ' .. Utils.formatGameMode(mode)) or 'Random')
    votes:setText(0)

    container:addElement(background)
    container:addElement(infoContainer)

    local updateVote = function(event, element)
        local voteId = element.data[1]
        local numVotes = element.data[2]

        if not voteId or not numVotes then
            return
        end

        if voteId == id then
            votes:setText(numVotes)
        end
    end

    local onVoteClick = function(event, element)
        Engine.PlaySound(CoD.SFX.MouseClick)
        Engine.NotifyServer("mapvote", id)
    end

    container.m_requireFocusType = FocusType.MouseOver
    container:setHandleMouseButton(true)
    container:setHandleMouseMove(true)
    container:registerEventHandler("mapvote", updateVote)
    container:registerEventHandler("leftmousedown", onVoteClick)

    infoContainer:addElement(infoBg)
    infoContainer:addElement(label)
    infoContainer:addElement(votes)

    return container
end
