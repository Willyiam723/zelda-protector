--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

Protector = Class{__includes = Entity}

function Protector:init(def)
    Entity.init(self, def)
    
    self.price = def.price or nil
    self.attack = def.attack or nil
end

function Protector:update(dt)
    
    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Protector:render()
    
    self.stateMachine:render()
    
    -- debug for body box
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

function Protector:getHitboxDimension(protectorType)
    local direction = self.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight
    local protectorTypes = {'hammer', 'crossbow', 'rockets'}

    if protectorType == protectorTypes[1] then
        if direction == 'left' then
            hitboxWidth = 8
            hitboxHeight = 16
            hitboxX = self.x - hitboxWidth
            hitboxY = self.y + 2
        elseif direction == 'right' then
            hitboxWidth = 8
            hitboxHeight = 16
            hitboxX = self.x + self.width
            hitboxY = self.y + 2
        elseif direction == 'up' then
            hitboxWidth = 16
            hitboxHeight = 8
            hitboxX = self.x
            hitboxY = self.y - hitboxHeight
        else
            hitboxWidth = 16
            hitboxHeight = 8
            hitboxX = self.x
            hitboxY = self.y + self.height
        end
    elseif protectorType == protectorTypes[2] then
        if direction == 'left' then
            hitboxWidth = 48
            hitboxHeight = self.height/2
            hitboxX = self.x - hitboxWidth
            hitboxY = self.y + 2
        elseif direction == 'right' then
            hitboxWidth = 48
            hitboxHeight = self.height/2
            hitboxX = self.x + self.width
            hitboxY = self.y + 2
        elseif direction == 'up' then
            hitboxWidth = self.width/2
            hitboxHeight = 48
            hitboxX = self.x + self.width/4
            hitboxY = self.y - hitboxHeight
        else
            hitboxWidth = self.width/2
            hitboxHeight = 48
            hitboxX = self.x + self.width/4
            hitboxY = self.y + self.height
        end
    elseif protectorType == protectorTypes[3] then
        if direction == 'left' then
            hitboxWidth = 96
            hitboxHeight = self.height/2
            hitboxX = self.x - hitboxWidth
            hitboxY = self.y + 2
        elseif direction == 'right' then
            hitboxWidth = 96
            hitboxHeight = self.height/2
            hitboxX = self.x + self.width
            hitboxY = self.y + 2
        elseif direction == 'up' then
            hitboxWidth = self.width/2
            hitboxHeight = 96
            hitboxX = self.x + self.width/4
            hitboxY = self.y - hitboxHeight
        else
            hitboxWidth = self.width/2
            hitboxHeight = 96
            hitboxX = self.x + self.width/4
            hitboxY = self.y + self.height
        end
    end

    return hitboxX, hitboxY, hitboxWidth, hitboxHeight
end