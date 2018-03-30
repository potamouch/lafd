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
  local item = game:get_item("magnifying_lens")
  local variant = item:get_variant()
  if variant >= 9 then
     local hibiscus_sprite = hibiscus:get_sprite()
     hibiscus_sprite:set_animation("full")
  end


end

function map:talk_to_christine() 

  local item = game:get_item("magnifying_lens")
  local variant = item:get_variant()
  if variant < 8 then
    game:start_dialog("maps.houses.yarna_desert.christine_house.christine_1")
  elseif variant == 8 then
    game:start_dialog("maps.houses.yarna_desert.christine_house.christine_2", function(answer)
      if answer == 1 then
        game:start_dialog("maps.houses.yarna_desert.christine_house.christine_4", function()
            local hibiscus_sprite = hibiscus:get_sprite()
            hibiscus_sprite:set_animation("full")
            hero:start_treasure("magnifying_lens", 9, nil, function()
            end)
        end)
      else
        game:start_dialog("maps.houses.yarna_desert.christine_house.christine_3")
      end
    end)
  else
    game:start_dialog("maps.houses.yarna_desert.christine_house.christine_5")
  end

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
