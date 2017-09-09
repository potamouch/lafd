--Inside - Telephone booth 1

-- Variables
local map = ...
local game = map:get_game()

-- Includes scripts
local phone_manager = require("scripts/maps/phone_manager")

-- Methods - Functions

function map:set_music()

  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/houses/telephone_booth")
  end

end

-- Events

function map:on_started(destination)

  map:set_music()

end

function phone_interaction:on_interaction()

      phone_manager:talk(map)

end


