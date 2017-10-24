-- Lua script of map houses/west_mt_tamaranch/.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  companion_manager:init_map(map)

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function map:talk_to_mr_write() 

      game:start_dialog("maps.houses.west_mt_tamaranch.mr_write_house.mr_write_1")

end


function mr_write:on_collision_fire()

      return false

end

function mr_write:on_interaction()

      map:talk_to_mr_write()

end

function mr_write_invisible:on_interaction()

      map:talk_to_mr_write()

end

for wardrobe in map:get_entities("wardrobe") do
  function wardrobe:on_interaction()
    game:start_dialog("maps.houses.wardrobe_1", game:get_player_name())
  end
end
