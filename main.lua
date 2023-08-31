--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Zelda Protector')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.graphics.setFont(gFonts['small'])

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
    love.mouse.mousePressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
    
    -- add to our table of buttons pressed this frame
    love.mouse.mousePressed[button] = true
end

function love.mouse.wasPressed(button)
    if love.mouse.mousePressed[button] then
        return true
    else
        return false
    end
end

function love.update(dt)
    Timer.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.mousePressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end