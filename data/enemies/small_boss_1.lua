-- Lua script of enemy boss_small_1.
-- This script is executed every time an enemy with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local enemy = ...
local spike
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite_enemy
local sprite_spike
local movement_enemy
local movement_spike
local direction_spike = math.pi
local direction_enemy = 0
-- Event called when the enemy is initialized.
function enemy:on_created()

  local x,y,layer = enemy:get_position()
  sprite_enemy = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_life(4)
  enemy:set_damage(1)
  spike = map:create_enemy{
    sprite = "enemies/rolling_spike_vertical",
    breed = "rolling_spike_vertical",
    direction = 2,
    x = x - 64,
    y = y,
    layer = layer
  }
  sprite_spike = spike:get_sprite()
  enemy:go_to_spike()

end

function enemy:go_to_spike()

  movement_enemy = sol.movement.create("target")
  movement_enemy:set_target(spike)
  movement_enemy:set_speed(64)
  movement_enemy:start(enemy)
  function movement_enemy:on_finished()
    movement_enemy:stop()
    sol.timer.start(enemy, 1000, function()
      enemy:go_on_the_other_side()
    end)
    enemy:push_spike()
  end

end

function enemy:push_spike()

    movement_spike = sol.movement.create("straight")
    movement_spike:set_speed(64)
    movement_spike:set_angle(direction_spike)
    movement_spike:set_max_distance(200)
    sprite_spike:set_animation("walking")
    function movement_spike:on_obstacle_reached()
        direction_spike = math.pi - direction_spike
        movement_spike:set_angle(direction_spike)
        movement_spike:set_max_distance(64)
    end
    function movement_spike:on_finished()
      sprite_spike:set_animation("stopped")
    end
    movement_spike:start(spike)

end

function enemy:go_on_the_other_side()

  direction_enemy = math.pi - direction_enemy
  movement_enemy = sol.movement.create("straight")
  movement_enemy:set_speed(64)
  movement_enemy:set_angle(direction_enemy)
  function movement_enemy:on_obstacle_reached()
      enemy:change_direction()
      movement_enemy:stop()
      enemy:go_to_spike()
  end
  movement_enemy:start(enemy)

end

function enemy:change_direction()

  local direction = sprite_enemy:get_direction()
  if direction == 0 then
    sprite_enemy:set_direction(2)
  else
    sprite_enemy:set_direction(0)
  end
end
