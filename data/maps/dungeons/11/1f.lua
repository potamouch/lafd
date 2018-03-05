-- Lua script of map dungeons/11/1f.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local light_manager = require("scripts/maps/light_manager")

function map:on_started()
  light_manager:init(map)
  map:set_light(0)
end

function map:on_opening_transition_finished()

end
