-- Lua script of map dungeons/1/1f.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local separator = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
local treasure_manager = require("scripts/maps/treasure_manager")
local enemy_manager = require("scripts/maps/enemy_manager")

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished(destination)
    if destination == dungeon_1_1_B then
      map:set_doors_open("dungeon_1_door_group_1", true)
      map:set_doors_open("dungeon_1_door_group_2", false)
      map:set_doors_open("dungeon_1_door_group_3", true)
      map:set_doors_open("dungeon_1_door_group_5", true)
      game:start_dialog("dungeon_1")
    end
    if destination == dungeon_1_stairs_1_B then
      door_manager:open(map, "dungeon_1_door_group_1", false)
      door_manager:open(map, "dungeon_1_door_group_2", false)
      door_manager:open(map, "dungeon_1_door_group_3", false)
    end

end

-- Enemies
  enemy_manager:execute_when_vegas_dead(map, "dungeon_1_enemy_group_13")

-- Treasures

treasure_manager:appear_when_enemies_dead(map, "dungeon_1_enemy_group_7", "pickable", "small_key", 1, 744, 1384, 0, "dungeon_1_small_key_1")
treasure_manager:appear_when_enemies_dead(map, "dungeon_1_enemy_group_12", "chest", "rupee", 3, 904, 856, 0, "dungeon_1_chest_rupee_1")
treasure_manager:appear_when_enemies_dead(map, "dungeon_1_enemy_group_13", "chest", "beak_of_stone", 1, 1864, 608, 0, "dungeon_1_chest_beak_of_stone")

-- Doors

door_manager:open_when_enemies_dead(map,  "dungeon_1_enemy_group_6",  "dungeon_1_door_group_1")
door_manager:open_when_enemies_dead(map,  "dungeon_1_enemy_group_3",  "dungeon_1_door_group_5")

-- Sensors events

function dungeon_1_sensor_1:on_activated()

  door_manager:close_if_enemies_not_dead(map, "dungeon_1_enemy_group_6", "dungeon_1_door_group_1")

end

function dungeon_1_sensor_2:on_activated()

  door_manager:close_if_enemies_not_dead(map, "dungeon_1_enemy_group_6", "dungeon_1_door_group_1")

end

function dungeon_1_sensor_3:on_activated()

  enemy_manager:launch_small_boss_if_not_dead(map, "dungeon_1_small_boss", "dungeon_1_door_group_3")

end

function dungeon_1_sensor_4:on_activated()

  enemy_manager:launch_boss_if_not_dead(map, "dungeon_1_boss", "dungeon_1_door_group_4")

end

function dungeon_1_sensor_5:on_activated()


  door_manager:close_if_enemies_not_dead(map, "dungeon_1_enemy_group_3", "dungeon_1_door_group_5")

end

-- Switchs events

function dungeon_1_switch_1:on_activated()

  treasure_manager:appear(map, "chest", "small_key", 1, 1224, 1112, 0, "dungeon_1_small_key_2")

end

-- Blocks events

function dungeon_1_block_1:on_moved()

  map:open_doors("dungeon_1_door_group_2")

end

-- Treasures events

function map:on_obtaining_treasure(item, variant, savegame_variable)

    if savegame_variable == "dungeon_1_instrument" then
      treasure_manager:get_instrument(map, 1)
    end

end

