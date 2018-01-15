-- Lua script of map dungeons/1/1f.
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
  map:set_doors_open("door_group_1", true)
  treasure_manager:appear_chest_if_savegame_exist(map, "chest_small_key_1",  "dungeon_3_small_key_3")
  treasure_manager:appear_chest_if_savegame_exist(map, "chest_rupee_1",  "dungeon_3_rupee_1")

end

function map:on_opening_transition_finished(destination)       

    map:set_doors_open("door_group_2", true)
    if destination == dungeon_3_1_B then
      game:start_dialog("maps.dungeons.3.welcome")
    end
    map:close_doors("door_group_1")
end

-- Enemies

-- Treasures

-- Doors
door_manager:open_when_pot_break(map, "door_group_1")
door_manager:open_when_enemies_dead(map,  "enemy_group_3",  "door_group_2")

--Blocks

-- Sensors events

function sensor_1:on_activated()

  door_manager:close_if_enemies_not_dead(map, "enemy_group_3", "door_group_2")

end

function sensor_2:on_activated()

  door_manager:close_if_enemies_not_dead(map, "enemy_group_3", "door_group_2")

end

function sensor_3:on_activated()

  door_manager:close_if_enemies_not_dead(map, "enemy_group_3", "door_group_2")

end


-- Enemies events

-- Switchs events

-- Treasures events
treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_2", "chest_small_key_1")
treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_5", "chest_rupee_1")

-- Separator events

separator_manager:manage_map(map)
owl_manager:manage_map(map)

