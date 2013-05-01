-- Outside - South village
local map = ...
-- Includes scripts
sol.main.load_file("npc/owl")(game)

function map:set_music()

  if map:get_game():get_value("step_1_link_search_sword") == true and map:get_game():get_value("step_2_link_found_sword") == nil then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("overworld")
  end

end

local function set_owl_disabled()

  owl:set_visible(false)

end

function map:on_started(destination)

  map:set_music()
  set_owl_disabled()

end

function owl_1_sensor:on_activated()

  if map:get_game():get_value("owl_1") == true then
    map:set_music()
  else
    owl_appear(1)
  end

end

function map:on_obtained_treasure(item, variant, savegame_variable)

  if( item:get_name() == "sword" ) then
    map:set_music()
  end

end


