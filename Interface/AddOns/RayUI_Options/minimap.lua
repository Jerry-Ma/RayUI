----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("MiniMap")


local MM = _MiniMap

R.Options.args.MiniMap = {
    type = "group",
    name = (MM.modName or MM:GetName()),
    order = 14,
    get = function(info)
        return R.db.MiniMap[ info[#info] ]
    end,
    set = function(info, value)
        R.db.MiniMap[ info[#info] ] = value
        StaticPopup_Show("CFG_RELOAD")
    end,
    args = {
        header = {
            type = "header",
            name = MM.modName or MM:GetName(),
            order = 1
        },
        description = {
            type = "description",
            name = "\n\n",
            order = 2
        },
        -- enable = {
        --     type = "toggle",
        --     name = MM.toggleLabel or (L["启用"] .. (MM.modName or MM:GetName())),
        --     width = "double",
        --     desc = MM.Info and MM:Info() or (L["启用"] .. (MM.modName or MM:GetName())),
        --     order = 3,
        -- },
        usecarbonitemap = {
            type = "toggle",
            name = "Integrate into Carbonite Map",
            width = "double",
            desc = "Disable MiniMap module and let Carbonite Map handle it",
            order = 4,
            hidden = function()
                return not IsAddOnLoaded("Carbonite")
            end,
            -- make this a proxy of MM.db.enable
            set = function(info, value)
                MM.db.enable = not value
                -- set up Carbonite stuff
                MM:Compat_UseCarboniteMap(value, true)
            end,
            get = function(info, value)
                return not MM.db.enable
            end,
        },
    }
}
