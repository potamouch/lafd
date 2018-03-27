-- Outside - Yarna desert

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")
local travel_manager = require("scripts/maps/travel_manager")

-- Methods - Functions


-- Events

function map:on_started()

  map:set_digging_allowed(true)
  companion_manager:init_map(map)
  -- Travel
  travel_transporter:set_enabled(false)

end

function map:set_music()
  
  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/animal_village")
  else
      sol.audio.play_music("maps/out/overworld")
  end

end

function map:talk_to_rabbit_1()

      game:start_dialog("maps.out.yarna_desert.rabbit_1_1")

end

function map:talk_to_rabbit_2()

      game:start_dialog("maps.out.yarna_desert.rabbit_2_1")

end

function map:talk_to_rabbit_3()

      game:start_dialog("maps.out.yarna_desert.rabbit_3_1")

end

function map:talk_to_walrus()

      game:start_dialog("maps.out.yarna_desert.walrus_1")

end

function travel_sensor:on_activated()

    travel_manager:init(map, 4)

end

separator_1:register_event("on_activating", function(separator, direction4)

  if direction4 == 1 then
      sol.audio.play_music("maps/out/animal_village")
  elseif direction4 == 3 then
      sol.audio.play_music("maps/out/overworld")
  end


end)

function rabbit_1:on_interaction()

  map:talk_to_rabbit_1()

end

function rabbit_2:on_interaction()

  map:talk_to_rabbit_2()

end

function rabbit_3:on_interaction()

  map:talk_to_rabbit_3()

end

function walrus_invisible:on_interaction()

  map:talk_to_walrus()

end

--Weak doors play secret sound on opened
function weak_door_1:on_opened()
  sol.audio.play_sound("secret_1")
end