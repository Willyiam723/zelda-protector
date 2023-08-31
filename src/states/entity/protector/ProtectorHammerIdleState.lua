--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

ProtectorHammerIdleState = Class{__includes = BaseState}

function ProtectorHammerIdleState:init(protector, level)
    self.protector = protector
    self.level = level

    -- render offset for spaced character sprite
    self.protector.offsetX = 16
    self.protector.offsetY = 16
    

    self.protector:changeAnimation('hammer-idle-' .. self.protector.direction)

    -- to measure attack range
    self.potentialHitbox = nil
end

function ProtectorHammerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.protector.offsetX = 16
    self.protector.offsetY = 16
    
end

function ProtectorHammerIdleState:update(dt)

    -- change direction to facing the enemy
    self.protector.direction = self:getEnemyFacingDirection()

    -- change to swing Hammer state if enemy is within attacking range
    if self:withinAttackRange() then
        self.protector:changeState('swing-hammer')
    end
end

function ProtectorHammerIdleState:render()
    local anim = self.protector.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.protector.x - self.protector.offsetX), math.floor(self.protector.y - self.protector.offsetY))
end

-- function to return whether an enemy is within the protector's attacking range
function ProtectorHammerIdleState:withinAttackRange()
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    hitboxX, hitboxY, hitboxWidth, hitboxHeight = self.protector:getHitboxDimension('hammer')

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
function ProtectorHammerIdleState:getEnemyFacingDirection()
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