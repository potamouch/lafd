-- Inside - Weathercock
local map = ...
local game = map:get_game()

local companion_manager = require("scripts/maps/companion_manager")

function map:on_started()

  companion_manager:init_map(map)

end