-- Lua script of map houses/yarna_desert/bears_house.
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
  if game:get_value("main_quest_step") > 20 then
    ananas:set_enabled(false)
  end

end

function map:talk_to_bear()

  if game:get_value("main_quest_step") < 20 then
    game:start_dialog("maps.houses.yarna_desert.bear_house.bear_1")
  elseif game:get_value("main_quest_step") == 20  then
    game:start_dialog("maps.houses.yarna_desert.bear_house.bear_2", function(answer)
      if answer == 1 then
        ananas:set_enabled(false)
        hero:start_treasure("magnifying_lens", 7, "magnifying_lens_6", function()
          game:start_dialog("maps.houses.yarna_desert.bear_house.bear_4")
        end)
      else
        game:start_dialog("maps.houses.yarna_desert.bear_house.bear_3")
      end
    end)
  else
    game:start_dialog("maps.houses.yarna_desert.bear_house.bear_4")
  end

end

function bear:on_interaction()

  map:talk_to_bear()

end

function bear_invisible:on_interaction()

  map:talk_to_bear()

end


for wardrobe in map:get_entities("wardrobe") do
  function wardrobe:on_interaction()
    game:start_dialog("maps.houses.wardrobe_1", game:get_player_name())
  end
end
