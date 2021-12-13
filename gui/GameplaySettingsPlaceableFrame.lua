---@class GameplaySettingsPlaceableFrame
---@field costFactor TextInputElement
---@field displacementCostFactor TextInputElement
---@field disableAccessCheck CheckedOptionElement
---@field enableOverlapWithObjects CheckedOptionElement
---@field disablePaintOperation CheckedOptionElement
---@field disableTerrainDisplacement CheckedOptionElement
---@field disableRemoveFoliage CheckedOptionElement
---@field boxLayout BoxLayoutElement
GameplaySettingsPlaceableFrame = {}

local GameplaySettingsPlaceableFrame_mt = Class(GameplaySettingsPlaceableFrame, TabbedMenuFrameElement)

GameplaySettingsPlaceableFrame.CONTROLS = {
    'costFactor',
    'displacementCostFactor',
    'disableAccessCheck',
    'enableOverlapWithObjects',
    'disablePaintOperation',
    'disableTerrainDisplacement',
    'disableRemoveFoliage',

    'boxLayout'
}

function GameplaySettingsPlaceableFrame.new(target, customMt)
    local self = TabbedMenuFrameElement.new(target, customMt or GameplaySettingsPlaceableFrame_mt)

    self:registerControls(GameplaySettingsPlaceableFrame.CONTROLS)

    return self
end

function GameplaySettingsPlaceableFrame:initialize()
    self.backButtonInfo = {
        inputAction = InputAction.MENU_BACK
    }
end

function GameplaySettingsPlaceableFrame:onFrameOpen()
    GameplaySettingsPlaceableFrame:superClass().onFrameOpen(self)
    self:updateGameplaySettings()

    self.boxLayout:invalidateLayout()

	if FocusManager:getFocusedElement() == nil then
		self:setSoundSuppressed(true)
		FocusManager:setFocus(self.boxLayout)
		self:setSoundSuppressed(false)
	end
end

function GameplaySettingsPlaceableFrame:updateGameplaySettings()
    self.disableAccessCheck:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableAccessCheck'))
    self.enableOverlapWithObjects:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('placeable', 'enableOverlapWithObjects'))
    self.disablePaintOperation:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disablePaintOperation'))
    self.disableTerrainDisplacement:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableTerrainDisplacement'))
    self.disableRemoveFoliage:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableRemoveFoliage'))

    self.disablePaintOperation:setVisible(false)

    self:setElementText(self.costFactor, g_advancedGameplaySettings:getTypeNameValue('placeable', 'costFactor'))
    self:setElementText(self.displacementCostFactor, g_advancedGameplaySettings:getTypeNameValue('placeable', 'displacementCostFactor'))
end

function GameplaySettingsPlaceableFrame:setElementText(element, value)
    element:setText(string.format('%.2f', value))
end

---@param state number
---@param element CheckedOptionElement
function GameplaySettingsPlaceableFrame:onCheckClick(state, element)
    g_advancedGameplaySettings:setTypeNameValue('placeable', element.id, state == CheckedOptionElement.STATE_CHECKED)
end

---@param element TextInputElement
function GameplaySettingsPlaceableFrame:onEnterPressedTextInput(element)
    local value = tonumber(element.text)

    if value ~= nil then
        if value < 0 then
            value = 0
        end
        g_advancedGameplaySettings:setTypeNameValue('placeable', element.id, value)
    end

    element:setText(string.format('%.2f', g_advancedGameplaySettings:getTypeNameValue('placeable', element.id)))
end