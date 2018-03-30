-- Lua script of map houses/west_mt_tamaranch/.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")
local draw_picture = false

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  companion_manager:init_map(map)

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function map:talk_to_mr_write() 

  if draw_picture == false then
    local item = game:get_item("magnifying_lens")
    local variant = item:get_variant()
    if variant < 9 then
        game:start_dialog("maps.houses.west_mt_tamaranch.mr_write_house.mr_write_1")
    elseif variant >= 10 then
       game:start_dialog("maps.houses.west_mt_tamaranch.mr_write_house.mr_write_5")
    else
        game:start_dialog("maps.houses.west_mt_tamaranch.mr_write_house.mr_write_2", function()
          -- Hide or show HUD.
          game:set_hud_enabled(false)
          -- Prevent or allow the player from pausing the game
          game:set_pause_allowed(false)
          draw_picture = true
          local disappear_picture = false
          local opacity = 0
          local peach_sprite = sol.sprite.create("pictures/peach")
          local white_surface =  sol.surface.create(320, 256)
          local black_surface = sol.surface.create(320, 80)
          white_surface:fill_color({255, 255, 255})
          black_surface:fill_color({0, 0, 0})
          function map:on_draw(dst_surface)
            if draw_picture then
              white_surface:set_opacity(opacity)
              peach_sprite:draw(white_surface, 116, 64)
              white_surface:draw(dst_surface)
              black_surface:draw(white_surface, 0, 179)
              if disappear_picture == false then
                opacity = opacity + 2
                if opacity > 255 then
                  opacity = 255
                end
              else
                opacity = opacity - 2
                if opacity <= 0 then
                  draw_picture = false
                  game:start_dialog("maps.houses.west_mt_tamaranch.mr_write_house.mr_write_3", function(answer)
                    if answer == 1 then
                      hero:start_treasure("magnifying_lens", 10)
                    else
                      map:talk_to_mr_write_2()
                    end
                  end)
                end
              end
            end
          end
          sol.timer.start(mr_write, 5000, function()
            disappear_picture = true
          end)
        end)
    end
  end

end

function map:talk_to_mr_write_2()
  game:start_dialog("maps.houses.west_mt_tamaranch.mr_write_house.mr_write_4", function(answer)
    if answer == 1 then
      hero:start_treasure("magnifying_lens", 10)
    else
      map:talk_to_mr_write_2()
    end
  end)
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
