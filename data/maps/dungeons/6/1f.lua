-- Lua script of map dungeons/6/1f.
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

local flying_tile_manager = require("scripts/maps/flying_tile_manager")
local door_manager = require("scripts/maps/door_manager")
local treasure_manager = require("scripts/maps/treasure_manager")
local switch_manager = require("scripts/maps/switch_manager")
local enemy_manager = require("scripts/maps/enemy_manager")
local separator_manager = require("scripts/maps/separator_manager")
local owl_manager = require("scripts/maps/owl_manager")

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  -- Init music
  game:play_dungeon_music()
  treasure_manager:disappear_pickable(map, "pickable_small_key_1")
  treasure_manager:disappear_pickable(map, "pickable_small_key_2")
  treasure_manager:appear_chest_if_savegame_exist(map, "chest_map",  "dungeon_6_map")
  door_manager:check_destroy_wall(map, "weak_wall_group_1")
  door_manager:check_destroy_wall(map, "weak_wall_group_15")
  map:set_doors_open("door_group_1", true)
  map:set_doors_open("door_group_3", true)
  map:set_doors_open("door_group_7", true)
  map:set_doors_open("door_group_18", true)
  map:set_doors_open("door_group_19", true)
  map:set_doors_open("door_group_20", true)

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished(destination_test)

  if destination_test == dungeon_6_1_B then
    game:start_dialog("maps.dungeons.6.welcome")
  end

end

-- Treasures

treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_5", "chest_map")
treasure_manager:appear_pickable_when_enemies_dead(map, "enemy_group_9", "pickable_small_key_1", nil)
treasure_manager:appear_pickable_when_flying_tiles_dead(map, "enemy_group_29_enemy", "pickable_small_key_2", nil)

-- Doors

door_manager:open_when_flying_tiles_dead(map,  "enemy_group_11_enemy",  "door_group_7")
door_manager:open_when_switch_activated(map,  "switch_1",  "door_group_2")
door_manager:open_when_pot_break(map, "door_group_3")
door_manager:open_when_pot_break(map, "door_group_5")
door_manager:open_when_pot_break(map, "door_group_6")
door_manager:open_when_pot_break(map, "door_group_8")
door_manager:open_when_enemies_dead(map,  "enemy_group_1",  "door_group_1")
door_manager:open_when_enemies_dead(map,  "enemy_group_2",  "door_group_4")
door_manager:open_when_enemies_dead(map,  "enemy_group_12",  "door_group_8")
door_manager:open_when_enemies_dead(map,  "enemy_group_12",  "door_group_10", false)
door_manager:open_when_enemies_dead(map,  "enemy_group_12",  "door_group_17", false)
door_manager:open_when_enemies_dead(map,  "enemy_group_26",  "door_group_18")
door_manager:open_when_enemies_dead(map,  "enemy_group_26",  "door_group_20", false)
door_manager:open_when_enemies_dead(map,  "enemy_group_27",  "door_group_19")
door_manager:open_when_enemies_dead(map,  "enemy_group_27",  "door_group_20", false)
-- Sensors events
function sensor_1:on_activated()

  flying_tile_manager:init(map, "enemy_group_11")

end

function sensor_2:on_activated()

  if flying_tile_manager.is_launch == false then
    map:close_doors("door_group_7")
    flying_tile_manager:launch(map, "enemy_group_11")
 end

end

function sensor_3:on_activated()

  flying_tile_manager:reset(map, "enemy_group_11")

end

function sensor_4:on_activated()

  flying_tile_manager:init(map, "enemy_group_11")
  map:set_doors_open("door_group_8", true)

end

function sensor_5:on_activated()

  if flying_tile_manager.is_launch == false then
    map:close_doors("door_group_7")
    flying_tile_manager:launch(map, "enemy_group_11")
 end

end

function sensor_6:on_activated()

  flying_tile_manager:reset(map, "enemy_group_11")
  local direction4 = hero:get_direction()
  if direction4 == 1 then
    map:close_doors("door_group_8")
  end

end

function sensor_7:on_activated()

  local direction4 = hero:get_direction()
  if direction4 == 0 then
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_8")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_10")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_17")
  end

end

function sensor_8:on_activated()

  local direction4 = hero:get_direction()
  if direction4 == 3 then
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_8")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_10")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_17")
  end

end

function sensor_9:on_activated()

  local direction4 = hero:get_direction()
  if direction4 == 1 then
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_8")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_10")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_12", "door_group_17")
  end

end

function sensor_10:on_activated()

  flying_tile_manager:reset(map, "enemy_group_11")
  map:set_doors_open("door_group_8", true)
  map:set_doors_open("door_group_10", true)
  map:set_doors_open("door_group_17", true)
  local direction4 = hero:get_direction()
  if direction4 == 1 then
      map:close_doors("door_group_8")
  end

end

function sensor_11:on_activated()

    map:set_doors_open("door_group_8", true)
    map:set_doors_open("door_group_10", true)
    map:set_doors_open("door_group_17", true)

end


function sensor_12:on_activated()

    map:set_doors_open("door_group_8", true)
    map:set_doors_open("door_group_10", true)
    map:set_doors_open("door_group_17", true)

end

function sensor_13:on_activated()

    local x,y = infinite_hallway:get_position()
    hero:set_position(x,y)

end

function sensor_14:on_collision_explosion()

   door_manager:destroy_wall(map, "weak_wall_group_1")

end

function sensor_15:on_collision_explosion()

   door_manager:destroy_wall(map, "weak_wall_group_2")

end

function sensor_16:on_activated()

  flying_tile_manager:reset(map, "enemy_group_29")
  treasure_manager:disappear_pickable(map, "pickable_small_key_2")

end

function sensor_17:on_activated()

  flying_tile_manager:init(map, "enemy_group_29")

end

function sensor_18:on_activated()

  flying_tile_manager:launch(map, "enemy_group_29")

end

function sensor_19:on_activated()

  flying_tile_manager:launch(map, "enemy_group_29")

end

function sensor_20:on_activated()

  flying_tile_manager:reset(map, "enemy_group_29")

end

function sensor_21:on_activated()

  flying_tile_manager:init(map, "enemy_group_29")

end

function sensor_22:on_activated()

  flying_tile_manager:launch(map, "enemy_group_29")

end

function sensor_23:on_activated()

    door_manager:close_if_enemies_not_dead(map, "enemy_group_26", "door_group_18")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_26", "door_group_20")

end

function sensor_24:on_activated()

    door_manager:close_if_enemies_not_dead(map, "enemy_group_26", "door_group_18")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_26", "door_group_20")

end

function sensor_25:on_activated()

    door_manager:close_if_enemies_not_dead(map, "enemy_group_26", "door_group_19")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_26", "door_group_20")

end

function sensor_26:on_activated()

    door_manager:close_if_enemies_not_dead(map, "enemy_group_27", "door_group_19")
    door_manager:close_if_enemies_not_dead(map, "enemy_group_27", "door_group_20")

end

-- Separator events


auto_separator_14:register_event("on_activating", function(separator, direction4)
  local x, y = hero:get_position()
  if direction4 == 0 then
    map:set_light(0)
  end
end)

auto_separator_14:register_event("on_activated", function(separator, direction4)

  if direction4 ~= 0 then
    map:set_light(1)
  end
end)

auto_separator_16:register_event("on_activating", function(separator, direction4)

  map:set_doors_open("door_group_3", true)
  if direction4 == 1 then
    sol.timer.start(map, 500, function()
      map:close_doors("door_group_3")
    end)
  end
end)

auto_separator_17:register_event("on_activating", function(separator, direction4)

  map:set_doors_open("door_group_1", true)
  if direction4 == 2 then
    sol.timer.start(map, 500, function()
      door_manager:close_if_enemies_not_dead(map, "enemy_group_1", "door_group_1")
    end)
  end
end)

separator_manager:manage_map(map)
owl_manager:manage_map(map)
