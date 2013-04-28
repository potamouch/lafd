local map = ...

local function set_music()

  if map:get_game():get_value("step_1_link_search_sword") == true then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("links_awake")
  end

end


function map:on_started(destination)

  set_music()

end

function owl_1_sensor:on_activated()

  print("sensor")
  if map:get_game():get_value("owl_1") == true then
    set_music()
 print("no owl")
  else
    sol.audio.play_music("the_wise_owl")
    map:get_game():set_value("owl_1", true)
    hero:set_direction(2)
    hero:freeze()

  end

end


