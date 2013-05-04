-- Outside - Mabe village

-- Variables
local map = ...

-- Methods - Functions

function map:set_music()

  if map:get_game():get_value("step_1_link_search_sword") == true and map:get_game():get_value("step_2_link_found_sword") == nil then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("mabe_village")
  end

end

function  map:talk_to_grand_ma()

  map:start_dialog("mabe_village.grand_ma_1")

end

function  map:talk_to_kids() 

  local rand = math.random(4)
  map:start_dialog("mabe_village.kids_" .. rand)

end

function map:on_started(destination)

  map:set_music()
  grand_ma:get_sprite():set_animation("walking")

end

-- Events

function grand_ma:on_interaction()

  map:talk_to_grand_ma()

end

function kid_1:on_interaction()

  map:talk_to_kids()

end

function kid_2:on_interaction()

  map:talk_to_kids()

end
