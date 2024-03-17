require("gui.CanvasService")
require("scanner.ScannerService")

Main = {canvasService = nil, width = 50, widthPos = 0, widthNegativePos = 0, blockName = "minecraft:iron_ore"}

function Main:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.widthPos = self.width / 2
    self.widthNegativePos = self.width / 2 * -1

    local scanner = ScannerService:new(nil, peripheral.wrap("back"), arg[1],
        function(block)
            return block.name == self.blockName
        end
    )

    self.canvasService = CanvasService:new(nil, peripheral.wrap("back").canvas(), scanner, self.blockName)

    return o
end

function Main:start()
    local prism = self:createPrism()
    while true do
        self.canvasService:draw(prism)
        sleep(0.01)
    end
end

function Main:createPrism2()
    local stack = {}

    stack[#stack + 1] = { -- back
        v1 = {
            x = self.widthPos,
            y = self.widthPos,
            z = self.widthPos
        },
        v2 = {
            x = self.widthNegativePos,
            y = self.widthPos,
            z = self.widthPos
        },
        v3 = {
            x = 0,
            y = self.widthNegativePos,
            z = 0
        },
        color = 0x742D3DFF
    }

    stack[#stack + 1] = { -- front
        v1 = {
            x = self.widthPos,
            y = self.widthPos,
            z = self.widthNegativePos
        },
        v2 = {
            x = self.widthNegativePos,
            y = self.widthPos,
            z = self.widthNegativePos
        },
        v3 = {
            x = 0,
            y = self.widthNegativePos,
            z = 0
        },
        color = 0x00FF0DFF
    }

    return stack
end

function Main:createPrism()
    local stack = {}

    stack[#stack + 1] = { -- back
        v1 = {
            x = self.widthPos,
            y = self.widthPos,
            z = self.widthPos
        },
        v2 = {
            x = self.widthNegativePos,
            y = self.widthPos,
            z = self.widthPos
        },
        v3 = {
            x = 0,
            y = self.widthNegativePos,
            z = 0
        },
        color = 0x742D3DFF
    }

    stack[#stack + 1] = { -- left
        v1 = {
            x = self.widthPos,
            y = self.widthPos,
            z = self.widthPos
        },
        v2 = {
            x = self.widthPos,
            y = self.widthPos,
            z = self.widthNegativePos
        },
        v3 = {
            x = 0,
            y = self.widthNegativePos,
            z = 0
        },
        color = 0x73356CFF
    }

    stack[#stack + 1] = { -- front
        v1 = {
            x = self.widthPos,
            y = self.widthPos,
            z = self.widthNegativePos
        },
        v2 = {
            x = self.widthNegativePos,
            y = self.widthPos,
            z = self.widthNegativePos
        },
        v3 = {
            x = 0,
            y = self.widthNegativePos,
            z = 0
        },
        color = 0x00FF0DFF
    }

    stack[#stack + 1] = { -- right
        v1 = {
            x = self.widthNegativePos,
            y = self.widthPos,
            z = self.widthNegativePos
        },
        v2 = {
            x = self.widthNegativePos,
            y = self.widthPos,
            z = self.widthPos
        },
        v3 = {
            x = 0,
            y = self.widthNegativePos,
            z = 0
        },
        color = 0xFFF700FF
    }

    stack[#stack + 1] = { -- bottom 1
        v1 = {
            x = self.widthNegativePos,
            y = self.widthPos,
            z = self.widthNegativePos
        },
        v2 = {
            x = self.widthPos,
            y = self.widthPos,
            z = self.widthPos
        },
        v3 = {
            x = self.widthPos,
            y = self.widthPos,
            z = self.widthNegativePos
        },
        color = 0xFFFFFFFF
    }
    -- Disabled until zIndexing is fixed

    -- stack[#stack + 1] = { -- bottom 2
    --     v1 = {
    --         x = self.widthNegativePos,
    --         y = self.widthPos,
    --         z = self.widthPos
    --     },
    --     v2 = {
    --         x = self.widthNegativePos,
    --         y = self.widthPos,
    --         z = self.widthNegativePos
    --     },
    --     v3 = {
    --         x = self.widthPos,
    --         y = self.widthPos,
    --         z = self.widthNegativePos
    --     },
    --     color = 0xFFFFFFFF
    -- }

    -- stack[#stack + 1] = { -- bottom 3
    --     v1 = {
    --         x = self.widthPos,
    --         y = self.widthPos,
    --         z = self.widthNegativePos
    --     },
    --     v2 = {
    --         x = self.widthNegativePos,
    --         y = self.widthPos,
    --         z = self.widthPos
    --     },
    --     v3 = {
    --         x = self.widthPos,
    --         y = self.widthPos,
    --         z = self.widthPos
    --     },
    --     color = 0xFFFFFFFF
    -- }

    -- stack[#stack + 1] = { -- bottom 4
    --     v1 = {
    --         x = self.widthNegativePos,
    --         y = self.widthPos,
    --         z = self.widthNegativePos
    --     },
    --     v2 = {
    --         x = self.widthNegativePos,
    --         y = self.widthPos,
    --         z = self.widthPos
    --     },
    --     v3 = {
    --         x = self.widthPos,
    --         y = self.widthPos,
    --         z = self.widthPos
    --     },
    --     color = 0xFFFFFFFF
    -- }

    return stack
end

local main = Main:new(nil)

main:start()
