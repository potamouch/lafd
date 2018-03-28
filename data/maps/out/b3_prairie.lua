-- Outside - Prairie

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")
local owl_manager = require("scripts/maps/owl_manager")
local travel_manager = require("scripts/maps/travel_manager")
-- Methods - Functions

function map:set_music()
  
  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/out/overworld")
  end

end

function map:open_dungeon_3()

  dungeon_3_entrance:get_sprite():set_animation("opened")
  dungeon_3_entrance:set_traversable_by(true)

end

-- Events

function  map:talk_to_tarin() 

  game:start_dialog("maps.out.prairie.tarin_1", game:get_player_name(), function(answer)
    if answer == 1 then
      map:tarin_search_honey()
    else
      game:start_dialog("maps.out.prairie.tarin_2", game:get_player_name())
    end
  end)

end


function map:tarin_search_honey()
  local movement = sol.movement.create("jump")
  movement:set_speed(100)
  movement:set_distance(32)
  movement:set_direction8(6)
  movement:set_ignore_obstacles(true)
  movement:start(honey)
  game:set_value("main_quest_step", 19)
end

function map:on_started(destination)

  map:set_music()
  map:set_digging_allowed(true)
  owl_7:set_enabled(false)
  companion_manager:init_map(map)
  -- Travel
  travel_transporter:set_enabled(false)
  -- Statue pig
  if game:get_value("statue_pig_exploded") then
    statue_pig:remove()
  end
  dungeon_3_entrance:set_traversable_by(false)
  if game:get_value("main_quest_step") > 16 then
    map:open_dungeon_3()
  end
  -- Tarin
  if game:get_value("main_quest_step") ~= 18 then
    tarin:set_enabled(false)
  end
  -- Honey and bees
  if game:get_value("main_quest_step") > 19 then
    honey:set_enabled(false)
    for bee in map:get_entities("bee") do
        bee:set_enabled(false)
    end

  end
  -- Seashell's tree
  local seashell_tree_found = false
  collision_seashell:add_collision_test("facing", function(entity, other, entity_sprite, other_sprite)
    if other:get_type() == 'hero' and hero:get_state() == "running" and seashell_tree_found == false and game:get_value("seashell_13") == nil then
      sol.timer.start(map, 250, function()
        movement = sol.movement.create("jump")
        movement:set_speed(100)
        movement:set_distance(64)
        movement:set_direction8(0)
        movement:set_ignore_obstacles(true)
        movement:start(seashell_13, function()
          seashell_tree_found = true 
        end)
      end)
    end
  end)

end

function travel_sensor:on_activated()

    travel_manager:init(map, 1)

end

function dungeon_3_lock:on_interaction()

      if game:get_value("main_quest_step") < 16 then
          game:start_dialog("maps.out.prairie.dungeon_3_lock")
      elseif game:get_value("main_quest_step") == 16 then
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
            local sprite = dungeon_3_entrance:get_sprite()
            sprite:set_animation("opening")
            sol.timer.start(map, 800, function() 
              map:open_dungeon_3()
              hero:unfreeze()
              map:set_music()
            end)
          end)
          game:set_value("main_quest_step", 17)
        end)
      end

end

function sign_start:on_interaction()

  game:start_dialog("maps.out.south_prairie.surprise_3")
  game:set_value("wart_cave_start", true)

end

function tarin:on_interaction()

      map:talk_to_tarin()

end

function owl_7_sensor:on_activated()

  if game:get_value("main_quest_step") == 18  and game:get_value("owl_7") ~= true then
    owl_manager:appear(map, 7, function()
    map:set_music()
    end)
  end

end

--Weak doors play secret sound on opened
function weak_door_1:on_opened() sol.audio.play_sound("secret_1") end
function weak_door_2:on_opened() sol.audio.play_sound("secret_1") end

