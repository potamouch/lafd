-- Lua script of map houses/yarna_desert/house_of_the_painter.
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
  sol.timer.start(hippo, 2000, function()
    hippo:get_sprite():set_animation("embarrassed")
  end)

end

function map:talk_to_hippo()

  --local hero = map:get_hero()
  local direction = hero:get_direction()
  hippo:get_sprite():set_direction(direction)
  game:start_dialog("maps.houses.yarna_desert.painter_house.hippo_1")

end

function map:talk_to_painter()

  local direction4 = painter:get_direction4_to(hero)
  painter:get_sprite():set_animation("waiting")
  painter:get_sprite():set_direction(direction4)
  game:start_dialog("maps.houses.yarna_desert.painter_house.painter_1", function()
    painter:get_sprite():set_animation("painting")
  end)

end

function hippo:on_interaction()

  map:talk_to_hippo()

end

function painter:on_interaction()

  map:talk_to_painter()

end

function painter_invisible_1:on_interaction()

  map:talk_to_painter()

end

function painter_invisible_2:on_interaction()

  map:talk_to_painter()

end

function painter_invisible_3:on_interaction()

  map:talk_to_painter()

end

function painter_invisible_4:on_interaction()

  map:talk_to_painter()

end

for wardrobe in map:get_entities("wardrobe") do
  function wardrobe:on_interaction()
    game:start_dialog("maps.houses.wardrobe_1", game:get_player_name())
  end
end
