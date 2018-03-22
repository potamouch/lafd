-- Outside - South prairie

-- Variables
local map = ...
local game = map:get_game()
local companion_manager = require("scripts/maps/companion_manager")
local next_sign = 1
local directions = {
  0, 3, 2, 1, 0, 3, 0, 1, 2, 3, 0, 3, 2
}

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
function weak_door_1:on_opened()
  sol.audio.play_sound("secret_1")
end


for sign in map:get_entities("sign_") do
  function sign:on_interaction()
    if game:get_value("wart_cave") == nil then
      if next_sign > 1 and self:get_name() == "sign_" .. next_sign or self:get_name() == "sign_" .. next_sign and next_sign == 1 and game:get_value("wart_cave_start") then
        if next_sign and next_sign < 14 then
          game:start_dialog("maps.out.south_mabe_village.surprise_" .. directions[next_sign])
        elseif next_sign == 14 then
          sol.audio.play_sound("secret_1")
          game:start_dialog("maps.out.south_mabe_village.surprise_success")
          game:set_value("wart_cave", true)
          for wart_cave in map:get_entities("wart_cave") do
            wart_cave:set_enabled(true)
          end
        end
        next_sign = next_sign + 1
      else
        game:set_value("wart_cave_start", nil)
        game:start_dialog("maps.out.south_mabe_village.surprise_error")
        sol.audio.play_sound("wrong")
        next_sign = 1
      end
    else
      game:start_dialog("maps.out.south_mabe_village.surprise_finished")
    end
 end
end


if game:get_value("wart_cave") == nil then
  for wart_cave in map:get_entities("wart_cave") do
    wart_cave:set_enabled(false)
  end
end


