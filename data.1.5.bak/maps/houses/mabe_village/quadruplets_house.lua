-- Inside - Quadruplet's house

-- Variables

local map = ...
local game = map:get_game()

-- Functions

function map:set_music()

  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/houses/inside")
  end

end

-- Events

function map:on_started(destination)

  map:set_music()

end
