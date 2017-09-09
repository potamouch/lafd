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
local light_manager = require("scripts/maps/light_manager")

-- Event called at initialization time, as soon as this map becomes is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished(destination)
    if destination == dungeon_2_1_B then
      game:start_dialog("maps.dungeons.2.welcome")
    end
end

-- Enemies

-- Treasures
local treasure = {"small_key", 1, "dungeon_2_small_key_1"}
treasure_manager:appear_pickable_when_enemies_dead(map, "enemy_group_2", treasure, "placeholder_small_key_1")
local treasure = {"compass", 1, "dungeon_2_compass"}
treasure_manager:appear_chest_when_enemies_dead(map, "enemy_group_3", treasure, "placeholder_compass")
local treasure = {"small_key", 1, "dungeon_2_small_key_2"}
treasure_manager:appear_pickable_when_enemies_dead(map, "enemy_group_5", treasure, "placeholder_small_key_2")

-- Doors
door_manager:open_when_torches_lit(map, "torch_group_1", "door_group_1")

--Blocks
door_manager:open_when_blocks_moved(map, "block_group_1", "door_group_2")


-- Switchs events

function switch_1:on_activated()

  local treasure = {"small_key", 1, "dungeon_1_small_key_3"}
  treasure_manager:appear_chest(map, treasure, "placeholder_small_key_3")

end


-- Treasures events

function map:on_obtaining_treasure(item, variant, savegame_variable)

    if savegame_variable == "dungeon_2_instrument" then
      treasure_manager:get_instrument(map, 2)
    end

end

-- Separator events

separator_1:register_event("on_activating", function(separator, direction4)

  local x, y = hero:get_position()
  if direction4 == 1 then
    map:set_light(0)
  end
end)

separator_1:register_event("on_activated", function(separator, direction4)

  if direction4 ~= 1 then
    map:set_light(1)
  end
end)


separator_2:register_event("on_activating", function(separator, direction4)

  local x, y = hero:get_position()
  if direction4 == 0 then
    map:set_light(0)
  end
end)

separator_2:register_event("on_activated", function(separator, direction4)

  if direction4 ~= 0 then
    map:set_light(1)
  end
end)

