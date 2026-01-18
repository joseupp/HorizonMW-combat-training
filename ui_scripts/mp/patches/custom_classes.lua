if Engine.InFrontend() then
    return
end

local getclasscount = Cac.GetCustomClassCount
Cac.GetCustomClassCount = function(...)
    local value = Engine.GetDvarBool("sv_disableCustomClasses")
    if (value) then
        return 0
    end

    return getclasscount(...)
end

local og_func = LUI.MenuBuilder.m_types_build["class_select_main"]

LUI.MenuBuilder.m_types_build["class_select_main"] = function(f13_arg0, f13_arg1)
	local res = og_func(f13_arg0, f13_arg1)
	
	hudextras:showvoicemessage()

	return res
end
