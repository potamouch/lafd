-- Lua script of custom entity bowwow.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local map = entity:get_map()
local chains_entities = {}
local chain_manager = require("scripts/maps/chain_manager")


-- Event called when the custom entity is initialized.
function entity:on_created()

  entity:set_traversable_by(false)
  entity:set_can_traverse("hero", false)
  local movement = sol.movement.create("random")
  movement:set_speed(20)
  movement:set_smooth(false)
  movement:set_max_distance(16)
  movement:start(entity)
  local source = map:get_entity("chain_source")
  chain_manager:init_map(map, entity, source)


end

