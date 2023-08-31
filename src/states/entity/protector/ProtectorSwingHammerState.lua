--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

ProtectorSwingHammerState = Class{__includes = BaseState}

function ProtectorSwingHammerState:init(protector, level)
    self.protector = protector
    self.level = level

    -- render offset for spaced character sprite
    self.protector.offsetX = 16
    self.protector.offsetY = 16

    -- create hitbox based on where the protector is and facing
    -- separate hitbox for the protector's weapon; will only be active during this state
    self.hammerHitbox = self:getHammerHitBox()

    -- Hammer-left, Hammer-up, etc
    self.protector:changeAnimation('hammer-' .. self.protector.direction)
end

function ProtectorSwingHammerState:enter(params)

    self.protector:changeAnimation('hammer-' .. self.protector.direction)
end

function ProtectorSwingHammerState:update(dt)

    -- update hammer hit box based on direction facing
    self.hammerHitbox = self:getHammerHitBox()
    
    -- check if hitbox collides with any entities in the scene
    for k, entity in pairs(self.level.entities) do
        if not entity.alreadyHit and entity:collides(self.hammerHitbox) and not entity.isZelda and not entity.isProtector and not entity.dead then
            entity:damage(self.protector.attack)
            entity:goInvulnerable(0.5)
            gSounds['hit-enemy']:play()

            -- tag entity has already been hit so that damage won't be dealt during vulnerable time
            -- to avoid weapon hit dealing infinite damage due to collision with hitbox x amount of
            -- times in one game frame
            entity.alreadyHit = true
        end
    end

    -- test for flower collission with hammer protectors
    for j, shinyObject in pairs(self.level.objects) do
        if shinyObject.isShiny and shinyObject:collides(self.hammerHitbox) then
            shinyObject.onCollide(shinyObject)
            table.remove(self.level.objects, j)
        end
    end

    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.protector.currentAnimation.timesPlayed > 0 then
        self.protector.currentAnimation.timesPlayed = 0
        self.protector:changeState('idle')
    end
end

function ProtectorSwingHammerState:render()
    local anim = self.protector.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.protector.x - self.protector.offsetX), math.floor(self.protector.y - self.protector.offsetY))
    
    -- debug for protector and hurtbox collision rects VV

    -- love.graphics.setColor(255, 0, 255, 255)
    -- -- love.graphics.rectangle('line', self.protector.x, self.protector.y, self.protector.width, self.protector.height)
    -- love.graphics.rectangle('line', self.hammerHitbox.x, self.hammerHitbox.y,
    --     self.hammerHitbox.width, self.hammerHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

-- function to return hitbox for hammer protector
function ProtectorSwingHammerState:getHammerHitBox()
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    hitboxX, hitboxY, hitboxWidth, hitboxHeight = self.protector:getHitboxDimension('hammer')

    return Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
end