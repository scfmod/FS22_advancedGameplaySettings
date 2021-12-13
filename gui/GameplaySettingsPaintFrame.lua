---@class GameplaySettingsPaintFrame
---@field disableAccessCheck CheckedOptionElement
---@field disableWaterlevelCheck CheckedOptionElement
---@field costFactor TextInputElement
---@field boxLayout BoxLayoutElement
GameplaySettingsPaintFrame = {}

local GameplaySettingsPaintFrame_mt = Class(GameplaySettingsPaintFrame, TabbedMenuFrameElement)

GameplaySettingsPaintFrame.CONTROLS = {
    'costFactor',
    'disableAccessCheck',
    'disableWaterlevelCheck',

    'boxLayout'
}

function GameplaySettingsPaintFrame.new(target, customMt)
    local self = TabbedMenuFrameElement.new(target, customMt or GameplaySettingsPaintFrame_mt)

    self:registerControls(GameplaySettingsPaintFrame.CONTROLS)

    return self
end

function GameplaySettingsPaintFrame:initialize()
    self.backButtonInfo = {
        inputAction = InputAction.MENU_BACK
    }
end

function GameplaySettingsPaintFrame:onFrameOpen()
    GameplaySettingsPaintFrame:superClass().onFrameOpen(self)
    self:updateGameplaySettings()

    self.boxLayout:invalidateLayout()

	if FocusManager:getFocusedElement() == nil then
		self:setSoundSuppressed(true)
		FocusManager:setFocus(self.boxLayout)
		self:setSoundSuppressed(false)
	end
end

function GameplaySettingsPaintFrame:updateGameplaySettings()
    self.disableAccessCheck:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('paint', 'disableAccessCheck'))
    self.disableWaterlevelCheck:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('paint', 'disableWaterlevelCheck'))

    self:setElementText(self.costFactor, g_advancedGameplaySettings:getTypeNameValue('paint', 'costFactor'))
end

function GameplaySettingsPaintFrame:setElementText(element, value)
    element:setText(string.format('%.2f', value))
end

---@param state number
---@param element CheckedOptionElement
function GameplaySettingsPaintFrame:onCheckClick(state, element)
    g_advancedGameplaySettings:setTypeNameValue('paint', element.id, state == CheckedOptionElement.STATE_CHECKED)
end

---@param element TextInputElement
function GameplaySettingsPaintFrame:onEnterPressedTextInput(element)
    local value = tonumber(element.text)

    if value ~= nil then
        if value < 0 then
            value = 0
        end
        g_advancedGameplaySettings:setTypeNameValue('paint', element.id, value)
    end

    self:setElementText(element, g_advancedGameplaySettings:getTypeNameValue('paint', element.id))
end