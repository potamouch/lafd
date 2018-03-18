-- Lua script of map caves/egg_of_the_dream_fish/cave_1.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local separator_manager = require("scripts/maps/separator_manager")
local companion_manager = require("scripts/maps/companion_manager")

separator_manager:manage_map(map)

function map:on_started()

  companion_manager:init_map(map)

  --Invisible things: only visible with the Lens
  if game:get_value("get_lens") then
    map:set_entities_enabled("invisible_entity",true)
  else
    map:set_entities_enabled("invisible_entity",false)
  end

end

--Invisible things: only visible with the Lens
function map:on_obtained_treasure(item, variant, treasure_savegame_variable)
  if item:get_name() == "magnifying_lens" and item:get_variant() == 14 then
    map:set_entities_enabled("invisible_entity",true)
  end
end