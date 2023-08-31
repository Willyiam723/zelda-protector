--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity, level)
    self.entity = entity
    self.entity:changeAnimation('walk-down')

    self.level = level

    -- used for AI control
    self.tilesWalked = {}

    -- keeps track of whether enemy has reached Zelda
    self.reachedZelda = false
end

function EntityWalkState:update(dt)

    if self.entity.direction == 'left' then
        self.entity.x = self.entity.x - self.entity.walkSpeed * dt
    elseif self.entity.direction == 'right' then
        self.entity.x = self.entity.x + self.entity.walkSpeed * dt
    elseif self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.walkSpeed * dt
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.walkSpeed * dt
    end
end

function EntityWalkState:processAI(params, dt)
    local level = params.level
    local currentTile = level.tiles[math.floor(self.entity.y/TILE_SIZE)][math.floor(self.entity.x/TILE_SIZE)]

    -- keep track of the tiles enemy has already walked on so that they don't go backwards
    if not self:alreadyWalkedTile(currentTile) then
        table.insert(self.tilesWalked, currentTile)
    end

    -- get direction of where the enemy is heading
    self.entity.direction = self:returnDirection(TILE_ENEMY_TRACK, level)
    if self.entity.direction then
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    end
end

function EntityWalkState:render()
    local anim = self.entity.currentAnimation
    local health = self.entity.health
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    love.graphics.draw(gTextures['enemy-health'], gFrames['enemy-health'][health],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY - self.entity.height/2))
end

-- function to return the direction the enemy is supposed to travel so that is travels alongside the
-- enemy track and would'nt walk backwards
function EntityWalkState:returnDirection(targetTile, level)
    local directions = {'left', 'right', 'up', 'down'}
    local downTile = level.tiles[math.floor(self.entity.y/TILE_SIZE) + 1][math.floor(self.entity.x/TILE_SIZE)]
    local upTile = level.tiles[math.floor(self.entity.y/TILE_SIZE) - 1][math.floor(self.entity.x/TILE_SIZE)]
    local rightTile = level.tiles[math.floor(self.entity.y/TILE_SIZE)][math.floor(self.entity.x/TILE_SIZE) + 1]
    local leftTile = level.tiles[math.floor(self.entity.y/TILE_SIZE)][math.floor(self.entity.x/TILE_SIZE) - 1]

    if downTile.id == targetTile and not self:alreadyWalkedTile(downTile) then
        return directions[4]
    elseif upTile.id == targetTile and not self:alreadyWalkedTile(upTile) then
        return directions[3]
    elseif rightTile.id == targetTile and not self:alreadyWalkedTile(rightTile) then
        return directions[2]
    elseif leftTile.id == targetTile and not self:alreadyWalkedTile(leftTile) then
        return directions[1]
    else
        self.entity.reachedZelda = true
        return nil
    end
end

-- function to add to the tiles enemy has already walked on so that they don't go backwards
function EntityWalkState:alreadyWalkedTile(tileToCheck)
    for k, tile in pairs(self.tilesWalked) do
        if tile == tileToCheck then
            return true
        end
    end

    return false
end