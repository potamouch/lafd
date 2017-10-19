-- Lua script of map houses/mabe_village/ocarina_house_dream.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local separator_manager = require("scripts/maps/separator_manager")

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function map:on_started(destination)

  hero:set_enabled(true)
 local white_surface =  sol.surface.create(320, 256)
  local opacity = 255
  white_surface:fill_color({255, 255, 255})
  function map:on_draw(dst_surface)
    white_surface:set_opacity(opacity)
    white_surface:draw(dst_surface)
    opacity = opacity -1
    if opacity < 0 then
      opacity = 0
    end
  end

end
separator_manager:manage_map(map)