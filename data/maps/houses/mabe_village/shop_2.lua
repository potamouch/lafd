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
    local thief_must_die = game:get_value("thief_must_die")
    if thief_must_die then
      sol.audio.play_music("maps/dungeons/boss")
    else
      sol.audio.play_music("maps/houses/shop")
    end
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
  sol.timer.start(map, 100, function() 
    map:repeat_merchant_direction_check()
  end)
end

function map:init_merchant()
 
  local thief_must_die = game:get_value("thief_must_die")
  if thief_must_die then
    merchant:set_enabled(false)
    game:set_value("thief_must_die", false)
    game:start_dialog("maps.houses.mabe_village.shop_2.merchant_5", function()
      game:set_life(0)
    end)
  else  
    merchant_angry:set_enabled(false)
  end
  merchant:get_sprite():set_animation("waiting")
  map:repeat_merchant_direction_check()

end

function map:talk_to_merchant() 

    local direction4 = merchant:get_direction4_to(hero)
    merchant:get_sprite():set_direction(direction4)
    if map.shop_manager_product == nil then
      game:start_dialog("maps.houses.mabe_village.shop_2.merchant_1")
    end

end

-- Events

function map:on_started(destination)

  map:set_music()
  map:init_merchant()
  companion_manager:init_map(map)
  shop_manager:init(map)
  local product = {"shovel", 1, 200, "shovel"}
  shop_manager:add_product(map, product, placeholder_1)
  local product = {"heart", 1, 10, "heart"}
  shop_manager:add_product(map, product, placeholder_2)
  local product = {"shield", 1, 50, "shield"}
  shop_manager:add_product(map, product, placeholder_3)

end

function exit_sensor:on_activated()

  if map.shop_manager_product ~= nil then
    local direction4 = merchant:get_sprite():get_direction()
    if direction4 == 2 or direction4 == 3 then
      game:start_dialog("maps.houses.mabe_village.shop_2.merchant_2", function()
        local x_initial,y_initial = hero_invisible:get_position()
        local movement = sol.movement.create("straight")
        movement:set_angle(math.pi / 2)
        movement:set_max_distance(16)
        movement:set_speed(45)
        movement:start(hero_invisible)
        hero:set_direction(1)
        function movement:on_position_changed()
          local x,y = hero_invisible:get_position()
          hero:set_position(x, y)
        end
        function movement:on_finished()
          hero_invisible:set_position(x_initial, y_initial)
        end
      end)
    else
      game:set_value("hero_is_thief", true)
      game:set_value("hero_is_thief_message", true)
      game:set_value("thief_must_die", true)
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
    if command == "attack" then -- Disable sword
      return true
    elseif command == "action" and hero:get_state() == "carrying" then
      if hero:get_distance(merchant) <=16  or hero:get_distance(merchant_invisible) <=16  then
        local direction4 = merchant:get_direction4_to(hero)
        merchant:get_sprite():set_direction(direction4)
        shop_manager:buy_product(map, map.shop_manager_product)
      end
    end

end)





