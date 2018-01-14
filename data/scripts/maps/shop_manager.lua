local shop_manager = {}
local language_manager = require("scripts/language_manager")

local map


function shop_manager:init(map)

  map.shop_manager_products = {}
  map.shop_manager_product = nil
  map:register_event("on_command_pressed", function(map, command)
    local hero = map:get_hero()
    if command == "action" and hero:get_state() == "carrying" then
      for k, product in pairs(map.shop_manager_products) do
          if hero:get_distance(product["placeholder"]) < 24 and hero:get_direction() == 1 then
            if map.shop_manager_product == product["item"] then
              shop_manager:reset_product(map, product)
            end
          end
        end
      return true  -- Stop the propagation to other objects.
    end
  end)

end

function shop_manager:reset_product(map, product)

  local hero = map:get_hero()
  shop_manager:add_product(map, product["product"], product["placeholder"])
  -- To force removal of the carried object
  hero:freeze()
  hero:unfreeze()
  map.shop_manager_product = nil

end

function shop_manager:buy_product(map, product)
       
  local game = map:get_game()
  local product_table = map.shop_manager_products[product]
  local product_key, product_variant, product_price, product_quantity, product_dialog_id = unpack(product_table["product"])
  game:start_dialog("maps.houses.mabe_village.shop_2.product" .. "_" .. product_dialog_id, function(answer)
    if answer == 1 then
      local error = false
      -- Hearts
      if product_key == "heart" then
        if  game:get_life() == game:get_max_life() then
          error = true
        end
      elseif product_key == "shield" then
        local item = game:get_item("shield")
        local variant = item:get_variant()
        if variant > 0 then
          error = true
        end
      end
      if error then
          game:start_dialog("maps.houses.mabe_village.shop_2.merchant_4")
      else
        local money = game:get_money()
        if money >= product_price then
        else
          game:start_dialog("maps.houses.mabe_village.shop_2.merchant_3")
        end
      end
    end
  end)

end

function shop_manager:add_product(map, product, placeholder)

        local game = map:get_game()
        game:set_custom_command_effect("action", nil)
        local item, variant, price, quantity = unpack(product)
        item = "entities/" .. item
        local hero = map:get_hero()
        placeholder:set_enabled(false)
        local x,y,layer= placeholder:get_position()
        local surface = sol.surface.create(320, 256)
        local font = language_manager:get_menu_font(id)
        local destructible = map:create_destructible{
                    sprite = item,
                    x = x,
                    y = y,
                    layer = layer
         }
        local price_text = sol.text_surface.create({
          horizontal_alignment = "center",
          text = price
        })
        local quantity_text = nil
        if quantity > 1 then
          quantity_text = sol.text_surface.create({
            font = font,
            text = "x" .. quantity,
            font_size = 8,
            color = {255,255,255}
          })
        end
        local entity = map:create_custom_entity{
                    x = x,
                    y = y,
                    layer = layer,
                    direction = 0,
                    width= 8,
                    height= 8
         }

        function destructible:on_lifting()

          game:set_custom_command_effect("action", "none")
          shop_manager:remove_product(map, item)
          map.shop_manager_product  = item

        end

        function entity:on_pre_draw()

           map:draw_visual(price_text, x, y - 20)
           if quantity_text ~= nil then
            map:draw_visual(quantity_text, x + 5, y - 4)
           end

        end

           map.shop_manager_products[item]= {
            destructible = destructible,
            placeholder = placeholder,
            entity = entity,
            price = price,
            item = item,
            product = product,
            variant = variant,
            quantity_text = quantity_text, 
            price_text = price_text        
          }
        
end

function shop_manager:remove_product(map, item)

        local entity = map.shop_manager_products[item]['entity']
        local game = map:get_game()
       entity:remove()
        
end

return shop_manager