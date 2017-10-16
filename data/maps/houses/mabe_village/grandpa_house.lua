-- Inside - Grand pa's house

-- Variables
local map = ...
local game = map:get_game()

-- Methods - Functions

function map:set_music()

  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/houses/telephone_booth")
  end

end

function map:talk_to_grandpa() 

  game:start_dialog("maps.houses.mabe_village.grandpa_house.grandpa_1")

end


-- Events

function map:on_started(destination)

  map:set_music()

end


function grandpa:on_interaction()

      map:talk_to_grandpa()

end


for wardrobe in map:get_entities("wardrobe") do
  function wardrobe:on_interaction()
    game:start_dialog("maps.houses.wardrobe_1", game:get_player_name())
  end
end
