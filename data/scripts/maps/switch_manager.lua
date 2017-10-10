local switch_manager = {}

function switch_manager:activate_when_savegame_exist(map, savegame, switch)
    
  local game = map:get_game()
  local switch = map:get_entity(switch)
  if game:get_value(savegame) then
         switch:set_activated(true)
  end

end

return switch_manager