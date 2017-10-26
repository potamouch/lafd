-- Lua script of map inside_richard_house.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

function map:on_started()

  companion_manager:init_map(map)

end

function  map:talk_to_richard() 

   if game:get_value("main_quest_step") < 12 then
    game:start_dialog("maps.houses.south_prairie.richard_villa.richard_1")
   else
    game:start_dialog("maps.houses.south_prairie.richard_villa.richard_2", function(answer)
        if answer == 1 then
          game:start_dialog("maps.houses.south_prairie.richard_villa.richard_4")
        else
          game:start_dialog("maps.houses.south_prairie.richard_villa.richard_3")
        end
    end)
  end

end


function richard:on_interaction()

      map:talk_to_richard()

end


for wardrobe in map:get_entities("wardrobe") do
  function wardrobe:on_interaction()
    game:start_dialog("maps.houses.wardrobe_1", game:get_player_name())
  end
end
