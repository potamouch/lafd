-- Inside - Meow meow's House

-- Variables

local map = ...

-- Methods - Functions

function map:set_music()

  if map:get_game():get_value("step_1_link_search_sword") == true and map:get_game():get_value("step_2_link_found_sword") == nil then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("inside_the_houses")
  end

end

-- Events

function map:on_started(destination)

  map:set_music()

end