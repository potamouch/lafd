local phone_manager = {}

function phone_manager:talk(map)

  local game = map:get_game()
  game:start_dialog("maps.houses.phone_booth.1")

end

return phone_manager