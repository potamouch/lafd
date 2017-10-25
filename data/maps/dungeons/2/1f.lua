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
local boss_key_enemies_index = 0

require("scripts/multi_events")
local door_manager = require("scripts/maps/door_manager")
local treasure_manager = require("scripts/maps/treasure_manager")
local switch_manager = require("scripts/maps/switch_manager")
local enemy_manager = require("scripts/maps/enemy_manager")
local light_manager = require("scripts/maps/light_manager")
local separator_manager = require("scripts/maps/separator_manager")
local owl_manager = require("scripts/maps/owl_manager")


function map:on_started()

  -- Init music
  game:play_dungeon_music()
  treasure_manager:disappear_pickable(map, "pickable_small_key_1")
  treasure_manager:disappear_pickable(map, "pickable_small_key_2")
  treasure_manager:disappear_pickable(map, "heart_container")
  treasure_manager:appear_chest_if_savegame_exist(map, "chest_compass",  "dungeon_2_compass")
  treasure_manager:appear_chest_if_savegame_exist(map, "chest_small_key_4",  "dungeon_2_small_key_4")
  treasure_manager:appear_chest_if_savegame_exist(map, "chest_power_bracelet",  "dungeon_2_power_bracelet")
  treasure_manager:appear_chest_if_savegame_exist(map, "chest_boss_key",  "dungeon_2_boss_key")
  switch_manager:activate_switch_if_savegame_exist(map, "switch_1",  "dungeon_2_small_key_4")
  enemy_manager:create_teletransporter_if_small_boss_dead(map, false)
  light_manager:init(map)

end

function map:on_opening_transition_finished(destination)
    if destination == dungeon_2_1_B then
      game:start_dialog("maps.dungeons.2.welcome")
    end
    map:set_doors_open("door_group_4", true)
    map:set_doors_open("door_group_small_boss", true)
end

-- Enemies

-- Treasures
treasure_manager:appear_pickable_when_enemies_dead(map, "enemy_group_2", "pickable_small_key_1", nil)
treasure_manager:appear_pickable_when_enemies_dead(map, "enemy_group_5", "pickable_small_key_2", nil)
treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_3", "chest_compass")
treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_17", "chest_power_bracelet")

-- Doors
door_manager:open_when_torches_lit(map, "auto_torch_group_1", "door_group_1")
door_manager:open_when_enemies_dead(map,  "enemy_group_8",  "door_group_4")
door_manager:open_when_enemies_dead(map,  "enemy_group_16",  "door_group_3")

--Blocks
door_manager:open_when_blocks_moved(map, "block_group_1", "door_group_2")


-- Sensors events


function sensor_1:on_activated()

  if is_small_boss_active == false then
    is_small_boss_active = true
    enemy_manager:launch_small_boss_if_not_dead(map)
  end

end

function sensor_2:on_activated()

  if is_small_boss_active == false then
    is_small_boss_active = true
    enemy_manager:launch_small_boss_if_not_dead(map)
  else
    map:close_doors("door_group_small_boss_1")
    map:close_doors("door_group_small_boss_2")
  end

end

function sensor_3:on_activated()

  door_manager:close_if_enemies_not_dead(map, "enemy_group_8", "door_group_4")

end

function sensor_4:on_activated()

  if is_boss_active == false then
    is_boss_active = true
    enemy_manager:launch_boss_if_not_dead(map)
  end

end

-- Enemies events

enemy_group_15_1:register_event("on_dead", function()
  if boss_key_enemies_index == 0 then
    boss_key_enemies_index = 1
  end
end)

enemy_group_15_2:register_event("on_dead", function()
  if boss_key_enemies_index == 1 then
    boss_key_enemies_index = 2
  end
end)

enemy_group_15_3:register_event("on_dead", function()
  if boss_key_enemies_index == 2 then
    treasure_manager:appear_chest(map, "chest_boss_key", true)
  end
end)

-- Switchs events

function switch_1:on_activated()

  treasure_manager:appear_chest(map, "chest_small_key_4", true)

end


-- Treasures events

function map:on_obtaining_treasure(item, variant, savegame_variable)

    if savegame_variable == "dungeon_2_big_treasure_test" then
      treasure_manager:get_instrument(map, 2)
    end

end


-- Separator events

auto_separator_2:register_event("on_activated", function(separator, direction4)

    map:set_light(0)

end)

auto_separator_4:register_event("on_activating", function(separator, direction4)
  local x, y = hero:get_position()
  if direction4 == 2 then
    map:set_light(0)
  end
end)

auto_separator_4:register_event("on_activated", function(separator, direction4)

  if direction4 ~= 2 then
    map:set_light(1)
  end
end)

auto_separator_11:register_event("on_activating", function(separator, direction4)
  local x, y = hero:get_position()
  if direction4 == 1 then
    map:set_light(0)
  end
end)

auto_separator_11:register_event("on_activated", function(separator, direction4)

  if direction4 ~= 1 then
    map:set_light(1)
  end
end)

auto_separator_21:register_event("on_activated", function(separator, direction4)

    map:set_light(0)

end)

auto_separator_25:register_event("on_activating", function(separator, direction4)
  local x, y = hero:get_position()
  if direction4 == 2 then
    map:set_light(0)
  end
end)

auto_separator_25:register_event("on_activated", function(separator, direction4)

  if direction4 ~= 2 then
    map:set_light(1)
  end
end)

separator_manager:manage_map(map)
owl_manager:manage_map(map)

