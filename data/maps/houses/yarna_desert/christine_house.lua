-- Lua script of map houses/yarna_desert/christines_house.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  companion_manager:init_map(map)

end

function map:talk_to_christine() 

      game:start_dialog("maps.houses.yarna_desert.christine_house.christine_1")

end


function christine:on_collision_fire()

      return false

end

function christine:on_interaction()

      map:talk_to_christine()

end

function christine_invisible:on_interaction()

      map:talk_to_christine()

end
