-- Outside - South village

-- Includes scripts

sol.main.load_file("npc/owl")(game)

-- Variables

local map = ...

-- Functions

function map:set_music()

  if map:get_game():get_value("step_1_link_search_sword") == true and map:get_game():get_value("step_2_link_found_sword") == nil then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("overworld")
  end

end

-- Events

function map:on_started(destination)

  map:set_music()
  map:set_owl_disabled()

end


function map:on_obtaining_treasure(item, variant, savegame_variable)

  item:set_sound_when_brandished(')

end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if( item:get_name() == "sword" ) then
    map:set_music()
  end

end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if( item:get_name() == "sword" ) then
    map:set_music()
  end

end

function map:set_owl_disabled()

  owl:set_visible(false)

end

function owl_1_sensor:on_activated()

  if map:get_game():get_value("owl_1") == true then
    map:set_music()
  else
    map:owl_appear(1)
  end

end
