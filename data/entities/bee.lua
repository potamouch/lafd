-- Lua script of custom entity frog.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local map = entity:get_map()
local sprite = entity:get_sprite()

-- Event called when the custom entity is initialized.
function entity:on_created()

  self:set_can_traverse("hero", false)
  local direction4 = math.random(4) - 1
  local m = sol.movement.create("straight")
  m:set_speed(0)
  m:start(self)
  self:go(direction4)

end

function entity:go(direction4)

  -- Set the sprite.
  sprite:set_direction(direction4)

  -- Set the movement.
  local m = self:get_movement()
  local max_distance = 40
  m:set_max_distance(max_distance)
  m:set_smooth(true)
  m:set_speed(20)
  m:set_angle(direction4 * math.pi / 2)
end

function entity:on_movement_finished(movement)

  local direction4 = math.random(4) - 1
  self:go(direction4)

end

function entity:on_obstacle_reached(movement)

  local direction4 = math.random(4) - 1
  self:go(direction4)

end