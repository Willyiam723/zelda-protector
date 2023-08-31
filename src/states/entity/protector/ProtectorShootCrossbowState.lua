--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

ProtectorShootCrossbowState = Class{__includes = BaseState}

function ProtectorShootCrossbowState:init(protector, level)
    self.protector = protector
    self.level = level

    -- render offset for spaced character sprite
    self.protector.offsetX = 16
    self.protector.offsetY = 16

    -- create hitbox based on where the protector is and facing
    -- separate hitbox for the protector's weapon; will only be active during this state
    self.crossbowHitbox = self:getCrossbowHitBox()

    -- Crossbow-left, Crossbow-up, etc
    self.protector:changeAnimation('crossbow-' .. self.protector.direction)

    self.waitDuration = 0
    self.waitTimer = 0
end

function ProtectorShootCrossbowState:enter(params)

    self.protector:changeAnimation('crossbow-' .. self.protector.direction)
end

function ProtectorShootCrossbowState:update(dt)

    -- update crossbow hit box based on direction facing
    self.crossbowHitbox = self:getCrossbowHitBox()
    
    -- spawn arrows in a certain frequency
    if self.waitDuration == 0 then
        self.waitDuration = 2

        -- check if hitbox collides with any entities in the scene
        for k, entity in pairs(self.level.entities) do
            if not entity.alreadyHit and entity:collides(self.crossbowHitbox) and not entity.isZelda and not entity.isProtector and not entity.dead then
                
                -- spawn and fire crossbow arrow
                self:spawnCrossbowArrow()

            end
        end
    else
        self.waitTimer = self.waitTimer + dt
    end

    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.protector.currentAnimation.timesPlayed > 0 then
        self.protector.currentAnimation.timesPlayed = 0
        self.protector:changeState('idle')
    end
end

function ProtectorShootCrossbowState:render()
    local anim = self.protector.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.protector.x - self.protector.offsetX), math.floor(self.protector.y - self.protector.offsetY))

    -- debug for protector and hurtbox collision rects VV

    -- love.graphics.setColor(255, 0, 255, 255)
    -- -- love.graphics.rectangle('line', self.protector.x, self.protector.y, self.protector.width, self.protector.height)
    -- love.graphics.rectangle('line', self.crossbowHitbox.x, self.crossbowHitbox.y,
    --     self.crossbowHitbox.width, self.crossbowHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

-- function to return hitbox for the protector's crossbow
function ProtectorShootCrossbowState:getCrossbowHitBox()
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    hitboxX, hitboxY, hitboxWidth, hitboxHeight = self.protector:getHitboxDimension('crossbow')

    return Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
end

-- function to spawn crossbow arrow based on protector's facing direction
function ProtectorShootCrossbowState:spawnCrossbowArrow()
    local startX, startY
    local direction = self.protector.direction

    if direction == 'left' then
        startX = self.protector.x
        startY = self.protector.y + 2
    elseif direction == 'right' then
        startX = self.protector.x + self.protector.width
        startY = self.protector.y + 2
    elseif direction == 'up' then
        startX = self.protector.x + self.protector.width/2
        startY = self.protector.y
    else
        startX = self.protector.x + self.protector.width/2
        startY = self.protector.y + self.protector.height
    end

    local arrow = GameObject(
        GAME_OBJECT_DEFS['arrow-' .. direction],
        startX,
        startY
    )

    -- define a function for the arrow that deals damage to enemy entities
    arrow.onCollide = function(entity)
            
        entity:damage(self.protector.attack)
        entity:goInvulnerable(0.5)
        gSounds['hit-enemy']:play()

        -- tag entity has already been hit so that damage won't be dealt during vulnerable time
        -- to avoid weapon hit dealing infinite damage due to collision with hitbox x amount of
        -- times in one game frame
        entity.alreadyHit = true
    end

    arrow:fire(direction, startX, startY)

    table.insert(self.level.objects, arrow)
end