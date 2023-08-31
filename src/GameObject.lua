--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

GameObject = Class{__includes = Projectile}

-- some of the colors in our palette (to be used with particle systems)
paletteColors = {
    -- shiny
    [1] = {
        ['r'] = 255,
        ['g'] = 224,
        ['b'] = 0
    }
}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y

    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end

    self.clickable = def.clickable
    self.onClick = function() end

    self.consumable = def.consumable
    self.onConsume = def.onConsume

    self.projectile = nil
    self.isEntityObject = def.isEntityObject or false
    self.isShiny = def.isShiny or false

    -- particle system belonging to the shiny tile
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 2)

    self.psystem:setParticleLifetime(1, 2)
    self.psystem:setLinearAcceleration(-5, -5, 5, 5)
    self.psystem:setEmissionArea('normal', 2, 2)
    self.psystem:setSpeed(1)
    self.psystem:setSpin(2, 5)

end

function GameObject:update(dt)
    self.psystem:update(dt)
    if self.projectile then
        self.x = self.x + self.projectile.dx * dt
        self.y = self.y + self.projectile.dy * dt
    end
end

function GameObject:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x, self.y)

    -- draw particle system if the object is shiny
    if self.isShiny then
        self.psystem:setColors(
            paletteColors[1].r / 255,
            paletteColors[1].g / 255,
            paletteColors[1].b / 255,
            125 / 255
        )
        Timer.every(0.5, function()
            self.psystem:emit(1)
        end)

        love.graphics.draw(self.psystem, self.x + TILE_SIZE/2, self.y + TILE_SIZE/2)
    end
end

-- function to enable projectile
function GameObject:fire(direction, x, y)
    self.startX = x 
    self.startY = y 

    if direction == 'left' then
        self.projectile = Projectile(-PROJECTILE_FIRE_SPEED, 0)
    elseif direction == 'right' then
        self.projectile = Projectile(PROJECTILE_FIRE_SPEED, 0)
    elseif direction == 'up' then
        self.projectile = Projectile(0, -PROJECTILE_FIRE_SPEED)
    else
        self.projectile = Projectile(0, PROJECTILE_FIRE_SPEED)
    end
end

-- function to calculate projectile's distance travelled
function GameObject:distanceTravelled()
    return math.abs(self.x - self.startX + self.y - self.startY)
end

-- function to retrun whether projectile hit the wall
function GameObject:hitWall()

    local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE

    -- boundary checking on all sides
    if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
        return true
    elseif self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
        return true
    elseif self.y <= MAP_RENDER_OFFSET_Y - TILE_SIZE / 2 then
        return true
    elseif self.y + self.height >= bottomEdge then
        return true
    end

    return false
end

--[[
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end