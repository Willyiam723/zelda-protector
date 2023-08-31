--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
end

function PlayState:enter(params)
    self.level = Level(params.levelNumber, params.coinTally, params.zeldaHealth)
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self.level:update(dt)
end

function PlayState:render()

    -- render level and all entities separate from hearts GUI
    love.graphics.push()
    self.level:render()
    love.graphics.pop()
end