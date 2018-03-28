-- Inside - Shop 1

-- Variables
local map = ...
local game = map:get_game()
local is_game_available = false
local companion_manager = require("scripts/maps/companion_manager")
local clow_manager = require("scripts/maps/claw_manager")

-- Methods - Functions

function map:set_music()

  if game:get_value("main_quest_step") == 3  then
    sol.audio.play_music("maps/out/sword_search")
  else
    sol.audio.play_music("maps/houses/trendy_game")
  end

end


function map:talk_to_merchant() 

  game:start_dialog("maps.houses.mabe_village.shop_1.merchant_1", function(answer)
    if answer == 1 then
      local money = game:get_money()
      if money > 10 then
        game:start_dialog("maps.houses.mabe_village.shop_1.merchant_3", function()
          money = money - 10
          game:set_money(money)
          is_game_available = true
        end)
      else
        game:start_dialog("maps.houses.mabe_village.shop_1.merchant_2")
      end
    end
  end)

end

-- Events

function map:on_started(destination)

  map:set_music()
  companion_manager:init_map(map)

end

function merchant:on_interaction()

      map:talk_to_merchant()

end

function console:on_interaction()

  if is_game_available then
    is_game_available = false
    clow_manager:init_map(map)
  end

end
