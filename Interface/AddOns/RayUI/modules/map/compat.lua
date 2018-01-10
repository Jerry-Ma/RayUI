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
    self:SetPoint("TOPLEFT", R.UIParent, "TOPLEFT", 10, -20)
    self:SetPoint("TOPRIGHT", R.UIParent, "TOPLEFT", 10 + width, -20)
end

local function UseCarbiniteLayout(use)
    if use then
        -- additional settings for the button dock if enable
        if Nx.db.profile.WinSettings.NxMapDock == nil then
            Nx.db.profile.WinSettings.NxMapDock = {}
        end
        if Nx.db.profile.WinSettings.NxMap1 == nil then
            Nx.db.profile.WinSettings.NxMap1 = {}
        end
        Nx.db.profile.WinSettings.NxMapDock['X'] = 0
        Nx.db.profile.WinSettings.NxMapDock['Y'] = 60
        Nx.db.profile.WinSettings.NxMap1['X'] = 45
        Nx.db.profile.WinSettings.NxMap1['Y'] = 40
    else
        -- here we just ignore if this fails
        if pcall(function()
            Nx.db.profile.WinSettings.NxMapDock['X'] = Nx.db.profile.WinSettings.NxMapDock['_X']
            Nx.db.profile.WinSettings.NxMapDock['Y'] = Nx.db.profile.WinSettings.NxMapDock['_Y']
            Nx.db.profile.WinSettings.NxMap1['X'] = Nx.db.profile.WinSettings.NxMap1['_X']
            Nx.db.profile.WinSettings.NxMap1['Y'] = Nx.db.profile.WinSettings.NxMap1['_Y']
        end) then else end
    end
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
        UseCarbiniteLayout(not self.db.enable)
    end)
    -- deal with the expbar
    -- misc module is initialized later so we need to make this a hook
    MM:SecureHook(R, 'InitializeModules', function(self)
        if MM.db.enable then
            MM:Unhook(RayUIExpBar, 'OnShow')
            RayUIExpBar:Hide()
            RayUIExpBar:Show()
        else
            MM:RawHookScript(RayUIExpBar, 'OnShow', OnShowExpBarWithoutMiniMap)
            -- need this to make it apear at correct position
            OnShowExpBarWithoutMiniMap(RayUIExpBar)
        end
    end)
end


function MM:Compat_UseCarboniteMap(use, reload)
    -- copied from Nx.Opts.mapConfig of Carbonite 7.3
    Nx.db.profile.MiniMap.Own = use
    Nx.db.profile.MiniMap.ButOwn = use  -- button collector
    -- finish up the setting
    MM:Compat_NXCmdMMOwnChangeNoReload(_,Nx.db.profile.MiniMap.Own)
    -- setup positioning
    UseCarbiniteLayout(use)
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
