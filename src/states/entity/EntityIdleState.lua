--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    if not self.entity.isZelda then
        self.entity:changeAnimation('idle-' .. self.entity.direction)
    else
        self.entity:changeAnimation(self.entity.health .. '-health')
    end

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

function EntityIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration and self.entity.walkSpeed > 0 and not self.entity.isStatic and not self.entity.isEntityObject then
            self.entity:changeState('walk')
        end
    end
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    local health = self.entity.health
    local maxHealth = self.entity.maxHealth
    local zeldaFallOffset = anim.texture == 'zelda-fall' and TILE_SIZE or 0

    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY + zeldaFallOffset))

    if self.entity.isZelda then

        -- render Zelda's health at top of the screen
        local healthLeft = health
        local heartFrame = 1

        for i = 1, maxHealth do
            if healthLeft >= 1 then
                heartFrame = 5
            else
                heartFrame = 1
            end

            love.graphics.setFont(gFonts['zelda-extra-small'])
            love.graphics.print('Zelda\'s Health: ', TILE_SIZE, 2)
            love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
                i * (TILE_SIZE + 1) + 6 * TILE_SIZE, 2)
            
            healthLeft = healthLeft - 1
        end
    else
        love.graphics.draw(gTextures['enemy-health'], gFrames['enemy-health'][health],
            math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY - self.entity.height/2))
    end
end