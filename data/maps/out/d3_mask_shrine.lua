-- Outside - Mask Shrine

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions


-- Events

function map:on_started()

  map:set_digging_allowed(true)
  companion_manager:init_map(map)

end

--Weak doors play secret sound on opened
function weak_door_1:on_opened() sol.audio.play_sound("secret_1") end