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

local door_manager = require("scripts/maps/door_manager")
local treasure_manager = require("scripts/maps/treasure_manager")
local switch_manager = require("scripts/maps/switch_manager")
local enemy_manager = require("scripts/maps/enemy_manager")

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  local treasure = {"small_key", 1, "dungeon_1_small_key_2"}
  treasure_manager:appear_chest_when_savegame_exist(map, "dungeon_1_small_key_2_appear", treasure, "placeholder_small_key_2")
  switch_manager:activate_when_savegame_exist(map, "dungeon_1_small_key_2_appear", "switch_1")
  enemy_manager:create_teletransporter_if_small_boss_dead(map, "dungeon_1_small_boss", false)

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished(destination)
    if destination == dungeon_1_1_B then
      map:set_doors_open("door_group_1", true)
      map:set_doors_open("door_group_2", false)
      map:set_doors_open("door_group_3", true)
      map:set_doors_open("door_group_5", true)
      game:start_dialog("maps.dungeons.1.welcome")
    end
    if destination == stairs_1_B then
      map:set_doors_open("door_group_1", true)
      map:set_doors_open("door_group_2", true)
      map:set_doors_open("door_group_3", true)
    end

end

-- Enemies
  enemy_manager:execute_when_vegas_dead(map, "enemy_group_13")

-- Treasures

local treasure = {"small_key", 1, "dungeon_1_small_key_1"}
treasure_manager:appear_pickable_when_enemies_dead(map, "enemy_group_7", treasure, "placeholder_small_key_1", "dungeon_1_small_key_1_appear", true)
local treasure = {"rupee", 3, "dungeon_1_rupee_1"}
treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_12", treasure, "placeholder_rupee_1", "dungeon_1_rupee_1_appear", true)
local treasure = {"beak_of_stone", 1, "dungeon_1_beak_of_stone"}
treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_13", treasure, "placeholder_beak_of_stone", "dungeon_1_beak_of_stone", true)

-- Doors

door_manager:open_when_enemies_dead(map,  "enemy_group_6",  "door_group_1")
door_manager:open_when_enemies_dead(map,  "enemy_group_3",  "door_group_5")
door_manager:open_if_small_boss_dead(map,  "dungeon_1_small_boss",  "door_group_3")
-- Sensors events

function sensor_1:on_activated()

  door_manager:close_if_enemies_not_dead(map, "enemy_group_6", "door_group_1")

end

function sensor_2:on_activated()

  door_manager:close_if_enemies_not_dead(map, "enemy_group_6", "door_group_1")

end

function sensor_3:on_activated()

  if is_small_boss_active == false then
    is_small_boss_active = true
    enemy_manager:launch_small_boss_if_not_dead(map, "dungeon_1_small_boss", "door_group_3",  "placeholder_small_boss", 1)
  end

end

function sensor_4:on_activated()

  if is_boss_active == false then
    is_boss_active = true
    enemy_manager:launch_boss_if_not_dead(map, "dungeon_1_boss", "door_group_4", "placeholder_boss", 1)
  end

end

function sensor_5:on_activated()


  door_manager:close_if_enemies_not_dead(map, "enemy_group_3", "door_group_5")

end

-- Switchs events

function switch_1:on_activated()

  local treasure = {"small_key", 1, "dungeon_1_small_key_2"}
  treasure_manager:appear_chest(map, treasure, "placeholder_small_key_2", "dungeon_1_small_key_2_appear", true)

end

-- Blocks events

function block_1:on_moved()

  map:open_doors("door_group_2")

end

-- Treasures events

function map:on_obtaining_treasure(item, variant, savegame_variable)

    if savegame_variable == "dungeon_1_instrument" then
      treasure_manager:get_instrument(map, 1)
    end

end


-- Doors events

function weak_wall_A_1:on_opened()

  weak_wall_closed_A_1:remove();
  weak_wall_closed_A_2:remove();
  sol.audio.play_sound("secret_1")

end
