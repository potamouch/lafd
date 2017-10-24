-- Outside - West Mt Tarmaranch

-- Variables
local map = ...
local game = map:get_game()
local hero = map:get_hero()
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions


-- Events

function map:on_started()

 map:set_music()
 companion_manager:init_map(map)

end

function map:set_music()
  
  local x_hero, y_hero = hero:get_position()
  local x_separator, y_separator = auto_separator_1:get_position()
  if y_hero <  y_separator then
      sol.audio.play_music("maps/out/mt_tamaranch")
  else
      sol.audio.play_music("maps/out/overworld")
  end

end

auto_separator_1:register_event("on_activating", function(separator, direction4)

  if direction4 == 1 then
      sol.audio.play_music("maps/out/mt_tamaranch")
  elseif direction4 == 3 then
      sol.audio.play_music("maps/out/overworld")
  end

end)
