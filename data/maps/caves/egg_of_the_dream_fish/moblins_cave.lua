-- Lua script of map houses/egg_of_the_dream_fish/moblins_house.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local launch_boss = false
require("scripts/multi_events")
local door_manager = require("scripts/maps/door_manager")
local separator_manager = require("scripts/maps/separator_manager")
local companion_manager = require("scripts/maps/companion_manager")


function map:set_music()
  
  if game:get_value("main_quest_step") == 9  then
    sol.audio.play_music("maps/out/moblins_and_bow_wow")
  else
    sol.audio.play_music("maps/caves/cave")
  end

end

function map:on_started()
  map:set_music()
  moblin_chief:get_sprite():set_animation("sitting")
  local step = game:get_value("main_quest_step")
  if step ~= 9 then
    for enemy in map:get_entities_by_type("enemy") do
      enemy:remove()
    end
    bowwow:remove()
    map:set_doors_open("door_group", true)
  end
  companion_manager:init_map(map)

end

function map:on_opening_transition_finished(destination)

  local step = game:get_value("main_quest_step")
  if step ~= nil and step ~= 9 then
    return
  end
  map:set_doors_open("door_group_1", true)
  door_manager:close_if_enemies_not_dead(map, "enemy_group_1", "door_group_1")
  game:start_dialog("maps.caves.egg_of_the_dream_fish.moblins_cave.moblins_1")

end

 -- Doors

door_manager:open_when_enemies_dead(map,  "enemy_group_1",  "door_group_1")
door_manager:open_when_enemies_dead(map,  "enemy_group_2",  "door_group_1")
door_manager:open_when_enemies_dead(map,  "enemy_group_3",  "door_group_1")

function sensor_2:on_activated()

  local step = game:get_value("main_quest_step")
  if step ~= nil and step ~= 9 then
    return
  end
  local x_moblin_chief, y_moblin_chief = moblin_chief:get_position()
  moblin_chief:get_sprite():set_animation("sitting_text")
  moblin_chief:get_sprite():set_direction(0)
  hero:freeze()
  game:set_hud_enabled(false)
  game:set_pause_allowed(false)
  game:set_suspended(true)
  game:start_dialog("maps.caves.egg_of_the_dream_fish.moblins_cave.moblins_2", function()
      moblin_chief:get_sprite():set_animation("walking")
      moblin_chief:get_sprite():set_ignore_suspend(true)
      moblin_chief.xy = { x = x_moblin_chief, y = y_moblin_chief }
      local movement = sol.movement.create("target")
      movement:set_speed(96)
      movement:set_target(moblin_chief_finished)
      movement:set_ignore_obstacles(true)
      movement:start(moblin_chief.xy)
      function movement:on_position_changed(coord_x, coord_y)
        moblin_chief:set_position(coord_x, coord_y)
      end
      function movement:on_finished()
        moblin_chief:set_enabled(false)
        door_manager:close_if_enemies_not_dead(map, "enemy_group_2", "door_group_1")
        game:set_hud_enabled(true)
        game:set_pause_allowed(true)
        game:set_suspended(false)
        hero:unfreeze()
      end
  end)

end

function sensor_3:on_activated()

  local step = game:get_value("main_quest_step")
  if step ~= nil and step ~= 9 then
    return
  end
  if launch_boss then
    return
  end
  launch_boss = true
  door_manager:close_if_enemies_not_dead(map, "enemy_group_3", "door_group_1")
  game:start_dialog("maps.caves.egg_of_the_dream_fish.moblins_cave.moblins_3", function()
    enemy_group_3_1:start_battle()
  end)

end

function sensor_4:on_activated()

  local step = game:get_value("main_quest_step")
  if step ~= nil and step ~= 9 then
    return
  end
  for enemy in map:get_entities_by_type("enemy") do
    enemy:remove()
  end
  sol.audio.play_sound("treasure_2")
  game:start_dialog("maps.caves.egg_of_the_dream_fish.moblins_cave.bowwow_1", function()
    game:set_value("main_quest_step", 10)
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
  end)

end
local step = game:get_value("main_quest_step")
if step == 9 then
  separator_manager:manage_map(map)
end