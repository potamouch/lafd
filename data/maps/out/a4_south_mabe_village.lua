local map = ...
local game = map:get_game()
-- Outside - South village

-- Includes scripts
local owl_manager = require("scripts/maps/owl_manager")
local companion_manager = require("scripts/maps/companion_manager")

-- Functions

function map:set_music()

  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/out/overworld")
  end

end

function map:open_dungeon_1()

  dungeon_1_entrance:get_sprite():set_animation("opened")
  dungeon_1_entrance:set_traversable_by(true)

end

-- Events

function map:on_started(destination)

  map:set_music()
  map:set_digging_allowed(true)
  companion_manager:init_map(map)
  owl_1:set_enabled(false)
  owl_4:set_enabled(false)
  if sword ~= nil then
    sword:get_sprite():set_direction(4)
  end
  dungeon_1_entrance:set_traversable_by(false)
  if game:get_value("main_quest_step") > 6 then
    map:open_dungeon_1()
  end

  -- Seashell's tree
  local seashell_tree_found = false
  collision_seashell:add_collision_test("facing", function(entity, other, entity_sprite, other_sprite)
    if other:get_type() == 'hero' and hero:get_state() == "running" and seashell_tree_found == false and game:get_value("seashell_14") == nil then
      sol.timer.start(map, 250, function()
        movement = sol.movement.create("jump")
        movement:set_speed(100)
        movement:set_distance(64)
        movement:set_direction8(0)
        movement:set_ignore_obstacles(true)
        movement:start(seashell_14, function()
          seashell_tree_found = true 
        end)
      end)
    end
  end)

end

function owl_1_sensor:on_activated()

  if game:get_value("owl_1") == true then
    map:set_music()
  else
    owl_manager:appear(map, 1, function()
    map:set_music()
    end)
  end

end

function owl_4_sensor:on_activated()

  if game:get_value("main_quest_step") == 8  and game:get_value("owl_4") ~= true then
    owl_manager:appear(map, 4, function()
    map:set_music()
    end)
  end

end


function dungeon_1_lock:on_interaction()

      if game:get_value("main_quest_step") < 6 then
          game:start_dialog("maps.out.south_mabe_village.dungeon_1_lock")
      elseif game:get_value("main_quest_step") == 6 then
        sol.audio.stop_music()
        hero:freeze()
        sol.timer.start(map, 1000, function() 
          sol.audio.play_sound("shake")
          local camera = map:get_camera()
          local shake_config = {
              count = 32,
              amplitude = 4,
              speed = 90,
          }
          camera:shake(shake_config, function()
            sol.audio.play_sound("secret_2")
            local sprite = dungeon_1_entrance:get_sprite()
            sprite:set_animation("opening")
            sol.timer.start(map, 800, function() 
              map:open_dungeon_1()
              hero:unfreeze()
              map:set_music()
            end)
          end)
          game:set_value("main_quest_step", 7)
        end)
      end

end