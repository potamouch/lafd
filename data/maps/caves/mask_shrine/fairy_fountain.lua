-- Lua script of map caves/prairie/fairys_fountain.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()


-- Includes scripts
local fairy_manager = require("scripts/maps/fairy_manager")
local companion_manager = require("scripts/maps/companion_manager")

function map:on_started()

  companion_manager:init_map(map)
  fairy_manager:init_map(map, "fairy")

end





function fairy_fountain:on_activated()

  fairy_manager:launch_fairy_if_hero_not_max_life(map, "fairy")

end