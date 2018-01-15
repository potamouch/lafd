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
  treasure_manager:appear_chest_if_savegame_exist(map, "chest_map",  "dungeon_6_map")

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished(destination)

  if destination == dungeon_6_1_B then
    map:set_doors_open("door_group_1", true)
    map:set_doors_open("door_group_3", true)
    game:start_dialog("maps.dungeons.6.welcome")
  end

end

-- Treasures

treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_5", "chest_map")
treasure_manager:appear_pickable_when_enemies_dead(map, "enemy_group_9", "pickable_small_key_1", nil)


-- Doors

door_manager:open_when_enemies_dead(map,  "enemy_group_1",  "door_group_1")
door_manager:open_when_switch_activated(map,  "switch_1",  "door_group_2")
door_manager:open_when_pot_break(map, "door_group_3")
door_manager:open_when_pot_break(map, "door_group_5")
door_manager:open_when_pot_break(map, "door_group_6")
door_manager:open_when_enemies_dead(map,  "enemy_group_2",  "door_group_4")


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
