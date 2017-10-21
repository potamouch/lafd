-- Outside - Yarna desert

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions


-- Events

function map:on_started()

  companion_manager:init_map(map)

end



function map:set_music()
  
  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/animal_village")
  else
      sol.audio.play_music("maps/out/overworld")
  end

end

separator_1:register_event("on_activating", function(separator, direction4)

  if direction4 == 1 then
      sol.audio.play_music("maps/out/animal_village")
  elseif direction4 == 3 then
      sol.audio.play_music("maps/out/overworld")
  end


end)

