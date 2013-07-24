-- Outside - Mabe village

-- Variables
local map = ...
local game = map:get_game()

-- Methods - Functions

function map:set_music()

  if map:get_game():get_value("step_1_link_search_sword") == true and map:get_game():get_value("step_2_link_found_sword") == nil then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("mabe_village")
  end

end

function map:init_marine()
 
  if map:get_game():get_value("step_2_link_found_sword") == false  then
    marine:set_visible(false)
  else
    marine:get_sprite():set_animation("waiting")
  end

end


function map:talk_to_marine() 

  game:start_dialog("mabe_village.marine_1")

end

function  map:talk_to_grand_ma()

  game:start_dialog("mabe_village.grand_ma_1")

end

function  map:talk_to_kids() 

  local rand = math.random(4)
  game:start_dialog("mabe_village.kids_" .. rand)

end

function map:on_started(destination)

  map:set_music()
  map:init_marine()
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

function marine:on_interaction()

      map:talk_to_marine()

end
