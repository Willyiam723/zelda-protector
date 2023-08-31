--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Hitbox'
require 'src/Protector'
require 'src/StateMachine'
require 'src/Util'
require 'src/Projectile'
require 'src/LevelGenerator'

require 'src/world/Level'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/protector/ProtectorHammerIdleState'
require 'src/states/entity/protector/ProtectorSwingHammerState'
require 'src/states/entity/protector/ProtectorCrossbowIdleState'
require 'src/states/entity/protector/ProtectorShootCrossbowState'
require 'src/states/entity/protector/ProtectorRocketsIdleState'
require 'src/states/entity/protector/ProtectorFireRocketsState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/VictoryState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/sheet.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['victory'] = love.graphics.newImage('graphics/victory.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['monsters'] = love.graphics.newImage('graphics/monster/monsters.png'),
    ['enemy-health'] = love.graphics.newImage('graphics/healthbar.png'),
    ['zelda-stand'] = love.graphics.newImage('graphics/zelda.png'),
    ['zelda-fall'] = love.graphics.newImage('graphics/zelda.png'),
    ['arrows-horizontal'] = love.graphics.newImage('graphics/protectors/arrows.png'),
    ['arrows-vertical'] = love.graphics.newImage('graphics/protectors/arrows.png'),
    ['bullets-horizontal'] = love.graphics.newImage('graphics/protectors/bullets.png'),
    ['bullets-vertical'] = love.graphics.newImage('graphics/protectors/bullets.png'),
    ['crossbow'] = love.graphics.newImage('graphics/protectors/crossbow.png'),
    ['rockets'] = love.graphics.newImage('graphics/protectors/rockets.png'),
    ['hammer'] = love.graphics.newImage('graphics/protectors/hammer.png'),
    ['hammer-icon'] = love.graphics.newImage('graphics/protectors/hammer-icon.png'),
    ['crossbow-icon'] = love.graphics.newImage('graphics/protectors/crossbow-icon.png'),
    ['rockets-icon'] = love.graphics.newImage('graphics/protectors/rockets-icon.png'),
    ['coin'] = love.graphics.newImage('graphics/coins_and_bombs.png'),
    ['sign'] = love.graphics.newImage('graphics/ladders_and_signs.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png')
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['monsters'] = GenerateQuads(gTextures['monsters'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['enemy-health'] = GenerateQuads(gTextures['enemy-health'], 32, 10),
    ['zelda-stand'] = GenerateQuads(gTextures['zelda-stand'], 16, 32),
    ['zelda-fall'] = GenerateQuads(gTextures['zelda-fall'], 16, 16),
    ['arrows-horizontal'] = GenerateQuads(gTextures['arrows-horizontal'], 16, 5),
    ['arrows-vertical'] = GenerateQuads(gTextures['arrows-vertical'], 5, 16),
    ['bullets-horizontal'] = GenerateQuads(gTextures['bullets-horizontal'], 16, 8),
    ['bullets-vertical'] = GenerateQuads(gTextures['bullets-vertical'], 8, 16),
    ['crossbow'] = GenerateQuads(gTextures['crossbow'], 45.5, 32),
    ['rockets'] = GenerateQuads(gTextures['rockets'], 56, 32),
    ['hammer'] = GenerateQuads(gTextures['hammer'], 44.5, 32),
    ['hammer-icon'] = GenerateQuads(gTextures['hammer-icon'], 10, 10),
    ['crossbow-icon'] = GenerateQuads(gTextures['crossbow-icon'], 10, 10),
    ['rockets-icon'] = GenerateQuads(gTextures['rockets-icon'], 10, 10),
    ['coin'] = GenerateQuads(gTextures['coin'], 16, 16),
    ['sign'] = GenerateQuads(gTextures['sign'], 16, 16)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['zelda-extra-small'] = love.graphics.newFont('fonts/zelda.otf', 16)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['sword'] = love.audio.newSource('sounds/sword.wav', 'static'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav', 'static'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
    ['coin'] = love.audio.newSource('sounds/coin.wav', 'static'),
    ['bwc'] = love.audio.newSource('sounds/bwc.mp3', 'static'),
    ['fight1'] = love.audio.newSource('sounds/fight1.mp3', 'static'),
    ['fight2'] = love.audio.newSource('sounds/fight2.mp3', 'static'),
    ['fight3'] = love.audio.newSource('sounds/fight3.mp3', 'static'),
    ['fight5_cy'] = love.audio.newSource('sounds/fight5_cy.mp3', 'static'),
    ['fight6_city'] = love.audio.newSource('sounds/fight6_city.mp3', 'static'),
    ['fight7_sd'] = love.audio.newSource('sounds/fight7_sd.mp3', 'static'),
    ['fight9'] = love.audio.newSource('sounds/fight9.mp3', 'static'),
    ['nextlevel'] = love.audio.newSource('sounds/nextlevel.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static')
}