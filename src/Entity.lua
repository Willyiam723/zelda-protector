--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

Entity = Class{}

function Entity:init(def)

    self.direction = 'down'

    self.animations = self:createAnimations(def.animations)

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- drawing offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.walkSpeed = def.walkSpeed or 0

    self.health = def.health
    self.maxHealth = def.maxHealth

    self.isStatic = def.isStatic or false
    self.isZelda = def.isZelda or false
    self.isProtector = def.isProtector or false

    -- flags for flashing the entity when hit
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0

    -- timer for turning transparency on and off, flashing
    self.flashTimer = 0

    self.dead = false

    -- track if entity has already been hit so that damage won't be dealt during vulnerable time
    self.alreadyHit = false

    self.stateMachine = def.stateMachine
    self.reward = def.reward or 0
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

--[[
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function Entity:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

-- function to deal damage or gain health by dealing negative damage
-- but ensure the maximum health is capped at 6
function Entity:damage(dmg)
    self.health = math.min(6, self.health - dmg)
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
            self.alreadyHit = false
        end
    end

    self.stateMachine:update(dt)

    if self.isStatic then
        self:changeAnimation(self.health .. '-health')
    end

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:render()
    
    -- draw sprite slightly transparent if invulnerable every 0.04 seconds
    if self.invulnerable and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end

    self.stateMachine:render()
    love.graphics.setColor(1, 1, 1, 1)
end