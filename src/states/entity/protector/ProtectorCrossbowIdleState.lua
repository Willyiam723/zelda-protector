--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

ProtectorCrossbowIdleState = Class{__includes = BaseState}

function ProtectorCrossbowIdleState:init(protector, level)
    self.protector = protector
    self.level = level

    -- render offset for spaced character sprite
    self.protector.offsetX = 16
    self.protector.offsetY = 16
    

    self.protector:changeAnimation('crossbow-idle-' .. self.protector.direction)

    -- to measure attack range
    self.potentialHitbox = nil
    -- self.potentialHitbox = Hitbox(self.protector.x - TILE_SIZE/2, self.protector.y - TILE_SIZE/2, self.protector.width + TILE_SIZE, self.protector.height + TILE_SIZE)
end

function ProtectorCrossbowIdleState:enter(params)

    -- self.protector:changeAnimation('idle-' .. self.protector.direction)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.protector.offsetX = 16
    self.protector.offsetY = 16
    
end

function ProtectorCrossbowIdleState:update(dt)

    -- change direction to facing the enemy
    self.protector.direction = self:getEnemyFacingDirection()

    -- change to shooting crossbow state if enemy is within attacking range
    if self:withinAttackRange() then
        self.protector:changeState('shoot-crossbow')
    end
end

function ProtectorCrossbowIdleState:render()
    local anim = self.protector.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.protector.x - self.protector.offsetX), math.floor(self.protector.y - self.protector.offsetY))
end

-- function to return whether an enemy is within the protector's attacking range
function ProtectorCrossbowIdleState:withinAttackRange()
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    hitboxX, hitboxY, hitboxWidth, hitboxHeight = self.protector:getHitboxDimension('crossbow')

    -- to measure attack range
    self.potentialHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    for k, entity in pairs(self.level.entities) do
        if entity:collides(self.potentialHitbox) and not entity.isZelda and not entity.isProtector and not entity.dead then
            return true
        end
    end

    return false
end

-- function to return protector's facing direction when attacking
function ProtectorCrossbowIdleState:getEnemyFacingDirection()
    -- track original direction
    local directionOriginal = self.protector.direction
    local directions = {'up', 'down', 'left', 'right'}

    for k, direction in pairs(directions) do
        self.protector.direction = direction
        if self:withinAttackRange() then
            return direction
        end
    end

    return directionOriginal
end