---@class GameplaySettingsVehicleFrame
---@field enableFrontloaderFix CheckedOptionElement
---@field disableCameraCollision CheckedOptionElement
-----@field fuelUsageFactor TextInputElement NOT UN USE
---@field wearFactor TextInputElement
---@field repairCostFactor TextInputElement
---@field buttonRepairAllVehicles ButtonElement
---@field repaintCostFactor TextInputElement
---@field buttonRepaintAllVehicles ButtonElement
---@field boxLayout BoxLayoutElement
GameplaySettingsVehicleFrame = {}

local GameplaySettingsVehicleFrame_mt = Class(GameplaySettingsVehicleFrame, TabbedMenuFrameElement)

GameplaySettingsVehicleFrame.CONTROLS = {
    'enableFrontloaderFix',
    'disableCameraCollision',
    -- 'fuelUsageFactor',
    'wearFactor',
    'repairCostFactor',
    'buttonRepairAllVehicles',
    'repaintCostFactor',
    'buttonRepaintAllVehicles',


    'boxLayout'
}

function GameplaySettingsVehicleFrame.new(target, customMt)
    local self = TabbedMenuFrameElement.new(target, customMt or GameplaySettingsVehicleFrame_mt)

    self:registerControls(GameplaySettingsVehicleFrame.CONTROLS)

    return self
end

function GameplaySettingsVehicleFrame:initialize()
    self.backButtonInfo = {
        inputAction = InputAction.MENU_BACK
    }

    -- We have to manually link the focus order of the button
    -- beforeElement -> button -> afterElement
    -- beforeElement <- button <- afterElement

    local beforeElement = self.repairCostFactor
    local afterElement = self.repaintCostFactor
    FocusManager:linkElements(self.buttonRepairAllVehicles, FocusManager.BOTTOM, beforeElement)
    FocusManager:linkElements(self.buttonRepairAllVehicles, FocusManager.TOP, afterElement)

    beforeElement = self.repairCostFactor
    afterElement = self.enableFrontloaderFix
    FocusManager:linkElements(self.buttonRepaintAllVehicles, FocusManager.BOTTOM, beforeElement)
    FocusManager:linkElements(self.buttonRepaintAllVehicles, FocusManager.TOP, afterElement)
end

function GameplaySettingsVehicleFrame:onFrameOpen()
    GameplaySettingsVehicleFrame:superClass().onFrameOpen(self)
    self:updateGameplaySettings()

    self.boxLayout:invalidateLayout()

	if FocusManager:getFocusedElement() == nil then
		self:setSoundSuppressed(true)
		FocusManager:setFocus(self.boxLayout)
		self:setSoundSuppressed(false)
	end
end

function GameplaySettingsVehicleFrame:updateGameplaySettings()
    self.enableFrontloaderFix:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('vehicle', 'enableFrontloaderFix'))
    self.disableCameraCollision:setIsChecked(g_advancedGameplaySettings:getTypeNameValue('vehicle', 'disableCameraCollision'))

    -- self:setElementText(self.fuelUsageFactor,g_advancedGameplaySettings:getTypeNameValue('vehicle', 'fuelUsageFactor') )
    self:setElementText(self.wearFactor, g_advancedGameplaySettings:getTypeNameValue('vehicle', 'wearFactor'))
    self:setElementText(self.repairCostFactor, g_advancedGameplaySettings:getTypeNameValue('vehicle', 'repairCostFactor'))
    self:setElementText(self.repaintCostFactor, g_advancedGameplaySettings:getTypeNameValue('vehicle', 'repaintCostFactor'))

    self.buttonRepairAllVehicles:setImageFilename(nil, g_advancedGameplaySettings.modFolder .. 'icons/button_repair.png')
    self.buttonRepairAllVehicles.icon.uvs = Overlay.DEFAULT_UVS

    self.buttonRepaintAllVehicles:setImageFilename(nil, g_advancedGameplaySettings.modFolder .. 'icons/button_repaint.png')
    self.buttonRepaintAllVehicles.icon.uvs = Overlay.DEFAULT_UVS
end

function GameplaySettingsVehicleFrame:setElementText(element, value)
    element:setText(string.format('%.2f', value))
end

---@param state number
---@param element CheckedOptionElement
function GameplaySettingsVehicleFrame:onCheckClick(state, element)
    g_advancedGameplaySettings:setTypeNameValue('vehicle', element.id, state == CheckedOptionElement.STATE_CHECKED)
end

---@param element TextInputElement
function GameplaySettingsVehicleFrame:onEnterPressedTextInput(element)
    local value = tonumber(element.text)

    if value ~= nil then
        if value < 0 then
            value = 0
        end
        g_advancedGameplaySettings:setTypeNameValue('vehicle', element.id, value)
    end

    self:setElementText(element, g_advancedGameplaySettings:getTypeNameValue('vehicle', element.id))
end

function GameplaySettingsVehicleFrame:onClickRepairAllVehicles()
    g_advancedGameplaySettings:repairAllVehicles()
end

function GameplaySettingsVehicleFrame:onClickRepaintAllVehicles()
    g_advancedGameplaySettings:repaintAllVehicles()
end