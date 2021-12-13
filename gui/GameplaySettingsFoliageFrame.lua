---@class GameplaySettingsFoliageFrame
---@field disableAccessCheck CheckedOptionElement
---@field disableWaterlevelCheck CheckedOptionElement
---@field costFactor TextInputElement
---@field boxLayout BoxLayoutElement
GameplaySettingsFoliageFrame = {}

local GameplaySettingsFoliageFrame_mt = Class(GameplaySettingsFoliageFrame, TabbedMenuFrameElement)

GameplaySettingsFoliageFrame.CONTROLS = {
    'costFactor',
    'disableAccessCheck',
    'disableWaterlevelCheck',

    'boxLayout'
}

function GameplaySettingsFoliageFrame.new(target, customMt)
    local self = TabbedMenuFrameElement.new(target, customMt or GameplaySettingsFoliageFrame_mt)

    self:registerControls(GameplaySettingsFoliageFrame.CONTROLS)

    return self
end

function GameplaySettingsFoliageFrame:initialize()
    self.backButtonInfo = {
        inputAction = InputAction.MENU_BACK
    }
end

function GameplaySettingsFoliageFrame:onFrameOpen()
    GameplaySettingsFoliageFrame:superClass().onFrameOpen(self)
    self:updateGameplaySettings()

    self.boxLayout:invalidateLayout()

	if FocusManager:getFocusedElement() == nil then
		self:setSoundSuppressed(true)
		FocusManager:setFocus(self.boxLayout)
		self:setSoundSuppressed(false)
	end
end

function GameplaySettingsFoliageFrame:updateGameplaySettings()
    self.disableAccessCheck:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('foliage', 'disableAccessCheck'))
    self.disableWaterlevelCheck:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('foliage', 'disableWaterlevelCheck'))

    self:setElementText(self.costFactor, g_advancedGameplaySettings:getTypeNameValue('foliage', 'costFactor'))
end

function GameplaySettingsFoliageFrame:setElementText(element, value)
    element:setText(string.format('%.2f', value))
end

---@param state number
---@param element CheckedOptionElement
function GameplaySettingsFoliageFrame:onCheckClick(state, element)
    g_advancedGameplaySettings:setTypeNameValue('foliage', element.id, state == CheckedOptionElement.STATE_CHECKED)
end


---@param element TextInputElement
function GameplaySettingsFoliageFrame:onEnterPressedTextInput(element)
    local value = tonumber(element.text)

    if value ~= nil then
        if value < 0 then
            value = 0
        end
        g_advancedGameplaySettings:setTypeNameValue('foliage', element.id, value)
    end

    self:setElementText(element, g_advancedGameplaySettings:getTypeNameValue('foliage', element.id))
end