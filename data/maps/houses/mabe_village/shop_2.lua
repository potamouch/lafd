-- Inside - Shop 2

-- Includes scripts
local shop_manager = require("scripts/maps/shop_manager")
local companion_manager = require("scripts/maps/companion_manager")

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
  
  -- Check if hero can talk to merchant
    if hero:get_state() == "carrying" then 
      if hero:get_distance(merchant) <=16  or hero:get_distance(merchant_invisible) <=16  then
      game:set_custom_command_effect("action", "speak")
    else 
      -- none does not have the same effect as nil (nil means to show the effect from the engine)
      game:set_custom_command_effect("action", "none")
    end
  end


  -- Rappeler cette fonction dans 0.1 seconde.
  sol.timer.start(map, 1, function() 
    map:repeat_merchant_direction_check()
  end)
end

function map:init_merchant()
 
    merchant:get_sprite():set_animation("waiting")
    map:repeat_merchant_direction_check()

end

function map:talk_to_merchant() 

    if map.shop_manager_product == nil then
      game:start_dialog("maps.houses.mabe_village.shop_2.marchant_1")
    end

end

-- Events

function map:on_started(destination)

  map:set_music()
  map:init_merchant()
  companion_manager:init_map(map)
  shop_manager:init(map)
  local product = {"entities/shovel", 1, 200}
  shop_manager:add_product(map, product, placeholder_1)
  local product = {"entities/heart", 1, 10}
  shop_manager:add_product(map, product, placeholder_2)
  local product = {"entities/shield", 1, 50}
  shop_manager:add_product(map, product, placeholder_3)

end

function exit_sensor:on_activated()

  if map.shop_manager_product ~= nil then
    local direction4 = merchant:get_sprite():get_direction()
    if direction4 == 2 or direction4 == 3 then
      game:start_dialog("maps.houses.mabe_village.shop_2.marchant_2", function()
       hero:set_direction(2)
       --hero:walk("2222")
     end)
    end
  end

end

function merchant:on_interaction()

      map:talk_to_merchant()

end

function merchant_invisible:on_interaction()

      map:talk_to_merchant()

end

map:register_event("on_command_pressed", function(map, command)
    local hero = map:get_hero()
    if command == "action" and hero:get_state() == "carrying" then
      if hero:get_distance(merchant) <=16  or hero:get_distance(merchant_invisible) <=16  then
        game:start_dialog("maps.houses.mabe_village.shop_2.marchant_1")
      local money = game:get_money()
print(money)
      local money_product = shop_manager:buy_product(map, map.shop_manager_product)
      end
    end

end)





