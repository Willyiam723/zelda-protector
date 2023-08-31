--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.levelNumber = params.levelNumber
    self.coinTally = params.coinTally
    self.zeldaHealth = params.zeldaHealth
end

function VictoryState:update(dt)
    gSounds['nextlevel']:play()

    -- go to play screen if the player presses Enter or left clicked
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.wasPressed(1) then
        gSounds['nextlevel']:stop()
        gStateMachine:change('play', {
            levelNumber = self.levelNumber + 1,
            coinTally = self.coinTally + self.levelNumber * 50,
            zeldaHealth = self.zeldaHealth
        })
    end
end

function VictoryState:render()

    love.graphics.draw(gTextures['victory'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['victory']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['victory']:getHeight())

    -- level complete text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.levelNumber) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter or Left Click to start next level!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end