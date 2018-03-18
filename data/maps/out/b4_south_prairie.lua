-- Outside - South prairie

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions


-- Events

function map:on_started()

  companion_manager:init_map(map)
  map:set_digging_allowed(true)

  --Invisible things: only visible with the Lens
  if game:get_value("get_lens") then
    weak_door_1:set_enabled(true)
  else
    weak_door_1:set_enabled(false)
  end

end

--Weak doors play secret sound on opened
function weak_door_1:on_opened() sol.audio.play_sound("secret_1") end