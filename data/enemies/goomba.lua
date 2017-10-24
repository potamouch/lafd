-- Lua script of enemy goomba.
-- This script is executed every time an enemy with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest
local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite
local movement

-- Event called when the enemy is initialized.
function enemy:on_created()

  -- Initialize the properties of your enemy here,
  -- like the sprite, the life and the damage.
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_life(1)
  enemy:set_damage(1)
  
end

-- Event called when the enemy should start or restart its movements.
-- This is called for example after the enemy is created or after
-- it was hurt or immobilized.
function enemy:on_restarted()

  local sprite = self:get_sprite()
  local is_dead = false
  local direction4 = sprite:get_direction()
  movement = sol.movement.create("path")
  movement:set_path{direction4 * 2}
  movement:set_speed(32)
  movement:set_loop(true)
  movement:start(self)
 sol.timer.start(enemy, 10, function()
      if not is_dead then
        local x_hero, y_hero = hero:get_position()
        local x_enemy, y_enemy = enemy:get_position()
        if x_hero >= x_enemy - 16 and x_hero < x_enemy + 16 and y_hero < y_enemy then
          enemy:set_can_attack(false)
          if y_hero >= y_enemy - 16 and y_hero < y_enemy + 16 then
            is_dead = true
            movement:stop()
            sprite:set_animation("crushed")
            function sprite:on_animation_finished(animation)
              sol.audio.play_sound("switch")
              enemy:remove()
            end
          end
        else
          enemy:set_can_attack(true)
        end
      end
      return true 
  end)
 

end

function enemy:on_obstacle_reached()

  local sprite = self:get_sprite()
  local direction4 = sprite:get_direction()
  sprite:set_direction((direction4 + 2) % 4)

  self:restart()
end
