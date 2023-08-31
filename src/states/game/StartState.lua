--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

StartState = Class{__includes = BaseState}

function StartState:update(dt)
    gSounds['music']:play()

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.wasPressed(1) then
        gStateMachine:change('play', {
            levelNumber = 1,
            coinTally = 100,
            zeldaHealth = 5,
        })
    end
end

function StartState:render()
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

    love.graphics.setFont(gFonts['zelda'])
    love.graphics.setColor(34/255, 34/255, 34/255, 1)
    love.graphics.printf('Zelda Protector', 2, VIRTUAL_HEIGHT / 2 - 90, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    love.graphics.printf('Zelda Protector', 0, VIRTUAL_HEIGHT / 2 - 92, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['zelda-small'])
    love.graphics.printf('Press Enter or Left Click', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
end