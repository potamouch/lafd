--Inside - Telephone booth 4

-- Variables
local map = ...
local game = map:get_game()

-- Includes scripts
local phone_manager = require("scripts/maps/phone_manager")

-- Methods - Functions

-- Events

function phone_interaction:on_interaction()

      phone_manager:talk(map)

end


