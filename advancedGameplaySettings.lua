--[[
    AdvancedGameplaySettings

    author: scfmod
    url:    https://github.com/scfmod/FS22_advancedGameplaySettings

    If you distribute this mod, always include this info.

    AND DO NOT UPLOAD IT TO MONATERY UPLOAD SERVICES.
    THIS CODE IS AVAILABLE TO ANYONE FOR FREE AND YOU CAN USE
    IT TO LEARN, FORK AND SPREAD THE KNOWLEDGE.
]]
local modFolder = g_currentModDirectory
source(modFolder .. 'gui/AdvancedGameplaySettingsScreen.lua')
source(modFolder .. 'gui/GameplaySettingsVehicleFrame.lua')
source(modFolder .. 'gui/GameplaySettingsLandscapingFrame.lua')
source(modFolder .. 'gui/GameplaySettingsPlaceableFrame.lua')
source(modFolder .. 'gui/GameplaySettingsFoliageFrame.lua')
source(modFolder .. 'gui/GameplaySettingsPaintFrame.lua')

---@class AdvancedGameplaySettings
---@field modFolder string
AdvancedGameplaySettings = {
    -- Note: Add landscaping options to the landscaping screen
    landscaping = {
        enableBetterCamera = false,
        disableMouseCollision = false,
        hardness = 0.2,
        strengthRaiseLower = 0.5, -- operation = Landscaping.OPERATION.RAISE or Landscaping.OPERATION.LOWER
        strengthFlatten = 0.5,    -- operation = Landscaping.OPERATION.FLATTEN [level]
        strengthSmooth = 1.0,     -- operation = Landscaping.OPERATION.SMOOTH [soften]
        strengthSlope = 5.0,      -- operation = Landscaping.OPERATION.SLOPE

        costFactor = 1.0,
        disableAccessCheck = false,
        disableWaterlevelCheck = false,
        disableOverlapWithObjectsCheck = false,
    },
    foliage = {
        costFactor = 1.0,
        disableAccessCheck = false,
        disableWaterlevelCheck = false,
    },
    paint = {
        costFactor = 1.0,
        disableAccessCheck = false,
        disableWaterlevelCheck = false,
    },
    placeable = {
        costFactor = 1.0,
        displacementCostFactor = 1.0,
        disableAccessCheck = false,
        enableOverlapWithObjects = false,
        disablePaintOperation = false,  -- NO solution for this yet...
        disableTerrainDisplacement = false,
        disableRemoveFoliage = false,
    },
    -- todo missions??
    mission = {},

    vehicle = {
        enableFrontloaderFix = false,
        disableCameraCollision = false,
        fuelUsageFactor = 1.0, -- TODO
        wearFactor = 1.0,
        repairCostFactor = 1.0,
        repaintCostFactor = 1.0,
    },
}


function AdvancedGameplaySettings:loadMap()
    ---@diagnostic disable-next-line: lowercase-global
    g_advancedGameplaySettings = self
    g_advancedGameplaySettings.modFolder = modFolder

    self:loadFromXML()

    GameSettings.saveToXMLFile = Utils.appendedFunction(GameSettings.saveToXMLFile,
        AdvancedGameplaySettings.saveToXML
    )

    -- Load custom GUI presets, profiles
    -- g_gui:loadProfiles(modFolder .. 'xml/guiProfiles.xml')

    ---@diagnostic disable-next-line: lowercase-global
    g_advancedGameplaySettingsScreen = AdvancedGameplaySettingsScreen.new(nil, nil, g_messageCenter, g_i18n, g_inputBinding)

    g_gui:loadGui(modFolder .. 'xml/GameplaySettingsVehicleFrame.xml', 'GameplaySettingsVehicleFrame', GameplaySettingsVehicleFrame.new(nil, nil), true)
    g_gui:loadGui(modFolder .. 'xml/GameplaySettingsLandscapingFrame.xml', 'GameplaySettingsLandscapingFrame', GameplaySettingsLandscapingFrame.new(nil, nil), true)
    g_gui:loadGui(modFolder .. 'xml/GameplaySettingsPlaceableFrame.xml', 'GameplaySettingsPlaceableFrame', GameplaySettingsPlaceableFrame.new(nil, nil), true)
    g_gui:loadGui(modFolder .. 'xml/GameplaySettingsFoliageFrame.xml', 'GameplaySettingsFoliageFrame', GameplaySettingsFoliageFrame.new(nil, nil), true)
    g_gui:loadGui(modFolder .. 'xml/GameplaySettingsPaintFrame.xml', 'GameplaySettingsPaintFrame', GameplaySettingsPaintFrame.new(nil, nil), true)
    g_gui:loadGui(modFolder .. 'xml/AdvancedGameplaySettingsScreen.xml', 'AdvancedGameplaySettingsScreen', g_advancedGameplaySettingsScreen)
end

local function getXMLSettingBool(xmlFile, type, name, default)
    g_advancedGameplaySettings:setTypeNameValue(type,name, Utils.getNoNil(getXMLBool(xmlFile, 'gameplaySettings.' .. type .. '.' .. name), default))
end

local function setXMLSettingBool(xmlFile, type, name)
    local value = g_advancedGameplaySettings:getTypeNameValue(type, name)
    -- if value ~= nil then
        setXMLBool(xmlFile, 'gameplaySettings.' .. type .. '.' .. name, value)
    -- end
end

local function getXMLSettingFloat(xmlFile, type, name, default)
    g_advancedGameplaySettings:setTypeNameValue(type,name, Utils.getNoNil(getXMLFloat(xmlFile, 'gameplaySettings.' .. type .. '.' .. name), default))
end

local function setXMLSettingFloat(xmlFile, type, name)
    local value = g_advancedGameplaySettings:getTypeNameValue(type, name)
    -- if value ~= nil then
        setXMLFloat(xmlFile, 'gameplaySettings.' .. type .. '.' .. name, value)
    -- end
end


function AdvancedGameplaySettings.saveToXML()
    local filePath = g_modSettingsDirectory .. 'advancedGameplaySettings.xml'
    local xmlFile = createXMLFile('advancedGameplaySetting', filePath, 'gameplaySettings')

    if xmlFile == nil or xmlFile == 0 then
        print('AdvancedGameplaySettings.saveToXML: Failed to create XML file')
        return
    end

    -- Landscaping
    setXMLSettingBool(xmlFile, 'landscaping', 'enableBetterCamera')
    setXMLSettingBool(xmlFile, 'landscaping', 'disableMouseCollision')
    setXMLSettingFloat(xmlFile, 'landscaping', 'hardness')
    setXMLSettingFloat(xmlFile, 'landscaping', 'strengthRaiseLower')
    setXMLSettingFloat(xmlFile, 'landscaping', 'strengthFlatten')
    setXMLSettingFloat(xmlFile, 'landscaping', 'strengthSmooth')
    setXMLSettingFloat(xmlFile, 'landscaping', 'strengthSlope')
    setXMLSettingFloat(xmlFile, 'landscaping', 'costFactor')
    setXMLSettingBool(xmlFile, 'landscaping', 'disableAccessCheck')
    setXMLSettingBool(xmlFile, 'landscaping', 'disableWaterlevelCheck')
    setXMLSettingBool(xmlFile, 'landscaping', 'disableOverlapWithObjectsCheck')

    -- Foliage
    setXMLSettingFloat(xmlFile, 'foliage', 'costFactor')
    setXMLSettingBool(xmlFile, 'foliage', 'disableAccessCheck')
    setXMLSettingBool(xmlFile, 'foliage', 'disableWaterlevelCheck')

    -- Paint
    setXMLSettingFloat(xmlFile, 'paint', 'costFactor')
    setXMLSettingBool(xmlFile, 'paint', 'disableAccessCheck')
    setXMLSettingBool(xmlFile, 'paint', 'disableWaterlevelCheck')

    -- Placeable
    setXMLSettingFloat(xmlFile, 'placeable', 'costFactor')
    setXMLSettingFloat(xmlFile, 'placeable', 'displacementCostFactor')
    setXMLSettingBool(xmlFile, 'placeable', 'disableAccessCheck')
    setXMLSettingBool(xmlFile, 'placeable', 'enableOverlapWithObjects')
    setXMLSettingBool(xmlFile, 'placeable', 'disablePaintOperation')
    setXMLSettingBool(xmlFile, 'placeable', 'disableTerrainDisplacement')
    setXMLSettingBool(xmlFile, 'placeable', 'disableRemoveFoliage')

    -- Vehicle
    setXMLSettingBool(xmlFile, 'vehicle', 'enableFrontloaderFix')
    setXMLSettingBool(xmlFile, 'vehicle', 'disableCameraCollision')
    setXMLSettingFloat(xmlFile, 'vehicle', 'wearFactor')
    setXMLSettingFloat(xmlFile, 'vehicle', 'repairCostFactor')
    setXMLSettingFloat(xmlFile, 'vehicle', 'repaintCostFactor')

    print('AdvancedGameplaySettings: Saving XML configuration ..')
    saveXMLFile(xmlFile)
    delete(xmlFile)
end

function AdvancedGameplaySettings:loadFromXML()
    local filePath = g_modSettingsDirectory .. 'advancedGameplaySettings.xml'

    if not fileExists(filePath) then
        return
    end

    local xmlFile = loadXMLFile('advancedGameplaySettings', filePath)
    if xmlFile == nil or xmlFile == 0 then
        print('AdvancedGameplaySettings.loadFromXML: Failed to load XML file')
        return
    end

    -- Landscaping
    getXMLSettingBool(xmlFile, 'landscaping', 'enableBetterCamera', false)
    getXMLSettingBool(xmlFile, 'landscaping', 'disableMouseCollision', false)
    getXMLSettingFloat(xmlFile, 'landscaping', 'hardness', 0.2)
    getXMLSettingFloat(xmlFile, 'landscaping', 'strengthRaiseLower', 0.5)
    getXMLSettingFloat(xmlFile, 'landscaping', 'strengthFlatten', 0.5)
    getXMLSettingFloat(xmlFile, 'landscaping', 'strengthSmooth', 1.0)
    getXMLSettingFloat(xmlFile, 'landscaping', 'strengthSlope', 5.0)
    getXMLSettingFloat(xmlFile, 'landscaping', 'costFactor', 1.0)
    getXMLSettingBool(xmlFile, 'landscaping', 'disableAccessCheck', false)
    getXMLSettingBool(xmlFile, 'landscaping', 'disableWaterlevelCheck', false)
    getXMLSettingBool(xmlFile, 'landscaping', 'disableOverlapWithObjectsCheck', false)

    -- Foliage
    getXMLSettingFloat(xmlFile, 'foliage', 'costFactor', 1.0)
    getXMLSettingBool(xmlFile, 'foliage', 'disableAccessCheck', false)
    getXMLSettingBool(xmlFile, 'foliage', 'disableWaterlevelCheck', false)

    -- Paint
    getXMLSettingFloat(xmlFile, 'paint', 'costFactor', 1.0)
    getXMLSettingBool(xmlFile, 'paint', 'disableAccessCheck', false)
    getXMLSettingBool(xmlFile, 'paint', 'disableWaterlevelCheck', false)

    -- Placeable
    getXMLSettingFloat(xmlFile, 'placeable', 'costFactor', 1.0)
    getXMLSettingFloat(xmlFile, 'placeable', 'displacementCostFactor', 1.0)
    getXMLSettingBool(xmlFile, 'placeable', 'disableAccessCheck', false)
    getXMLSettingBool(xmlFile, 'placeable', 'enableOverlapWithObjects', false)
    getXMLSettingBool(xmlFile, 'placeable', 'disablePaintOperation', false)
    getXMLSettingBool(xmlFile, 'placeable', 'disableTerrainDisplacement', false)
    getXMLSettingBool(xmlFile, 'placeable', 'disableRemoveFoliage', false)

    -- Vehicle
    getXMLSettingBool(xmlFile, 'vehicle', 'enableFrontloaderFix', false)
    getXMLSettingBool(xmlFile, 'vehicle', 'disableCameraCollision', false)

    -- getXMLSettingFloat(xmlFile, 'vehicle', 'fuelUsageFactor', 1.0)
    getXMLSettingFloat(xmlFile, 'vehicle', 'wearFactor', 1.0)
    getXMLSettingFloat(xmlFile, 'vehicle', 'repairCostFactor', 1.0)
    getXMLSettingFloat(xmlFile, 'vehicle', 'repaintCostFactor', 1.0)

    delete(xmlFile)
end

function AdvancedGameplaySettings:updateCameraSettings()
    if self.landscaping.enableBetterCamera ~= true then
        GuiTopDownCamera.ROTATION_MIN_X_FAR = 50
        GuiTopDownCamera.ROTATION_MIN_X_NEAR = 10
    else
        GuiTopDownCamera.ROTATION_MIN_X_FAR = 0
        GuiTopDownCamera.ROTATION_MIN_X_NEAR = 0
    end
end

---@param type string
---@param name string
---@param value any
function AdvancedGameplaySettings:setTypeNameValue(type, name, value)
    AdvancedGameplaySettings[type][name] = value

    if type == 'landscaping' then
        if name == 'enableBetterCamera' then
            self:updateCameraSettings()
        end
    end
end

function AdvancedGameplaySettings:getTypeNameValue(type, name)
    return AdvancedGameplaySettings[type][name]
end

function AdvancedGameplaySettings:keyEvent(unicode, sym, modifier, isDown)
    if not isDown then
        return
    end

    -- keycode for F9
    if sym == 290 then
        g_gui:showGui('AdvancedGameplaySettingsScreen')
    elseif sym == 289 then -- F8 - DEBUGGING TABLE
        DebugUtil.printTableRecursively(g_advancedGameplaySettings)
    end
end

--[[
    Override hardness of landscaping brush tool
]]

function AdvancedGameplaySettings.addTerrainDeformationWorldspaceSoftBrush(func, deformationId, x, z, brushType, radius, hardness, strength, terrainBrushId)
    local overrideHardness = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'hardness'), 0.2)
    func(deformationId, x, z, brushType, radius, overrideHardness, strength, terrainBrushId)
end

---@diagnostic disable-next-line: lowercase-global
addTerrainDeformationWorldspaceSoftBrush = Utils.overwrittenFunction(
    addTerrainDeformationWorldspaceSoftBrush,
    AdvancedGameplaySettings.addTerrainDeformationWorldspaceSoftBrush
)


--[[
    Frontloader fix

    Prevents locking joints when attaching frontloader to your tractor.
]]

---@diagnostic disable-next-line: unused-local
local overrideJointRotLimit = false

FrontloaderAttacher.onPreAttachImplement = Utils.prependedFunction(FrontloaderAttacher.onPreAttachImplement,
    function()
        overrideJointRotLimit = true
    end
)

FrontloaderAttacher.onPreAttachImplement = Utils.appendedFunction(FrontloaderAttacher.onPreAttachImplement,
    function()
        overrideJointRotLimit = false
    end
)

Vehicle.setComponentJointRotLimit = Utils.overwrittenFunction(Vehicle.setComponentJointRotLimit,
    ---@param self Vehicle
    function(self, func, ...)
        if overrideJointRotLimit ~= true and Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('vehicle', 'enableFrontloaderFix'), false) ~= true then
            func(self, ...)
        end
    end
)


--[[
    Disable camera collision when in vehicle

    Okay so this is a gem.. haha
    Basically Giants hardcoded the setting to be only be displayed in General settings UI if there is a mod
    loaded named 'FS22_disableVehicleCameraCollision'.
]]


VehicleCamera.getCollisionDistance = Utils.overwrittenFunction(VehicleCamera.getCollisionDistance,
    function(self, func, ...)
        if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('vehicle', 'disableCameraCollision'), false) ~= true then
            return func(self, ...)
        end

        return false, nil
    end
)


--[[
    Disable mouse collision on objects when landscaping
]]

GuiTopDownCursor.setSelectionMode = Utils.overwrittenFunction(GuiTopDownCursor.setSelectionMode,
    ---@param self GuiTopDownCursor
    function(self, func, isSelection)
        func(self, isSelection)
        if isSelection then
            self.rayCollisionMask = CollisionMask.ALL - CollisionMask.TRIGGERS - CollisionFlag.FILLABLE
        else
            if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'disableMouseCollision'), false) ~= true then
                self.rayCollisionMask = CollisionMask.ALL - CollisionMask.TRIGGERS - CollisionFlag.FILLABLE - CollisionFlag.GROUND_TIP_BLOCKING
            else
                self.rayCollisionMask = CollisionFlag.TERRAIN
            end
        end
    end
)


--[[
    Override sculpting strength
]]

Landscaping.sculpt = Utils.overwrittenFunction(Landscaping.sculpt,
    function(self, func, x, y, z, nx, ny, nz, d, minY, maxY, radius, strength, brushShape, operation, smoothingDistance, terrainPaintingLayer, terrainFoliageLayer, terrainFoliageValue)
        local newStrength = strength

        if operation == Landscaping.OPERATION.SMOOTH then
            newStrength = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'strengthSmooth'), 1.0)
        elseif operation == Landscaping.OPERATION.FLATTEN then
            newStrength = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'strengthFlatten'), 0.5)
        elseif operation == Landscaping.OPERATION.SLOPE then
            newStrength = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'strengthSlope'), 5.0)
        elseif operation == Landscaping.OPERATION.LOWER or operation == Landscaping.OPERATION.RAISE then
            newStrength = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'strengthRaiseLower'), 0.5)
        end

        func(self, x, y, z, nx, ny, nz, d, minY, maxY, radius, newStrength, brushShape, operation, smoothingDistance, terrainPaintingLayer, terrainFoliageLayer, terrainFoliageValue)
    end
)


--[[
    Permission override functions
]]

function AdvancedGameplaySettings.hasPermission(type)
    return function(self, func, ...)
        local override = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue(type, 'disableAccessCheck'), false)

        if override ~= true then
            return func(self, ...)
        end

        return true
    end
end

function AdvancedGameplaySettings.hasAccess(type)
    return function(self, func, ...)
        local override = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue(type, 'disableAccessCheck'), false)

        if override ~= true then
            return func(self, ...)
        end

        return nil
    end
end


--[[
    Landscaping: Override access checks

    Foliage, sculpting, painting
]]


local currentLandscapingOperation = nil

Landscaping.onSculptingValidated = Utils.prependedFunction(Landscaping.onSculptingValidated,
    function(self)
        currentLandscapingOperation = self.sculptingOperation
    end
)

Landscaping.onSculptingValidated = Utils.appendedFunction(Landscaping.onSculptingValidated,
    function()
        currentLandscapingOperation = nil
    end
)

Landscaping.isModificationAreaOnOwnedLand = Utils.overwrittenFunction(Landscaping.isModificationAreaOnOwnedLand,
    function(self, func, ...)
        if currentLandscapingOperation == nil then
            return func(self, ...)
        end

        return true
    end
)

-- FOR OVERRIDING ERROR MESSAGES
-- If we don't include this the error messages will prevent us from utilizing the override functions above

ConstructionBrushPaint.verifyAccess = Utils.overwrittenFunction(ConstructionBrushPaint.verifyAccess,
    AdvancedGameplaySettings.hasAccess('paint')
)
ConstructionBrushPaint.hasPlayerPermission = Utils.overwrittenFunction(ConstructionBrushPaint.hasPlayerPermission,
    AdvancedGameplaySettings.hasPermission('paint')
)

ConstructionBrushSculpt.verifyAccess = Utils.overwrittenFunction(ConstructionBrushSculpt.verifyAccess,
    AdvancedGameplaySettings.hasAccess('landscaping')
)
ConstructionBrushSculpt.hasPlayerPermission = Utils.overwrittenFunction(ConstructionBrushSculpt.hasPlayerPermission,
    AdvancedGameplaySettings.hasPermission('landscaping')
)

ConstructionBrushFoliage.verifyAccess = Utils.overwrittenFunction(ConstructionBrushFoliage.verifyAccess,
    AdvancedGameplaySettings.hasAccess('foliage')
)

ConstructionBrushFoliage.hasPlayerPermission = Utils.overwrittenFunction(ConstructionBrushFoliage.hasPlayerPermission,
    AdvancedGameplaySettings.hasPermission('foliage')
)



--[[
    Override water level validation function
]]

function AdvancedGameplaySettings.validateWaterLevel(self, func, y, strength, operation)
    local override = false

    if operation == Landscaping.OPERATION.FOLIAGE then
        override = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('foliage', 'disableWaterlevelCheck'), false)
    elseif operation == Landscaping.OPERATION.PAINT then
        override = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('paint','disableWaterlevelCheck'), false)
    else -- Sculpt operation
        override = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('landscaping', 'disableWaterlevelCheck'), false)
    end

    if override ~= true then
        return func(self, y, strength, operation)
    end

    return true
end

Landscaping.validateWaterLevel = Utils.overwrittenFunction(Landscaping.validateWaterLevel,
    AdvancedGameplaySettings.validateWaterLevel
)



--[[
    Placeables: Override access checks

    Fence, tree
]]

ConstructionBrushTree.verifyAccess = Utils.overwrittenFunction(ConstructionBrushTree.verifyAccess,
    AdvancedGameplaySettings.hasAccess('placeable')
)
ConstructionBrushTree.hasPlayerPermission = Utils.overwrittenFunction(ConstructionBrushTree.hasPlayerPermission,
    AdvancedGameplaySettings.hasPermission('placeable')
)

ConstructionBrushFence.verifyAccess = Utils.overwrittenFunction(ConstructionBrushFence.verifyAccess,
    AdvancedGameplaySettings.hasAccess('placeable')
)
ConstructionBrushFence.hasPlayerPermission = Utils.overwrittenFunction(ConstructionBrushFence.hasPlayerPermission,
    AdvancedGameplaySettings.hasPermission('placeable')
)



--[[
    Placeable: Override access checks

    Placeable objects, decorations
]]


ConstructionBrushPlaceable.verifyAccess = Utils.overwrittenFunction(ConstructionBrushPlaceable.verifyAccess,
    AdvancedGameplaySettings.hasAccess('placeable')
)

ConstructionBrushPlaceable.hasPlayerPermission = Utils.overwrittenFunction(ConstructionBrushPlaceable.hasPlayerPermission,
    AdvancedGameplaySettings.hasPermission('placeable')
)


--[[
    Landscaping actions

    Override prices
]]

function AdvancedGameplaySettings.getPrice(type)
    return function(self, func, ...)
        local price = func(self, ...)
        local factor = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue(type, 'costFactor'), 1.0)

        return price * factor
    end
end


-- FOLIAGE, PAINTING, SCULPTING

Landscaping.getCost = Utils.overwrittenFunction(
    Landscaping.getCost,
    function(self, func, ...)
        local cost = func(self, ...)

        local type

        if self.sculptingOperation == Landscaping.OPERATION.FOLIAGE then
            type = 'foliage'
        elseif self.sculptingOperation == Landscaping.OPERATION.PAINT then
            type = 'paint'
        else
            type = 'landscaping'
        end

        local factor = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue(type, 'costFactor'), 1.0)

        return cost * factor
    end
)

-- PLACEABLES

Placeable.getPrice = Utils.overwrittenFunction(Placeable.getPrice,
    function(self, func)
        local price = func(self)
        local factor = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'costFactor'), 1.0)

        return price * factor
    end
)

ConstructionBrushPlaceable.getPrice = Utils.overwrittenFunction(ConstructionBrushPlaceable.getPrice,
    AdvancedGameplaySettings.getPrice('placeable')
)

ConstructionBrushPlaceable.getDisplacementCost = Utils.overwrittenFunction(ConstructionBrushPlaceable.getDisplacementCost,
    function(self, func, ...)
        local cost = func(self, ...)
        local factor = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'displacementCostFactor'), 1.0)
        local disableTerrainDisplacement = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableTerrainDisplacement'), false)

        if disableTerrainDisplacement ~= true then
            return cost * factor
        end

        return 0
    end
)

-- To override the price on placeable objects (except for trees and fences) we
-- have to do some stuff with BuyPlaceableEvent and EconomyManager ..

local overrideGetBuyPrice = false

BuyPlaceableEvent.run = Utils.prependedFunction(BuyPlaceableEvent.run,
    function()
        overrideGetBuyPrice = true
    end
)

BuyPlaceableEvent.run = Utils.appendedFunction(BuyPlaceableEvent.run,
    function()
        overrideGetBuyPrice = false
    end
)

EconomyManager.getBuyPrice = Utils.overwrittenFunction(EconomyManager.getBuyPrice,
    function(self, func, ...)
        local price = func(self, ...)

        if overrideGetBuyPrice ~= true then
            return price
        end

        local factor = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'costFactor'), 1.0)

        return price * factor
    end
)

-- PLACEABLES: TREES

ConstructionBrushTree.getPrice = Utils.overwrittenFunction(ConstructionBrushTree.getPrice,
    AdvancedGameplaySettings.getPrice('placeable')
)

-- PLACEABLES: FENCE

ConstructionBrushFence.getPrice = Utils.overwrittenFunction(ConstructionBrushFence.getPrice,
    AdvancedGameplaySettings.getPrice('placeable')
)



--[[
    ConstructionBrushFence

    Override overlap check specific for fence
]]


ConstructionBrushFence.boxOverlapCallback = Utils.overwrittenFunction(ConstructionBrushFence.boxOverlapCallback,
    function (self, func, ...)
        if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'enableOverlapWithObjects'), false) ~= true then
            func(self, ...)
        end
    end
)




--[[
    Override overlap checks for placeables

    getHasOverlap
    getHasOverlapWithPlaces
    getHasOverlapWithZones
]]

PlaceablePlacement.getHasOverlap = Utils.overwrittenFunction(PlaceablePlacement.getHasOverlap,
    function (self, func, ...)
        if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'enableOverlapWithObjects'), false) ~= true then
            return func(self, ...)
        end

        return false
    end
)

PlaceablePlacement.getHasOverlapWithPlaces = Utils.overwrittenFunction(PlaceablePlacement.getHasOverlapWithPlaces,
    function (self, func, ...)
        if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableAccessCheck'), false) ~= true then
            return func(self, ...)
        end

        return false
    end
)

PlaceablePlacement.getHasOverlapWithZones = Utils.overwrittenFunction(PlaceablePlacement.getHasOverlapWithZones,
    function (self, func, ...)
        if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableAccessCheck'), false) ~= true then
            return func(self, ...)
        end

        return false
    end
)


--[[
    Disable terrain displacement for placeables
]]

PlaceableLeveling.getRequiresLeveling = Utils.overwrittenFunction(PlaceableLeveling.getRequiresLeveling,
    function(self, func)
        if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableTerrainDisplacement'), false) ~= true then
            return func(self)
        end

        return false
    end
)

PlaceableLeveling.getDeformationObjects = Utils.overwrittenFunction(PlaceableLeveling.getDeformationObjects,
    function(self, func, terrainRootNode, forBlockingOnly, isBlocking)
        if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableTerrainDisplacement'), false) ~= true then
            return func(self, terrainRootNode, forBlockingOnly, isBlocking)
        end

        return {}
    end
)

--[[
    Disable removing foliage on terrain when placing objects
]]

PlaceableClearAreas.onPostFinalizePlacement = Utils.overwrittenFunction(PlaceableClearAreas.onPostFinalizePlacement,
    function(self, func)
        if Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('placeable', 'disableRemoveFoliage'), false) ~= true then
            return func(self)
        end
    end
)


--[[
    Override repair and repaint costs
]]


local overrideAddMoney = false

Wearable.repaintVehicle = Utils.prependedFunction(Wearable.repaintVehicle,
    function()
        overrideAddMoney = true
    end
)
Wearable.repaintVehicle = Utils.appendedFunction(Wearable.repaintVehicle,
    function()
        overrideAddMoney = false
    end
)

Wearable.repairVehicle = Utils.prependedFunction(Wearable.repairVehicle,
    function()
        overrideAddMoney = true
    end
)
Wearable.repairVehicle = Utils.appendedFunction(Wearable.repairVehicle,
    function()
        overrideAddMoney = false
    end
)

FSBaseMission.addMoney = Utils.overwrittenFunction(FSBaseMission.addMoney,
    function(self, func, amount, ...)
        if overrideAddMoney ~= true then
            return func(self, amount, ...)
        end

        local factor = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('vehicle', 'repaintCostFactor'), 1.0)
        local price = amount * factor

        if price > 0 then
            func(self, price, ...)
        end
    end
)

--[[
    Override wear amount from Wearable:updateWearAmount
]]

Wearable.updateWearAmount = Utils.overwrittenFunction(Wearable.updateWearAmount,
    function(self, func, ...)
        local amount = func(self, ...)
        local factor = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('vehicle', 'wearFactor'), 1.0)

        return amount * factor
    end
)

--[[
    Override FillUnit:addUnitFillLevel
]]

-- FillUnit.addFillUnitFillLevel = Utils.overwrittenFunction(FillUnit.addFillUnitFillLevel,
--     function(self, func, farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, ...)
--         if (fillType ~= FillType.DIESEL and fillType ~= FillType.METHANE and fillType ~= FillType.ELECTRICCHARGE) or fillLevelDelta >= 0 then
--             return func(self, farmId, fillUnitIndex, fillLevelDelta, fillTypeIndex, ...)
--         end

--         local factor = Utils.getNoNil(g_advancedGameplaySettings:getTypeNameValue('vehicle', 'fuelUsageFactor'), 1.0)
--         local usageDelta = fillLevelDelta * factor

--         return func(self, farmId, fillUnitIndex, usageDelta, fillTypeIndex, ...)
--     end
-- )

-- We also should update spec.lastFuelUsage but cant be arsed really..




--[[
    Note on:
    Overriding Wearable.getRepairPrice and Wearable.getRepaintPrice

    Some logic points that use the result values will skip repairing/repainting if
    the return value from these functions are 0

    So best not to override these ones unless you return at least value > 0
]]




--[[
    Repair all vehicles/implements
]]



function AdvancedGameplaySettings:repairAllVehicles()
    for _, vehicle in pairs(g_currentMission.vehicles) do
        local spec = vehicle.spec_wearable
        if spec ~= nil then
            vehicle:repairVehicle()

            -- vehicle:setDamageAmount(0)
            -- vehicle:raiseDirtyFlags(vehicle.spec_wearable.dirtyFlag)
        end
    end
end


function AdvancedGameplaySettings:repaintAllVehicles()
    for _, vehicle in pairs(g_currentMission.vehicles) do
        local spec = vehicle.spec_wearable
        if spec ~= nil then
            vehicle:repaintVehicle()

            -- for _, data in ipairs(spec.wearableNodes) do
            --     vehicle:setNodeWearAmount(data, 0, true)
            -- end
            -- vehicle:raiseDirtyFlags(spec.dirtyFlag)
        end
    end
end



--[[
    [NOT IN USE, FOR DOCUMENTATION ONLY]
    Override GuiOverlay:loadOverlay

    This is needed to enable custom overlay file with modDir path ..
    In guiProfile.xml the standard one is 'g_baseUIFilename' which is hardcoded.
    The only way to set your own with a custom path outside game folder is overriding the result of GuiOverlay.loadOverlay function
]]

-- function AdvancedGameplaySettings.loadOverlay(self, func, overlay, overlayName, imageSize, profile, xmlFile, key)
--     local _overlay = func(self, overlay, overlayName, imageSize, profile, xmlFile, key)

--     if _overlay ~= nil and _overlay.filename == 'g_customBaseUIFilename' then
--         _overlay.filename = modFolder .. 'hud/ui_elements.png'
--     end

--     return _overlay
-- end

-- GuiOverlay.loadOverlay = Utils.overwrittenFunction(
--     GuiOverlay.loadOverlay,
--     AdvancedGameplaySettings.loadOverlay
-- )


addModEventListener(AdvancedGameplaySettings)