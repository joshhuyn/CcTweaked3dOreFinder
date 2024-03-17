ScannerService = {scanner = nil, blockTag = ""}

function ScannerService:new(o, scanner, blockTag)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.scanner = scanner
    self.blockTag = blockTag

    return o
end

function ScannerService:getBlocks()
    local scan = self.scanner.scan()
    local blocks = {}

    for _, v in pairs(scan) do
        if v.name == self.blockTag then
            blocks[#blocks] = v
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
            closestBlockCoord = closestBlock
        end
    end

    return closestBlock
end

function ScannerService:getAngle()
    local closestBlock = self:getNearestBlock()

    if closestBlock == nil then
        return nil
    end

    local xFlipped = false
    local x = closestBlock.x

    if x < 0 then
        xFlipped = true
        x = x * -1
    end

    local yFlipped = false
    local y = closestBlock.y

    if y < 0 then
        yFlipped = true
        y = y * -1
    end

    local pitch = math.rad(360) - math.atan(x / y)

    if yFlipped then
        -- pitch = pitch + math.pi - math.rad(360) - math.rad(180)
        pitch = math.rad(180) - pitch
    end

    local yaw = math.atan(closestBlock.x / closestBlock.z)
    if yaw < 0 then
        yaw = yaw
    end

    return {
        pitch = pitch,
        yaw = yaw,
        x = closestBlock.x,
        y = closestBlock.y
    }
end
