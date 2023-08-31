--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com

    Creates randomized levels. Returns a table of tiles
    that the game can render, based on the current level we're at
    in the game
]]

LevelGenerator = Class{}

function LevelGenerator:init()
end

--[[
    Creates a table of tiles to be returned to the main game, with different
    possible ways of randomizing rows and columns of tiles. Calculates the
    enemy tracks based on the level passed in.
]]
function LevelGenerator:createLevel(level)
    local tiles = {}

    for y = 1, level.height do
        table.insert(tiles, {})

        for x = 1, level.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == level.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == level.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == level.width and y == level.height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == level.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == level.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(tiles[y], {
                id = id,

                -- tag to track if protector is spawned on a particular tile
                -- default to false
                protectorSpawned = false
            })
        end
    end

    -- generate randomized enemy track
    -- start enemy track somewhere close to top left of the map
    local trackX = 2
    local trackY = math.random(2, level.height/2 - 1)
    tiles[trackY][trackX].id = TILE_START
    local startTileX = trackX
    local startTileY = trackY
    local finishTileX, finishTileY

    -- generate enemy track until it reaches bottom right of the map
    while(true) 
    do
        local directionList = self:getPossibleDirection(tiles, trackX, trackY)
        local direction = math.random(#directionList)
        trackY = trackY + directionList[direction][1]
        trackX = trackX + directionList[direction][2]
        if tiles[trackY][trackX + 1].id == TILE_RIGHT_WALLS[1] and tiles[trackY + 1][trackX].id == TILE_BOTTOM_WALLS[1] then
            tiles[trackY][trackX].id = TILE_FINISH
            finishTileX = trackX
            finishTileY = trackY - 1
            break
        else
            tiles[trackY][trackX].id = TILE_ENEMY_TRACK
        end
    end

    return tiles, startTileX, startTileY, finishTileX, finishTileY
end

-- function to return possible directions based on surrounding tiles
function LevelGenerator:getPossibleDirection(tiles, currentX, currentY)

    -- no left and up {-1, 0} moves
    local directionList = {{0, 1}, {1, 0}}
    local potentialX, potentialY

    for k, direction in pairs(directionList) do
        potentialY = currentY + direction[1]
        potentialX = currentX + direction[2]
        if tiles[potentialY][potentialX].id == TILE_ENEMY_TRACK or tiles[potentialY][potentialX].id == TILE_START or tiles[potentialY][potentialX].id == TILE_BOTTOM_WALLS[1] or tiles[potentialY][potentialX].id == TILE_RIGHT_WALLS[1] then
            table.remove(directionList, k)
        end
    end

    return directionList
end