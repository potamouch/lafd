-- Lua script of custom entity diggable.
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

  local index1, index2, index3, index4 = map:get_entity_position_indexes(entity)
  map:set_square_diggable(index1, false)
  map:set_square_diggable(index2, false)
  map:set_square_diggable(index3, false)
  map:set_square_diggable(index4, false)
  entity:remove()
end
