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
  if game:get_value("richard_box_moved") then
    local x,y,layer = box_place:get_position()
    box:set_position(x,y,layer)
  end
  if game:get_value("main_quest_step") > 14 then
    local x,y,layer = richard_place:get_position()
    richard:set_position(x,y,layer)
  end

end

function  map:talk_to_richard() 

   if game:get_value("main_quest_step") < 12 then
    game:start_dialog("maps.houses.south_prairie.richard_villa.richard_1")
   elseif game:get_value("main_quest_step") > 14 then
    game:start_dialog("maps.houses.south_prairie.richard_villa.richard_8")
   else
    local item = game:get_item("golden_leaves_counter")
    local num = item:get_amount()
    if num == nil then
      game:start_dialog("maps.houses.south_prairie.richard_villa.richard_2", function(answer)
          if answer == 1 then
            game:start_dialog("maps.houses.south_prairie.richard_villa.richard_4")
          else
            game:start_dialog("maps.houses.south_prairie.richard_villa.richard_3")
          end
      end)
    else
      if num == 5 then
        game:start_dialog("maps.houses.south_prairie.richard_villa.richard_7", function()
          game:set_value("main_quest_step", 15) 
          item:set_amount(0)
          local movement = sol.movement.create("target")
          movement:set_speed(30)
          movement:set_target(richard_place)
          movement:start(richard)
          function movement:on_finished()
            richard:get_sprite():set_direction(3)
          end
        end)
      else
        game:start_dialog("maps.houses.south_prairie.richard_villa.richard_6", game:get_player_name())
      end
    end
  end

end


function richard:on_interaction()

      map:talk_to_richard()

end

function box:on_moved()

  game:set_value("richard_box_moved", true) 

end


for wardrobe in map:get_entities("wardrobe") do
  function wardrobe:on_interaction()
    game:start_dialog("maps.houses.wardrobe_1", game:get_player_name())
  end
end
