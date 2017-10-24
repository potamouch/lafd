-- Inside - Weathercock
local companion_manager = require("scripts/maps/companion_manager")

function map:on_started()

  companion_manager:init_map(map)

end