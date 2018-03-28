-- Outside - West Mt Tarmaranch

-- Variables
local map = ...
local game = map:get_game()
local hero = map:get_hero()
local owl_manager = require("scripts/maps/owl_manager")
local companion_manager = require("scripts/maps/companion_manager")

-- Methods - Functions


-- Events

function map:on_started(destination)

  -- Owl
  owl_6:set_enabled(false)
  -- Remove the big stone if you come from the secret cave
  if destination == stair_arrows_upgrade then secret_stone:set_enabled(false) end
  -- Signs
  photographer_sign:get_sprite():set_animation("photographer_sign")
  map:set_music()
  companion_manager:init_map(map)
  
end

function map:get_music_mountains()


end

function map:set_music()
  
  local x_hero, y_hero = hero:get_position()
  local x_separator, y_separator = auto_separator_1:get_position()
  if y_hero <  y_separator then
    if game:get_player_name():lower() == "marin" then
      sol.audio.play_music("maps/out/mt_tamaranch_marin")
    else
      sol.audio.play_music("maps/out/mt_tamaranch")
    end
  else
      sol.audio.play_music("maps/out/overworld")
  end

end

auto_separator_1:register_event("on_activating", function(separator, direction4)

  if direction4 == 1 then
    if game:get_player_name():lower() == "marin" then
      sol.audio.play_music("maps/out/mt_tamaranch_marin")
    else
      sol.audio.play_music("maps/out/mt_tamaranch")
    end
  elseif direction4 == 3 then
      sol.audio.play_music("maps/out/overworld")
  end

end)

function owl_6_sensor:on_activated()

  if game:get_value("owl_6") ~= true then
    owl_manager:appear(map, 6, function()
      map:set_music()
    end)
  end

end
