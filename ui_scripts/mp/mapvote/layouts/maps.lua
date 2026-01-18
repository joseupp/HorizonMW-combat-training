require('components.map')

local MAX_MAPS = 2 -- 3

function CreateMapList()
    local container = LUI.UIVerticalList.new({
        topAnchor = true,
        leftAnchor = true,
        top = 120,
        left = -40,
        width = 380,
        height = 480,
        spacing = 15,
    })

    container.id = 'mv_container'

    for i = 0, MAX_MAPS do
        container:addElement(CreateMap(i))
    end

    return container
end
