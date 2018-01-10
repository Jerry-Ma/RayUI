----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv("MiniMap")


local MM = _MiniMap
local Nx = Nx

function MM:Compat_IsUseCarboniteMap()
    return Nx.db.profile.MiniMap.Own
end

local function OnShowExpBarWithoutMiniMap(self)
    width = Minimap:GetWidth()
    self:SetPoint("TOPLEFT", AurasHolder, "TOPRIGHT", - width, 40)
    self:SetPoint("TOPRIGHT", AurasHolder, "TOPRIGHT", 0, 40)
end

if Nx == nil then
    MM:Hook(MM, 'Initialize', function(self)
        -- restore MM.db.enable
        self.db.enable = true
    end)
    return
else
    MM:Hook(MM, 'Initialize', function(self)
        self.db.enable = not MM:Compat_IsUseCarboniteMap()
        if not self.db.enable then
            R:Print("MiniMap module is disabled because Carbonite minimap integration is enabled.")
        end
    end)
    -- deal with the expbar to act with respect to the minimap
    -- minimap module is initialized later so we need to make this a hook
    hooksecurefunc(R, 'InitializeModules', function(self)
        EB = R:GetModule("Misc"):GetModule("Exprepbar")
        R:Print(MiniMap)
        R:Print(RayUIExpBar)
        MM:RawHookScript(RayUIExpBar, 'OnShow', OnShowExpBarWithoutMiniMap)
        -- need this to make it apear at correct position
        OnShowExpBarWithoutMiniMap(RayUIExpBar)
    end)
end

function MM:Compat_UseCarboniteMap(use, reload)
    -- fire up the Nx mmown change
    -- copied from Nx.Opts.mapConfig of Carbonite 7.3
    Nx.db.profile.MiniMap.Own = use
    MM:Compat_NXCmdMMOwnChangeNoReload(_,Nx.db.profile.MiniMap.Own)
    if reload then
        if use then
            StaticPopup_Show('COMPAT_USECARBONITEMAP_RELOAD')
        else
            StaticPopup_Show('COMPAT_NOTUSECARBONITEMAP_RELOAD')
        end
    end
end

-- copied from Nx.Opts.NXCmdMMOwnChange of Carbonite 7.3
function MM:Compat_NXCmdMMOwnChangeNoReload(item, var)
	Nx.db.profile.MiniMap.ShowOldNameplate = not var		-- Nameplate is opposite of integration
	Nx.db.profile.MiniMap.ButOwn = var
	Nx.Opts:Update()
end

-- Make Carbonite setting aware of RayUI
MM:RawHook(Nx.Opts, 'NXCmdMMOwnChange', function(self, item, var)
    MM.db.enable = not var
    if var then
        MM:Compat_NXCmdMMOwnChangeNoReload(item, var)
        StaticPopup_Show('COMPAT_USECARBONITEMAP_RELOAD')
    else
        return MM.hooks[Nx.Opts]['NXCmdMMOwnChange'](item, var)
    end
end)

StaticPopupDialogs["COMPAT_USECARBONITEMAP_RELOAD"] = {
    text = "Enabling this will disable RayUI minimap module, proceed?",
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function() ReloadUI() end,
    timeout = 0,
    whileDead = 1,
}

StaticPopupDialogs["COMPAT_NOTUSECARBONITEMAP_RELOAD"] = {
    text = "Disabling this will disable Carbonite MiniMap integration, proceed?",
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function() ReloadUI() end,
    timeout = 0,
    whileDead = 1,
}
