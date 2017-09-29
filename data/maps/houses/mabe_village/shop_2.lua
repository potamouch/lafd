-- Inside - Shop 2

-- Variables
local map = ...
local game = map:get_game()
local merchant_move = false

-- Methods - Functions

function map:set_music()

  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/houses/shop")
  end

end

function map:repeat_merchant_direction_check()

  local direction4 = merchant:get_direction4_to(hero)
  print(direction4)
  if direction4 == 0 then
      if merchant_move == false then
        merchant_move = true
        sol.timer.start(map, 1600, function() 
          merchant:get_sprite():set_direction(direction4)
          merchant_move = false
        end)
      end
  else
      if merchant_move == false then
        merchant:get_sprite():set_direction(direction4)
      end
  end

  -- Rappeler cette fonction dans 0.1 seconde.
  sol.timer.start(map, 100, function() 
    map:repeat_merchant_direction_check()
  end)
end

function map:init_merchant()
 
    merchant:get_sprite():set_animation("waiting")
    map:repeat_merchant_direction_check()

end

-- Events

function map:on_started(destination)

  map:set_music()
  map:init_merchant()

end

function exit_sensor:on_activated()

  local direction4 = merchant:get_sprite():get_direction()
  if direction4 == 2 or direction4 == 3 then
    game:start_dialog("maps.houses.mabe_village.marine_house.tarin_3", function()
     hero:set_direction(2)
     hero:walk("2222")
   end)
  end

end
