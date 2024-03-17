require("gui.ScannerService")

CanvasService = {canvas = nil, offset = 100, scannerService = nil}

function CanvasService:new(o, canvas)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.canvas = canvas

    self.scannerService = ScannerService:new(nil, peripheral.wrap("back"), "minecraft:iron_ore")

    self.canvas.clear()

    return o
end

local function compare(a, b)
    return a.zIndex > b.zIndex
end

function CanvasService:getMetaData()
    local metaData = self.scannerService:getAngle()
    
    if metaData == nil then
        metaData = {pitch = 0, yaw = 0}
    end
    
    return metaData
end

function CanvasService:multiply(m1, m2)
    local result = {0, 0, 0, 0, 0, 0, 0, 0, 0}

    for row = 0, 2 do
        for col = 0, 2 do
            for i = 0, 2 do
                result[(row * 3 + col) + 1] = result[(row * 3 + col) + 1] + (m1[(row * 3 + i) + 1] * m2[(i * 3 + col) + 1])
            end
        end
    end

    return result
end

function CanvasService:transform(vertexIn, matrix3)
    return {
        x = vertexIn.x * matrix3[1] + vertexIn.y * matrix3[4] + vertexIn.z * matrix3[7],
        y = vertexIn.x * matrix3[2] + vertexIn.y * matrix3[5] + vertexIn.z * matrix3[8],
        z = vertexIn.x * matrix3[3] + vertexIn.y * matrix3[6] + vertexIn.z * matrix3[9]
    }
end

function CanvasService:sameSide(A, B, C, p)
    local v1v2 = {x = B.x - A.x, y = B.y - A.y, z = B.z - A.z}
    local v1v3 = {x = C.x - A.x, y = C.y - A.y, z = C.z - A.z}
    local v1p = {x = p.x - A.x, y = p.y - A.y, z = p.z - A.z}

    local v1v2crossv1v3 = v1v2.x * v1v3.y - v1v3.x * v1v2.y
    local v1v2crossp = v1v2.x * v1p.y - v1p.x * v1v2.y

    return v1v2crossv1v3 * v1v2crossp >= 0
end

function CanvasService:draw(prisms)
    self.canvas.clear()
    local width = 25 * 2
    local metaData = self:getMetaData()

    local heading = metaData.yaw
    local headingTransform = {math.cos(heading), 0, -math.sin(heading), 0, 1, 0, math.sin(heading), 0, math.cos(heading)}

    local pitch = metaData.pitch
    local pitchTransform = {1, 0, 0, 0, math.cos(pitch), math.sin(pitch), 0, -math.sin(pitch), math.cos(pitch)}

    local transform = self:multiply(headingTransform, pitchTransform)
    local vertecies = {}

    for k,v in pairs(prisms) do
        local v1 = self:transform(v.v1, transform)
        local v2 = self:transform(v.v2, transform)
        local v3 = self:transform(v.v3, transform)

        local zIndex = v1.z + v2.z + v3.z;

        vertecies[#vertecies+1] = { zIndex = zIndex, v1 = {v1.x + self.offset, v1.y + self.offset}, v2 = {v2.x + self.offset, v2.y + self.offset}, v3 = {v3.x + self.offset, v3.y + self.offset}, color = v.color}
    end

    table.sort(vertecies, compare)

    for k, v in pairs(vertecies) do
        self.canvas.addTriangle(v.v1, v.v2, v.v3, v.color)
    end

    local text = self.canvas.addText({y = 5, x = 10}, "")
    text.setText(tostring(metaData.yaw))

    local textX = self.canvas.addText({y = 20, x = 10}, "")
    textX.setText(tostring(metaData.pitch))

    local textDeg = self.canvas.addText({y = 30, x = 10}, "")
    textDeg.setText(tostring(math.deg(metaData.pitch)))
end
