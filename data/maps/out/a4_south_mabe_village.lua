local map = ...
local game = map:get_game()
-- Outside - South village

-- Functions

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
  owl:set_visible(false)

end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if item:get_name() == "sword" then
    game:set_value("main_quest_step", 4)
    --sol.audio.play_music("maps/out/let_the_journey_begin")
    map:set_music()
  end

end

function owl_1_sensor:on_activated()

  if game:get_value("owl_1") == true then
    map:set_music()
  else
    map:owl_appear(1)
  end

end


function dungeon_1_lock:on_interaction()

      if game:get_value("main_quest_step") < 6 then
          game:start_dialog("maps.out.south_mabe_village.dungeon_1_lock")
      elseif game:get_value("main_quest_step") == 6 then
        game:set_value("main_quest_step", 7)
        print("ok")
      end

end