--[[
    GD50
    Match-3 Remake

    -- BaseState Class --

    Author: Will Dong
    willyiam723@gmail.com

    Used as the base class for all of our states.
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end