--Inside - Telephone booth 7

-- Variables
local map = ...
local game = map:get_game()

-- Includes scripts
local phone_manager = require("scripts/maps/phone_manager")
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions

-- Events

function map:on_started()

  companion_manager:init_map(map)

end

function phone_interaction:on_interaction()

      phone_manager:talk(map)

end