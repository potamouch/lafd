-- Lua script of map houses/kanalet_castle/kanalet_castle_b1.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

    if game:get_value("castle_door_is_open") then
      switch_1:set_activated(true)
    end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end


function switch_1:on_activated()
  
  if game:get_value("castle_door_is_open") == nil then
    game:set_value("castle_door_is_open", true)
    hero:set_direction(3)
    hero:freeze()
    sol.timer.start(map, 1000, function()
      sol.audio.play_sound("castle_door")
      local camera = map:get_camera()
      local shake_config = {
          count = 32,
          amplitude = 4,
          speed = 90,
      }
      camera:shake(shake_config, function()
        game:start_dialog("maps.houses.kanalet_castle.door", function()
          hero:unfreeze()
        end)
      end)
    end)
  end
end
