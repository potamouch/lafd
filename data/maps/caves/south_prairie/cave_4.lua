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

end

for trader in map:get_entities("trader") do
  function trader:on_interaction()
    local dialog
    if game:get_value("get_boomerang") then dialog = "maps.houses.south_prairie.boomerang_cave.recover_item_before_question" else dialog = "maps.houses.south_prairie.boomerang_cave.boomerang_question" end
    game:start_dialog(dialog, function(answer)
        if answer == 1 then
          if game:get_value("get_boomerang") then
            game:set_value("get_boomerang",false)
            hero:start_treasure("shovel",1)
            if game:get_item_assigned(1) == game:get_item("boomerang") then game:set_item_assigned(1, game:get_item("shovel")) end
            if game:get_item_assigned(2) == game:get_item("boomerang") then game:set_item_assigned(2, game:get_item("shovel")) end
          else
            hero:start_treasure("boomerang",1,"get_boomerang")
            if game:get_item_assigned(1) == game:get_item("shovel") then game:set_item_assigned(1, game:get_item("boomerang")) end
            if game:get_item_assigned(2) == game:get_item("shovel") then game:set_item_assigned(2, game:get_item("boomerang")) end
          end
        else
          game:start_dialog("maps.houses.south_prairie.boomerang_cave.no", game:get_player_name())
        end
    end)
  end
end