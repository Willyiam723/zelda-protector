--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:update(dt)
    gSounds['game-over']:play()
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.wasPressed(1) then
        gSounds['game-over']:stop()
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['zelda'])
    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2 - 48, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['zelda-small'])
    love.graphics.printf('Press Enter or Left Click', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
end