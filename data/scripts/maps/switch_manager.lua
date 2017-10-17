local switch_manager = {}

function switch_manager:activate_switch_if_savegame_exist(map, switch, savegame)

  local game = map:get_game()
  local switch = map:get_entity(switch)
  if switch and savegame and game:get_value(savegame) then
    switch:set_activated(true)
  end
      
end

return switch_manager