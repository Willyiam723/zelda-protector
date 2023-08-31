--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

ProtectorFireRocketsState = Class{__includes = BaseState}

function ProtectorFireRocketsState:init(protector, level)
    self.protector = protector
    self.level = level

    -- render offset for spaced character sprite
    self.protector.offsetX = 16
    self.protector.offsetY = 16

    -- create hitbox based on where the protector is and facing
    -- separate hitbox for the protector's weapon; will only be active during this state
    self.rocketsHitbox = self:getRocketsHitBox()

    -- Rockets-left, Rockets-up, etc
    self.protector:changeAnimation('rockets-' .. self.protector.direction)

    self.waitDuration = 0
    self.waitTimer = 0
end

function ProtectorFireRocketsState:enter(params)

    self.protector:changeAnimation('rockets-' .. self.protector.direction)
end

function ProtectorFireRocketsState:update(dt)

    -- update rockets hit box based on direction facing
    self.rocketsHitbox = self:getRocketsHitBox()
    
    -- spawn bullet in a certain frequency
    if self.waitDuration == 0 then
        self.waitDuration = 2
        -- check if hitbox collides with any entities in the scene
        for k, entity in pairs(self.level.entities) do
            if not entity.alreadyHit and entity:collides(self.rocketsHitbox) and not entity.isZelda and not entity.isProtector and not entity.dead then
                
                -- spawn and fire rockets bullet
                self:spawnRocketsBullet()

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

function ProtectorFireRocketsState:render()
    local anim = self.protector.currentAnimation
    local frame = anim:getCurrentFrame()

    -- adjust offset due to uneven sprite sheet spaces
    self.protector.offsetX = self:adjustOffsetX(frame)

    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][frame],
        math.floor(self.protector.x - self.protector.offsetX), math.floor(self.protector.y - self.protector.offsetY))

    -- debug for protector and hurtbox collision rects VV

    -- love.graphics.setColor(255, 0, 255, 255)
    -- -- love.graphics.rectangle('line', self.protector.x, self.protector.y, self.protector.width, self.protector.height)
    -- love.graphics.rectangle('line', self.rocketsHitbox.x, self.rocketsHitbox.y,
    --     self.rocketsHitbox.width, self.rocketsHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end

-- separate hitbox for the protector's rockets
function ProtectorFireRocketsState:getRocketsHitBox()
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    hitboxX, hitboxY, hitboxWidth, hitboxHeight = self.protector:getHitboxDimension('rockets')

    return Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
end

-- function to spawn crossbow arrow based on protector's facing direction
function ProtectorFireRocketsState:spawnRocketsBullet()
    local startX, startY
    local direction = self.protector.direction

    if direction == 'left' then
        startX = self.protector.x - 10
        startY = self.protector.y - 2
    elseif direction == 'right' then
        startX = self.protector.x + self.protector.width
        startY = self.protector.y - 2
    elseif direction == 'up' then
        startX = self.protector.x + self.protector.width/2
        startY = self.protector.y
    else
        startX = self.protector.x + self.protector.width/2
        startY = self.protector.y + self.protector.height
    end

    local bullet = GameObject(
        GAME_OBJECT_DEFS['bullet-' .. direction],
        startX,
        startY
    )

    -- define a function for the bullet that deals damage to enemy entities
    bullet.onCollide = function(entity)
            
        entity:damage(self.protector.attack)
        entity:goInvulnerable(0.5)
        gSounds['hit-enemy']:play()

        -- tag entity has already been hit so that damage won't be dealt during vulnerable time
        -- to avoid weapon hit dealing infinite damage due to collision with hitbox x amount of
        -- times in one game frame
        entity.alreadyHit = true
    end

    bullet:fire(direction, startX, startY)

    table.insert(self.level.objects, bullet)
end

-- function to return offsetX due to unevenly spaced sprite sheet
function ProtectorFireRocketsState:adjustOffsetX(frame)
    for i = 24, 1, -1 do
        if frame % 6 == 2 then
            return 16 + 2
        elseif frame % 6 == 3 then
            return 16 + 5
        elseif frame % 6 == 4 then
            return 16 + 8
        elseif frame % 6 == 5 then
            return 16 + 11
        elseif frame % 6 == 0 then
            return 16 + 14
        else
            return self.protector.offsetX 
        end
    end
end