local map = ...
local game = map:get_game()
-- Outside - South village

-- Functions

function map:set_music()

  if game:get_value("step_1_link_search_sword") == true and game:get_value("step_2_link_found_sword") == nil then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/out/overworld")
  end

end

-- Events

function map:on_started(destination)

  map:set_music()
  owl:set_visible(false)

end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "sword" then
    sol.audio.play_music("maps/out/let_the_journey_begin")
  end

end

function owl_1_sensor:on_activated()

  if game:get_value("owl_1") == true then
    map:set_music()
  else
    map:owl_appear(1)
  end

end