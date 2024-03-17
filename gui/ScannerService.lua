ScannerService = {scanner = nil, blockTag = "", playerName = nil}

function ScannerService:new(o, scanner, blockTag)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.scanner = scanner
    self.blockTag = blockTag
    self.playerName = "JoshJHB"

    return o
end

function ScannerService:getMetaData()
    local metaData = nil
    for _, v in pairs(self.scanner.sense()) do
        if v.name == self.playerName then
            metaData = v
        end
    end

    return metaData
end

function ScannerService:getBlocks()
    local scan = self.scanner.scan()
    local blocks = {}

    for _, v in pairs(scan) do
        if v.name == self.blockTag then
            blocks[#blocks + 1] = v
        end
    end

    return blocks
end

function ScannerService:getClosestCoord(block)
    local coordObj =
    {
        x = math.abs(block.x),
        y = math.abs(block.y),
        z = math.abs(block.z)
    }

    return (coordObj.x + coordObj.y + coordObj.z) / 3
end

function ScannerService:getNearestBlock()
    local blocks = self:getBlocks()

    local closestBlock = nil
    local closestBlockCoord = 0

    for _, v in pairs(blocks) do
        local blockCoord = self:getClosestCoord(v)

        if closestBlock == nil or blockCoord < closestBlockCoord then
            closestBlock = v
            closestBlockCoord = blockCoord
        end
    end

    return closestBlock
end

function ScannerService:getPitch(closestBlock)
    local y = closestBlock.y
    local xz = closestBlock.x

    if xz == 0 then
        xz = closestBlock.z
    end

    if xz < 0 then
        xz = xz * -1
    end

    local yFlipped = false
    local y = closestBlock.y

    if y < 0 then
        yFlipped = true
        y = y * -1
    end

    local pitch = math.atan(xz / y)

    if y == 0 then
        pitch = math.rad(90)
    end

    if yFlipped then
        -- pitch = pitch + math.pi - math.rad(360) - math.rad(180)
        pitch = math.rad(180) - pitch
    end

    return pitch
end

function ScannerService:getYaw(closestBlock, metaData)

    if metaData == nil then
        return 0
    end

    local xFlipped = false
    local zFlipped = false
    local x = closestBlock.x
    local z = closestBlock.z

    if x < 0 then
        xFlipped = true
        x = x
    end

    if z < 0 then
        zFlipped = true
        z = z
    end

    local yaw = math.atan(x / z) + math.rad(metaData.yaw)

    if zFlipped then
        yaw = yaw + math.rad(180)
    end

    if z == 0 then
        yaw = math.rad(90) + math.rad(metaData.yaw)

        if xFlipped then
            yaw = yaw - math.rad(180)
        end
    end

    if x == 0 then
        yaw = math.rad(metaData.yaw)

        if zFlipped then
            yaw = yaw - math.rad(180)
        end
    end

    return yaw
end

function ScannerService:getAngle()
    local closestBlock = self:getNearestBlock()
    local metaData = self:getMetaData()

    if closestBlock == nil or metaData == nil then
        return nil
    end

    return {
        pitch = self:getPitch(closestBlock),
        yaw = self:getYaw(closestBlock, metaData),
        x = closestBlock.x,
        y = closestBlock.y,
        z = closestBlock.z,
        playerYaw = metaData.yaw,
        playerPitch = metaData.pitch
    }
end
