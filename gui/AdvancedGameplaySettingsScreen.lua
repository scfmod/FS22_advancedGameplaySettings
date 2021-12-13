---@class AdvancedGameplaySettingsScreen
---@field pageOptionsVehicle GameplaySettingsVehicleFrame
---@field pageOptionsPlaceable GameplaySettingsPlaceableFrame
---@field pageOptionsFoliage GameplaySettingsFoliageFrame
---@field pageOptionsPaint GameplaySettingsPaintFrame
---@field pageOptionsLandscaping GameplaySettingsFoliageFrame
AdvancedGameplaySettingsScreen = {}
local AdvancedGameplaySettingsScreen_mt = Class(AdvancedGameplaySettingsScreen, TabbedMenuWithDetails)

AdvancedGameplaySettingsScreen.CONTROLS = {
    'pageOptionsVehicle',
    'pageOptionsPlaceable',
    'pageOptionsPaint',
    'pageOptionsFoliage',
    'pageOptionsLandscaping',
}

function AdvancedGameplaySettingsScreen.new(target, customMt, messageCenter, l10n, inputManager)
    local self = TabbedMenuWithDetails.new(target, customMt or AdvancedGameplaySettingsScreen_mt, messageCenter, l10n, inputManager)

    self:registerControls(AdvancedGameplaySettingsScreen.CONTROLS)

    return self
end

function AdvancedGameplaySettingsScreen:onGuiSetupFinished()
    AdvancedGameplaySettingsScreen:superClass().onGuiSetupFinished(self)

    self.clickBackCallback = self:makeSelfCallback(self.onButtonBack)

    self.pageOptionsVehicle:initialize()
    self.pageOptionsPaint:initialize()
    self.pageOptionsFoliage:initialize()
    self.pageOptionsLandscaping:initialize()

	self:setupPages()
	self:setupMenuButtonInfo()
end

function AdvancedGameplaySettingsScreen:setupPages()
    local pages = {
        {
            self.pageOptionsVehicle,
            'tab_vehicle.png'
        },
        {
            self.pageOptionsLandscaping,
            'tab_landscaping.png'
        },
        {
            self.pageOptionsFoliage,
            'tab_foliage.png'
        },
        {
            self.pageOptionsPaint,
            'tab_paint.png'
        },
        {
            self.pageOptionsPlaceable,
            'tab_placeable.png'
        },
    }

    for i, _page in ipairs(pages) do
        local page, icon = unpack(_page)
        self:registerPage(page, i)
        self:addPageTab(page, g_advancedGameplaySettings.modFolder .. 'icons/' .. icon)
    end


    -- For using UVs:

    -- for i, pageDef in ipairs(pages) do
    --     local page, iconUVs = unpack(pageDef)

    --     self:registerPage(page, i)

    --     local normalizedUVs = GuiUtils.getUVs(iconUVs)
    --     self:addPageTab(page, g_iconsUIFilename, normalizedUVs)
    -- end
end

function AdvancedGameplaySettingsScreen:setupMenuButtonInfo()
    local onButtonBackFunction = self.clickBackCallback
    self.defaultMenuButtonInfo = {
		{
			inputAction = InputAction.MENU_BACK,
			text = self.l10n:getText(InGameMenu.L10N_SYMBOL.BUTTON_BACK),
			callback = onButtonBackFunction
		}
	}
    self.defaultMenuButtonInfoByActions[InputAction.MENU_BACK] = self.defaultMenuButtonInfo[1]
    self.defaultButtonActionCallbacks = {
		[InputAction.MENU_BACK] = onButtonBackFunction,
	}
end

function AdvancedGameplaySettingsScreen:exitMenu()
    self:changeScreen()
end