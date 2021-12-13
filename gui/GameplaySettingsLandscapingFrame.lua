---@class GameplaySettingsLandscapingFrame
---@field enableBetterCamera CheckedOptionElement
---@field disableMouseCollision CheckedOptionElement
---@field hardness TextInputElement
---@field strengthRaiseLower TextInputElement
---@field strengthFlatten TextInputElement
---@field strengthSmooth TextInputElement
---@field strengthSlope TextInputElement
---@field costFactor TextInputElement
---@field disableAccessCheck CheckedOptionElement
---@field disableWaterlevelCheck CheckedOptionElement
---@field disableOverlapWithObjectsCheck CheckedOptionElement
---@field boxLayout BoxLayoutElement
GameplaySettingsLandscapingFrame = {}

local GameplaySettingsLandscapingFrame_mt = Class(GameplaySettingsLandscapingFrame, TabbedMenuFrameElement)

GameplaySettingsLandscapingFrame.CONTROLS = {
    'enableBetterCamera',
    'disableMouseCollision',
    'hardness',
    'strengthRaiseLower',
    'strengthFlatten',
    'strengthSmooth',
    'strengthSlope',

    'costFactor',
    'disableAccessCheck',
    'disableWaterlevelCheck',
    'disableOverlapWithObjectsCheck',

    'boxLayout',
}

function GameplaySettingsLandscapingFrame.new(target, customMt)
    local self = TabbedMenuFrameElement.new(target, customMt or GameplaySettingsLandscapingFrame_mt)

    self:registerControls(GameplaySettingsLandscapingFrame.CONTROLS)

    return self
end

function GameplaySettingsLandscapingFrame:initialize()
    self.backButtonInfo = {
        inputAction = InputAction.MENU_BACK
    }
end

function GameplaySettingsLandscapingFrame:onFrameOpen()
    GameplaySettingsLandscapingFrame:superClass().onFrameOpen(self)
    self:updateGameplaySettings()

    self.boxLayout:invalidateLayout()

	if FocusManager:getFocusedElement() == nil then
		self:setSoundSuppressed(true)
		FocusManager:setFocus(self.boxLayout)
		self:setSoundSuppressed(false)
	end
end

function GameplaySettingsLandscapingFrame:updateGameplaySettings()
    self.disableMouseCollision:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'disableMouseCollision'))
    self.enableBetterCamera:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'enableBetterCamera'))

    self.disableAccessCheck:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'disableAccessCheck'))
    self.disableWaterlevelCheck:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'disableWaterlevelCheck'))
    self.disableOverlapWithObjectsCheck:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'disableOverlapWithObjectsCheck'))

    self:setElementText(self.hardness, g_advancedGameplaySettings:getTypeNameValue('landscaping', 'hardness'))
    self:setElementText(self.strengthRaiseLower, g_advancedGameplaySettings:getTypeNameValue('landscaping', 'strengthRaiseLower'))
    self:setElementText(self.strengthFlatten, g_advancedGameplaySettings:getTypeNameValue('landscaping', 'strengthFlatten'))
    self:setElementText(self.strengthSmooth, g_advancedGameplaySettings:getTypeNameValue('landscaping', 'strengthSmooth'))
    self:setElementText(self.strengthSlope, g_advancedGameplaySettings:getTypeNameValue('landscaping', 'strengthSlope'))
    self:setElementText(self.costFactor, g_advancedGameplaySettings:getTypeNameValue('landscaping', 'costFactor'))
end

function GameplaySettingsLandscapingFrame:setElementText(element, value)
    element:setText(string.format('%.2f', value))
end

---@param state number
---@param element CheckedOptionElement
function GameplaySettingsLandscapingFrame:onCheckClick(state, element)
    g_advancedGameplaySettings:setTypeNameValue('landscaping', element.id, state == CheckedOptionElement.STATE_CHECKED)
end

---@param element TextInputElement
function GameplaySettingsLandscapingFrame:onEnterPressedTextInput(element)
    local value = tonumber(element.text)

    if value ~= nil then
        if element.id == 'costFactor' then
            if value < 0 then
                value = 0
            end
        else
            if value < 0.01 then
                value = 0.01
            end
        end
        g_advancedGameplaySettings:setTypeNameValue('landscaping', element.id, value)
    end

    self:setElementText(element, g_advancedGameplaySettings:getTypeNameValue('landscaping', element.id))
end