local phone_manager = {}

function phone_manager:talk(map)

  local game = map:get_game()
  local hero = map:get_hero()
  local phone = map:get_entity("phone")
  local phone_sprite = phone:get_sprite()
  phone_sprite:set_animation("calling")
  hero:freeze()
  hero:get_sprite():set_ignore_suspend(true)
  hero:set_animation("pickup_phone", function()
    hero:set_animation("calling")
    game:start_dialog("maps.houses.phone_booth.1", function() 
      hero:set_animation("hangup_phone", function()
        hero:unfreeze()
        phone_sprite:set_animation("stopped")
        hero:get_sprite():set_ignore_suspend(false)
      end)
    end)
  end)

end

return phone_manager