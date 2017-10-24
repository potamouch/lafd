-- Lua script of map dungeons/1/b1.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local separator = ...
local game = map:get_game()
local is_small_boss_active = false
local is_boss_active = false

require("scripts/multi_events")
local door_manager = require("scripts/maps/door_manager")
local treasure_manager = require("scripts/maps/treasure_manager")
local switch_manager = require("scripts/maps/switch_manager")
local enemy_manager = require("scripts/maps/enemy_manager")
local separator_manager = require("scripts/maps/separator_manager")
local owl_manager = require("scripts/maps/owl_manager")


function map:on_started()

  -- Init music
  game:play_dungeon_music()

end

function map:on_opening_transition_finished(destination)

end

-- Enemies

-- Treasures

-- Doors

--Blocks

-- Sensors events



-- Enemies events

-- Switchs events

-- Treasures events

-- Separator events


