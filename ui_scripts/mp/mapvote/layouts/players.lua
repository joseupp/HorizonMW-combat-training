require('components.player')

function CreatePlayerList()
    local container = LUI.UIVerticalList.new({
        topAnchor = true,
        rightAnchor = true,
        top = 120,
        right = 2,
        width = 660,
        height = 396,
        spacing = 16
    })

    -- local containerBg = LUI.UIImage.new({
    --     topAnchor = true,
    --     rightAnchor = true,
    --     bottomAnchor = true,
    --     leftAnchor = true,
    --     material = RegisterMaterial("white"),
    --     color = luiglobals.Colors.white,
    --     alpha = 0.2
    -- })

    container.id = 'mv_player_container'

    local label = LUI.UIText.new({
        rightAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        bottom = -5,
        height = 20,
        color = Colors.white,
        font = CoD.TextSettings.H1TitleFont.Font
    })

    local listContainer = LUI.UIHorizontalList.new({
        topAnchor = true,
        rightAnchor = true,
        bottomAnchor = true,
        leftAnchor = true,
        spacing = 26
    })

    listContainer.id = 'mv_player_list_container'

    local leftColumn = LUI.UIVerticalList.new({
        topAnchor = true,
        bottomAnchor = true,
        width = 300,
        spacing = 6
    })

    leftColumn.id = 'mv_player_list_left_container'

    local rightColumn = LUI.UIVerticalList.new({
        topAnchor = true,
        bottomAnchor = true,
        width = 300,
        spacing = 6
    })

    rightColumn.id = 'mv_player_list_right_container'

    -- container:addElement(containerBg)
    container:addElement(label)
    container:addElement(listContainer)

    listContainer:addElement(leftColumn)
    listContainer:addElement(rightColumn)

    label:setText('Players ('.. Engine.GetDvarInt('ui_mapvote_currentclients') ..'/'.. Engine.GetDvarInt('ui_mapvote_maxclients') ..')')

    local timer = LUI.UITimer.new(100, 'updatePlayerCount')
    container:addElement(timer)

    container:addEventHandler('updatePlayerCount', function()
        label:setText('Players ('.. Engine.GetDvarInt('ui_mapvote_currentclients') ..'/'.. Engine.GetDvarInt('ui_mapvote_maxclients') ..')')
    end)

    for id = 1, Engine.GetDvarInt('ui_mapvote_maxclients'), 1 do
        local player = {}
        player.name = Engine.GetDvarString('ui_mapvote_player_'..id..'_name')
        player.hasVoted = Engine.GetDvarBool('ui_mapvote_player_'..id..'_voted')
        player.id = id

        local element = CreatePlayer(player)

        if id % 2 == 0 then
            rightColumn:addElement(element)
        else
            leftColumn:addElement(element)
        end
    end

    return container
end
