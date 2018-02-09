-- Lua script of map caves/forest/cave_1.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local separator_manager = require("scripts/maps/separator_manager")
local companion_manager = require("scripts/maps/companion_manager")
local light_manager = require("scripts/maps/light_manager")

separator_manager:manage_map(map)

function map:on_started()

  companion_manager:init_map(map)
  light_manager:init(map)
  map:set_light(0)

end