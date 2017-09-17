-- Outside - Mabe village

-- Variables
local map = ...
local game = map:get_game()

-- Methods - Functions

function map:set_music()
  
  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/out/overworld")
  end

end

-- Events

function map:on_started(destination)

  map:set_music()

end
