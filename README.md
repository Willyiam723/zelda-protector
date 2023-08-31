<h3> Main mechanics of the game </h3>

- A tower defense game where players can build towers (i.e. protector characters that holds weapon) using mouse (left) clicks to defend Zelda along the way
- A specific type of protector can be chosen by clicking on icon representing itself when a tile is selected in a level map
- Protector information including name and costs will be rendered at the bottom right of the screen when option icon is hovered
- The protectors built will automatically attack monsters if they are within their attacking range
- Monsters follow monster track path to reach Zelda, who is static
- A successful attack from monster is considered when it reaches Zelda
- Zelda has certain amount of HP, which gets reduced by 1 after each monster reaching Zelda
- Game over when Zelda's HP is zero
- Monsters have certain amount of HP, which are rendered as an HP bar above the monster sprite
- A monster is defeated once its HP is depleted to zero
- There is a budget constraint when player tries to build tower, which are displayed as coin tally on the top right corner of the play state
- Player is rewarded with additional coin/budget when each monster is defeated
- There are infinite levels with a certain amount of monsters in a level, which gets more and harder after each level
- Player can also accumulate budget when protectors built attacked flowers nearby

    <img src='https://github.com/Willyiam723/Willyiam723/blob/master/config/liquidity-leverage-scenario-simulation-platform.gif' width = 50%>

<h3> What’s contained in each file created </h3>

- main.lua - layout state machine and main flow of the game, including specifying to start at startstate
- Util.lua - include utility function for slicing images into quads
- StateMachine.lua - statemachine abstract
- Protector.lua - protector abstract inherent from entity. Include a method to get hitbox dimention to check for attacking range
- Projectile.lua - projectile abstract include travel speed in both x and y directions
- LevelGenerator.lua - creates randomized levels. Returns a table of tiles that the game can render, based on the level number
- Hitbox.lua - abtract for dimension and position of a particular hitbox
- GameObject.lua - game object abstract inherent from projectile, contains attributes and methods of the game objects
- game_objects.lua - table of game objects data
- Entity.lua - entity abstract, contains attributes and methods of the entities which enemy, Zelda and protectors are created from
- entity_defs.lua - table of entity objects data
- Dependencies.lua - require dependencies such as libraries, textures, frames, font and sounds
- constants.lua - hard-coded map objects or attributes
- Animation.lua - enable animations rendering for each entity and objects
- Level.lua - rendering entities, objects and tiles to the map
- BaseState.lua - abstract that is used as the base class for all states
- VictoryState.lua - state rendered when player wins a level
- StartState.lua - state rendered when player start the game
- PlayeState.lua - state rendered when playing the game in a specific level
- GameOverState.lua - state rendered when player looses a level
- EntityWalkState.lua - abstract contain algorithm on how enemy should walk
- EntityIdleState.lua - abstract contain how entity should behave when idle
- ProtectorSwingHammerState.lua - abstract for rendering hammer protector when it swings hammer
- ProtectorShootCrossbowState.lua - abstract for rendering crossbow protector when it shoots crossbow
- ProtectorRocketsIdleState.lua - abstract for rendering rockets protector when it's not attacking
- ProtectorHammerIdleState.lua - abstract for rendering hammer protector when it's not attacking
- ProtectorFireRocketsState.lua - abstract for rendering rockets protector when it fires rockets
- ProtectorCrossbowIdleState.lua - abstract for rendering crossbow protector when it's not attacking

<h3> Why made certain design decisions </h3>

- Created LevelGenerator.lua as a separate class for randomly generating a table of tiles for a level so that it can be called each time a new level is initiated
- Different types of protectors have their own idle and attacking states so that the two states can replace one another depends on whether an enemy is within the 
attacking range of the protector
- To enable automated attacking for the protectors, when an enemy is within protector's attacking range, make the protector face the correct direction and then
start the attack so that the hitbox can collide with the enemy to register a successful attack
- Weapons of crossbow and rockets protectors are created as separate game objects in the form of projectile, to check if it collided with any enemies on its path 
- Made enemy invincible for a few frames so that the damage caused by colliding with protector's weapon doesn't lead to multiple attacks if just collided once
- Made Zelda an inherentance of entity simply because it has one state, where only its health and animations are rendered slightly different
- The game is played by using mouse clicks as this allows players to build towers in a timely fashion as the enemies would get faster as the level continues

<h3> Other additional information the staff should know about the project </h3>
<h4> Instruction </h4>

- Launch the game in Love2D
- Follow the instruction in playing the game
- The game is played using mouse clicks