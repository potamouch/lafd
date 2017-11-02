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

-- Event called when the custom entity is initialized.
function entity:on_created()

  self:set_can_traverse("hero", false)
  local movement = sol.movement.create("random")
  movement:set_speed(20)
  movement:set_smooth(false)
  movement:set_max_distance(10)
  movement:start(entity)

end