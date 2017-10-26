-- Outside - Prairie

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

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
  dungeon_3_entrance:set_can_traverse("hero", true)

end

-- Events

function map:on_started(destination)

  map:set_music()
  companion_manager:init_map(map)
  dungeon_3_entrance:set_can_traverse("hero", false)
  if game:get_value("main_quest_step") > 16 then
    map:open_dungeon_3()
  end

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
