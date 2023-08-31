--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

Level = Class{}

function Level:init(levelNumber, coinTally, zeldaHealth)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self.levelNumber = levelNumber

    self.tiles, self.startEnemyTileX, self.startEnemyTileY, self.finishTileX, self.finishTileY = LevelGenerator:createLevel(self)

    -- entities in the level
    self.entities = {}

    -- game objects in the level
    self.objects = {}
    self:generateObjects()
    self:spawnZelda(zeldaHealth)

    -- reference to protector for collisions, etc.
    self.protector = {}

    -- used for centering the level rendering
    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    -- used for spawning enemies at a certain frequency
    self.waitDuration = 0
    self.waitTimer = 0
    self.enemySpawned = 0

    -- maximum enemy spawned depends on the level
    self.maxEnemySpawn = 20 * (1 + 0.1*levelNumber)

    -- position in the grid which we're highlighting
    self.HighlightX = 0
    self.HighlightY = 0

    -- timer used to switch the highlight rect's color
    self.rectHighlighted = false

    -- tile we're currently highlighting
    self.highlightedTile = nil

    -- flag to check if user is choosing protectors
    self.isChoosing = false
    self.showInfo = false
    self.protectorTypeInfo = nil
    self.protectorCostInfo = nil

    self.coinTally = coinTally
    self.zeldaHealth = zeldaHealth

    local songList = {'bwc', 'fight1', 'fight2', 'fight3', 'fight5_cy', 'fight6_city', 'fight7_sd', 'fight9'}
    local song = math.random(#songList)

    self.songList = songList
    self.song = song

    gSounds['music']:stop()
    gSounds[songList[song]]:setLooping(true)
    gSounds[songList[song]]:play()


end

--[[
    Spawn Zelda
]]
function Level:spawnZelda(zeldaHealth)

    -- spawn Zelda
    local zelda
    zelda = Entity {
        animations = ENTITY_DEFS['zelda'].animations,

        -- ensure X and Y are on the finish tile
        x = self.finishTileX * TILE_SIZE,
        y = self.finishTileY * TILE_SIZE,
        walkSpeed = 0,
        isStatic = true,
        isZelda = true,
        
        width = 16,
        height = 32,

        health = zeldaHealth,
        maxHealth = 5,
        stateMachine = StateMachine {
            ['idle'] = function() return EntityIdleState(zelda, self) end
        }
    }

    zelda:changeState('idle')

    table.insert(self.entities, zelda)
end

--[[
    Randomly creates an assortment of obstacles for the protector to navigate around.
]]
function Level:generateObjects()

    -- add flowers to the list of objects at random location on the map
    for i = 1, 10 do

        -- randomize flower's position
        local flowerX = math.floor(math.random(MAP_RENDER_OFFSET_X + TILE_SIZE, 
            VIRTUAL_WIDTH - TILE_SIZE * 2 - 16)/TILE_SIZE) * TILE_SIZE
        local flowerY = math.floor(math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE, 
            VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)/TILE_SIZE) * TILE_SIZE
        
        -- create flower
        local flower = GameObject(
            GAME_OBJECT_DEFS['flower'],
            flowerX,
            flowerY
        )

        -- define a function for the flower so that player can also accumulate budget by attacking flowers
        flower.onCollide = function()
            
            self.coinTally = self.coinTally + 10
            gSounds['coin']:play()
        end
        
        table.insert(self.objects, flower)
    end

    -- create coin sign for coin tally
    local coin = GameObject(
            GAME_OBJECT_DEFS['coin'],
            VIRTUAL_WIDTH - TILE_SIZE * 4,
            0
        )
        
    table.insert(self.objects, coin)
    
    -- create monster starting position sign
    local startSign = GameObject(
        GAME_OBJECT_DEFS['sign'],
        self.startEnemyTileX * TILE_SIZE,
        self.startEnemyTileY * TILE_SIZE
    )
    
    table.insert(self.objects, startSign)
end

function Level:update(dt)

    self.wasChoosing = false
    self.showInfo = false

    for k, object in pairs(self.objects) do
        object:update(dt)

        -- trigger click callback on icon
        if object.clickable and self:isHoveredOver(object) then
            if love.mouse.wasPressed(1) then
                object:onClick()
                self.wasChoosing = true
            else
                object:onHover()
            end
        end

        -- remove arrow and bullet after hitting the wall
        if object.projectile and object:hitWall() then
            table.remove(self.objects, k)
        end

        -- deal damage to enemy collided with the arrow and bullet
        for i, entity in pairs(self.entities) do
            if object.projectile and not entity.dead and entity:collides(object) and not entity.isZelda and not entity.isProtector and not entity.alreadyHit then
                object.onCollide(entity)
            end
        end

        if object.projectile then
            -- test for flower collission with other objects and protectors
            for j, shinyObject in pairs(self.objects) do
                if shinyObject.isShiny and object:collides(shinyObject) then
                    shinyObject.onCollide()
                    table.remove(self.objects, j)
                end
            end
        end
    end

    if self:checkVictory() then
        gSounds['victory']:play()
        gSounds[self.songList[self.song]]:stop()

        gStateMachine:change('victory', {
            levelNumber = self.levelNumber,
            coinTally = self.coinTally,
            zeldaHealth = self.zeldaHealth
        })
    end

    -- get mouse grid positions
    local mouseGridX, mouseGridY = self:getMouseGrids()

    -- if left-clicked, to select a tile..
    if love.mouse.wasPressed(1) and not self.wasChoosing then

        self.HighlightX = mouseGridX
        self.HighlightY = mouseGridY
            
        -- initiate x and y by adding 2 since level starts at (2, 2)
        local x = self.HighlightX + 2
        local y = self.HighlightY + 2

        if self:invalidSelect(x, y) then
            gSounds['error']:play()
            self:clearClickables()
            self.highlightedTile = nil
        else
            gSounds['select']:play()
            self:clearClickables()
            self.highlightedTile = self.tiles[y][x]
            
            -- render icons for user to choose for building the tower
            self:spawnIcons(x, y)
        end
    end

    for k, protector in pairs(self.protector) do
        protector:update(dt)
    end

    -- spawn enemies in a certain frequency
    if self.waitDuration == 0 then
        self.waitDuration = 2
    else
        self.waitTimer = self.waitTimer + dt
    end

    if self.waitTimer > self.waitDuration and self.enemySpawned < self.maxEnemySpawn then

        -- spawn enemies
        self:spawnEnemy()
        self.waitTimer = 0
        self.enemySpawned = self.enemySpawned + 1
    end

    -- update for all enemies
    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- remove entity from the table if health is <= 0
        if entity.health <= 0 then

            -- chance to spawn a heart when an enemy is killed
            if not entity.dead and not entity.isZelda then
                self.coinTally = self.coinTally + entity.reward
                gSounds['coin']:play()
            end
            entity.dead = true
            table.remove(self.entities, i)
        elseif not entity.dead then
            entity:processAI({level = self}, dt)
            entity:update(dt)
        end

        if not entity.dead and entity.reachedZelda then
            local zeldaIndex = self:returnZeldaEntityIndex()

            gSounds['hit-player']:play()
            self.entities[zeldaIndex]:damage(1)
            self.zeldaHealth = self.entities[zeldaIndex].health
            entity.dead = true
            table.remove(self.entities, i)

            if self.entities[zeldaIndex].health == 0 then
                gStateMachine:change('game-over')
                gSounds[self.songList[self.song]]:stop()
            end
        end
    end
end

function Level:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY)
        end
    end

    local clickableObjects = 0

    for k, object in pairs(self.objects) do
        object:render()
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render() end
    end
    
    if #self.protector > 0 then
        for k, protector in pairs(self.protector) do
            protector:render()
        end
    end

     -- render highlighted tile if it exists
     if self.highlightedTile then
        
        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', self.HighlightX * TILE_SIZE + TILE_SIZE + MAP_RENDER_OFFSET_X,
            self.HighlightY * TILE_SIZE + TILE_SIZE + MAP_RENDER_OFFSET_Y, 16, 16, 4)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- render highlight rect color
    if self.rectHighlighted then
        love.graphics.setColor(217/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(172/255, 50/255, 50/255, 1)
    end

    -- draw actual cursor rect
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.HighlightX * TILE_SIZE + TILE_SIZE + MAP_RENDER_OFFSET_X,
        self.HighlightY * TILE_SIZE + TILE_SIZE + MAP_RENDER_OFFSET_Y, 16, 16, 4)
    
    -- print coin tally
    love.graphics.printf('x '..tostring(self.coinTally), 0, 0, VIRTUAL_WIDTH, 'right')

    -- print protector selection option info when protector icon is hovered over
    if self.showInfo then
        love.graphics.printf(tostring(self.protectorTypeInfo)..' cost: $'..tostring(self.protectorCostInfo), 0, VIRTUAL_HEIGHT - TILE_SIZE, VIRTUAL_WIDTH, 'right')
    end
end

-- function to spawn enemies based on level
function Level:spawnEnemy()

    local typesLevelOne = {'bull', 'pig'}
    local typesLevelTwo = {'bat', 'frog'}
    local typesLevelThree = {'devil', 'skeleton'}
    local typesLevelFour = {'ghost', 'demon'}
    local types

    if self.levelNumber <= 2 then
        types = typesLevelOne
    elseif self.levelNumber <= 4 then
        types = typesLevelTwo
    elseif self.levelNumber <= 6 then
        types = typesLevelThree
    else
        types = typesLevelFour
    end

    local type = math.random(#types)

    local enemy
    enemy = Entity {
        animations = ENTITY_DEFS[types[type]].animations,
        walkSpeed = ENTITY_DEFS[types[type]].walkSpeed * (1 + 0.1*self.levelNumber),

        -- ensure X and Y are on the starting tile
        x = self.startEnemyTileX * TILE_SIZE,
        y = self.startEnemyTileY * TILE_SIZE,
        
        width = 16,
        height = 16,

        health = 6,
        reward = ENTITY_DEFS[types[type]].reward,
        stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(enemy) end,
            ['idle'] = function() return EntityIdleState(enemy) end
        }
    }

    enemy:changeState('walk')
    table.insert(self.entities, enemy)
end

-- function to spawn hammer protector
function Level:spawnProtectorHammer(x, y)

    local protector
    protector = Protector {
        animations = ENTITY_DEFS['protector-hammer'].animations,
        
        x = x,
        y = y,
        
        width = 16,
        height = 16,
        isProtector = true,
        price = ENTITY_DEFS['protector-hammer'].price,
        attack = ENTITY_DEFS['protector-hammer'].attack,

        -- rendering and collision offset for spaced sprites
        offsetY = -TILE_SIZE,

        stateMachine = StateMachine {
                ['idle'] = function() return ProtectorHammerIdleState(protector, self) end,
                ['swing-hammer'] = function() return ProtectorSwingHammerState(protector, self) end
        }
    }

    protector:changeState('idle')

    table.insert(self.protector, protector)

    -- charge protector cost
    self.coinTally = self.coinTally - protector.price

end

-- function to spawn crossbow protector
function Level:spawnProtectorCrossbow(x, y)

    local protector
    protector = Protector {
        animations = ENTITY_DEFS['protector-crossbow'].animations,
        
        x = x,
        y = y,
        
        width = 16,
        height = 16,
        isProtector = true,
        price = ENTITY_DEFS['protector-crossbow'].price,
        attack = ENTITY_DEFS['protector-crossbow'].attack,

        -- rendering and collision offset for spaced sprites
        offsetY = -TILE_SIZE,
        stateMachine = StateMachine {
            ['idle'] = function() return ProtectorCrossbowIdleState(protector, self) end,
            ['shoot-crossbow'] = function() return ProtectorShootCrossbowState(protector, self) end
        }
    }

    protector:changeState('idle')

    table.insert(self.protector, protector)

    -- charge protector cost
    self.coinTally = self.coinTally - protector.price

end

-- function to spawn rockets protector
function Level:spawnProtectorRockets(x, y)

    local protector
    protector = Protector {
        animations = ENTITY_DEFS['protector-rockets'].animations,
        
        x = x,
        y = y,
        
        width = 16,
        height = 16,
        isProtector = true,
        price = ENTITY_DEFS['protector-rockets'].price,
        attack = ENTITY_DEFS['protector-rockets'].attack,

        -- rendering and collision offset for spaced sprites
        offsetY = -TILE_SIZE,
        stateMachine = StateMachine {
            ['idle'] = function() return ProtectorRocketsIdleState(protector, self) end,
            ['fire-rockets'] = function() return ProtectorFireRocketsState(protector, self) end
        }
    }

    protector:changeState('idle')

    table.insert(self.protector, protector)

    -- charge protector cost
    self.coinTally = self.coinTally - protector.price

end

-- function to get x and y mouse grid positions
function Level:getMouseGrids()
    local mouseX, mouseY = love.mouse.getPosition()

    mouseX, mouseY = push:toGame(mouseX, mouseY)

    mouseGridX = math.floor(math.max(0, math.min(mouseX - MAP_RENDER_OFFSET_X - TILE_SIZE, (MAP_WIDTH - 2) * TILE_SIZE - MAP_RENDER_OFFSET_X)/TILE_SIZE))
    mouseGridY = math.floor(math.max(0, math.min(mouseY - MAP_RENDER_OFFSET_Y - TILE_SIZE, (MAP_HEIGHT - 1) * TILE_SIZE - MAP_RENDER_OFFSET_Y)/TILE_SIZE))

    return mouseGridX, mouseGridY
end

-- function to return whether the selected tile is allowed for building towers
-- prevent players from building tower on a tile with existing protector or enemy tracks
function Level:invalidSelect(x, y)
    return self.tiles[y][x].protectorSpawned or self.tiles[y][x].id == TILE_ENEMY_TRACK or self.tiles[y][x].id == TILE_FINISH or self.tiles[y][x].id == TILE_START
end

-- function to return if the target is been clicked on
function Level:isHoveredOver(target)
    local mouseX, mouseY = love.mouse.getPosition()

    mouseX, mouseY = push:toGame(mouseX, mouseY)

    return not (mouseX < target.x or mouseX > target.x + target.width or
                mouseY < target.y or mouseY > target.y + target.height)
end

-- function to clear all clickable objects from the level
function Level:clearClickables()
    for i = #self.objects, 1, -1 do
        if self.objects[i].clickable then
            table.remove(self.objects, i)
        end
    end
end

-- render icons for user to choose for building the tower
function Level:spawnIcons(x, y)

    -- spawn hammer protector icon
    if self.coinTally >= PROTECTOR_HAMMER_PRICE then
        local hammerIcon = GameObject(
            GAME_OBJECT_DEFS['hammer-icon'],
            x * TILE_SIZE  + (TILE_SIZE - GAME_OBJECT_DEFS['hammer-icon'].width)/2 - GAME_OBJECT_DEFS['hammer-icon'].width - 2,
            y * TILE_SIZE - GAME_OBJECT_DEFS['hammer-icon'].height
        )

        -- define a function for the icon to spawn protector when clicked on
        hammerIcon.onClick = function()

            self:spawnProtectorHammer(x * TILE_SIZE, y * TILE_SIZE)
            self.tiles[y][x].protectorSpawned = true
            gSounds['confirm']:play()
            self:clearClickables()
        end

        -- define a function for the icon to show protector info when hovered on
        hammerIcon.onHover = function()
            self.showInfo = true
            self.protectorTypeInfo = 'Hammer Protector'
            self.protectorCostInfo = PROTECTOR_HAMMER_PRICE
        end

        -- add to list of objects in scene
        table.insert(self.objects, hammerIcon)
    end
    
    -- spawn crossbow protector icon
    if self.coinTally >= PROTECTOR_CROSSBOW_PRICE then
        -- render crossbow icon for user to choose for building the tower
        local crossbowIcon = GameObject(
            GAME_OBJECT_DEFS['crossbow-icon'],
            x * TILE_SIZE + (TILE_SIZE - GAME_OBJECT_DEFS['crossbow-icon'].width)/2,
            y * TILE_SIZE - GAME_OBJECT_DEFS['crossbow-icon'].height
        )

        -- define a function for the icon to spawn protector when clicked on
        crossbowIcon.onClick = function()

            self:spawnProtectorCrossbow(x * TILE_SIZE, y * TILE_SIZE)
            self.tiles[y][x].protectorSpawned = true
            gSounds['confirm']:play()
            self:clearClickables()
        end

        -- define a function for the icon to show protector info when hovered on
        crossbowIcon.onHover = function()
            self.showInfo = true
            self.protectorTypeInfo = 'Crossbow Protector'
            self.protectorCostInfo = PROTECTOR_CROSSBOW_PRICE
        end

        -- add to list of objects in scene
        table.insert(self.objects, crossbowIcon)
    end

    -- spawn rockets protector icon
    if self.coinTally >= PROTECTOR_ROCKETS_PRICE then
        -- render rockets icon for user to choose for building the tower
        local rocketsIcon = GameObject(
            GAME_OBJECT_DEFS['rockets-icon'],
            x * TILE_SIZE  + (TILE_SIZE - GAME_OBJECT_DEFS['rockets-icon'].width)/2 + GAME_OBJECT_DEFS['rockets-icon'].width + 2,
            y * TILE_SIZE - GAME_OBJECT_DEFS['rockets-icon'].height
        )

        -- define a function for the icon to spawn protector when clicked on
        rocketsIcon.onClick = function()

            self:spawnProtectorRockets(x * TILE_SIZE, y * TILE_SIZE)
            self.tiles[y][x].protectorSpawned = true
            gSounds['confirm']:play()
            self:clearClickables()
        end

        -- define a function for the icon to show protector info when hovered on
        rocketsIcon.onHover = function()
            self.showInfo = true
            self.protectorTypeInfo = 'Rockets Protector'
            self.protectorCostInfo = PROTECTOR_ROCKETS_PRICE
        end

        -- add to list of objects in scene
        table.insert(self.objects, rocketsIcon)
    end
end

-- function to check if victory is achieved within current level
function Level:checkVictory()
    return #self.entities <= 1 and self.enemySpawned == self.maxEnemySpawn
end

-- function to return entity index of Zelda
function Level:returnZeldaEntityIndex()
    for i = 1, #self.entities do
        if self.entities[i].isZelda then
            return i
        end
    end
end