-- Lua script of map houses/egg_of_the_dream_fish/moblins_house.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
require("scripts/multi_events")
local door_manager = require("scripts/maps/door_manager")
local separator_manager = require("scripts/maps/separator_manager")

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function map:on_opening_transition_finished(destination)

  map:set_doors_open("door_group_1", true)
  door_manager:close_if_enemies_not_dead(map, "enemy_group_1", "door_group_1")
  game:start_dialog("maps.caves.egg_of_the_dream_fish.moblins_cave.moblins_1")

end

 -- Doors

door_manager:open_when_enemies_dead(map,  "enemy_group_1",  "door_group_1")
door_manager:open_when_enemies_dead(map,  "enemy_group_2",  "door_group_1")
door_manager:open_when_enemies_dead(map,  "enemy_group_3",  "door_group_1")

function sensor_2:on_activated()

  door_manager:close_if_enemies_not_dead(map, "enemy_group_2", "door_group_1")

end

function sensor_3:on_activated()

  door_manager:close_if_enemies_not_dead(map, "enemy_group_3", "door_group_1")
  game:start_dialog("maps.caves.egg_of_the_dream_fish.moblins_cave.moblins_2")

end

function sensor_4:on_activated()

  local x,y, layer = bowwow:get_position()
  local name =  bowwow:get_name()
  bowwow:remove()
  bowwow = map:create_custom_entity({
      name = "bowwow",
      sprite = "npc/bowwow",
      x = x,
      y = y,
      width = 16,
      height = 16,
      layer = layer,
      direction = 0,
      model =  "bowwow_follow"
    })

end

separator_manager:manage_map(map)