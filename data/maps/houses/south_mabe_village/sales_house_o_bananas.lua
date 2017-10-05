-- Inside - Shop 2

-- Includes scripts
local shop_manager = require("scripts/maps/shop_manager")

-- Variables
local map = ...
local game = map:get_game()
local merchant_move = false

-- Methods - Functions

function  map:talk_to_wardrobe() 

  game:start_dialog("maps.houses.south_mabe_village.sales_house_o_bananas.wardrobe_1", game:get_player_name())

end

function map:talk_to_alligator() 

    local item = game:get_item("magnifying_lens")
    local variant = item:get_variant()
    local sprite = alligator:get_sprite()
    if variant == 3 then
      game:start_dialog("maps.houses.south_mabe_village.sales_house_o_bananas.alligator_2", function(answer)
        if answer == 1 then
          hero:freeze()
          game:start_dialog("maps.houses.south_mabe_village.sales_house_o_bananas.alligator_4", function()
            hero:set_direction(2)
            hero:set_animation("walking")
            local m1 = sol.movement.create("path")
            m1:set_path{4,4,4,4}
            m1:set_speed(80)
            m1:start(hero)
            function m1:on_finished()
              hero:set_direction(0)
              hero:set_animation("stopped")
              sol.timer.start(hero, 1000, function()
                local x_hero,y_hero, layer_hero = hero:get_position()
                 local food = map:create_custom_entity({
                    name = "food",
                    sprite = "entities/items",
                    x = x_hero,
                    y = y_hero,
                    width = 16,
                    height = 16,
                    layer = 1,
                    direction = 0
                  })
                  food:get_sprite():set_animation("magnifying_lens")
                  food:get_sprite():set_direction(2)
                  local m2 = sol.movement.create("target")
                  m2:set_speed(120)
                  m2:set_target(alligator)
                  m2:start(food)
                  sol.audio.play_sound("jump")
                  sprite:set_animation("eating")
                  function m2:on_finished()
                      food:remove()
                      sol.timer.start(hero, 2000, function()
                        hero:set_animation("walking")
                        local m2 = sol.movement.create("path")
                        m2:set_path{0,0,0,0}
                        m2:set_speed(80)
                        m2:start(hero)
                        function m2:on_finished()
                         sprite:set_animation("waiting")
                         hero:set_animation("stopped")
                         hero:unfreeze()
                         game:start_dialog("maps.houses.south_mabe_village.sales_house_o_bananas.alligator_5", function()
                            hero:start_treasure("magnifying_lens", 4, "magnifying_lens_4")
                          end)
                        end
                      end)
                  end
              end)
            end
          end)
        else
          game:start_dialog("maps.houses.south_mabe_village.sales_house_o_bananas.alligator_3")
        end
      end)
    elseif variant > 3 then
      game:start_dialog("maps.houses.south_mabe_village.sales_house_o_bananas.alligator_6")
    else
      game:start_dialog("maps.houses.south_mabe_village.sales_house_o_bananas.alligator_1")
    end

end

-- Events

function map:on_started()


end



function map:on_opening_transition_finished()

end

function alligator:on_interaction()

      map:talk_to_alligator()

end


function wardrobe_1:on_interaction()

      map:talk_to_wardrobe()

end

function wardrobe_2:on_interaction()

      map:talk_to_wardrobe()

end

function wardrobe_3:on_interaction()

      map:talk_to_wardrobe()

end



