local shop_manager = {}

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
              shop_manager:add_product(map, product["product"], product["placeholder"])
            -- To force removal of the carried object
            hero:freeze()
            hero:unfreeze()
            end
          end
        end
      return true  -- Stop the propagation to other objects.
    end
  end)

end

function shop_manager:add_product(map, product, placeholder)

        local item, variant, price = unpack(product)
        local hero = map:get_hero()
        placeholder:set_enabled(false)
        local x,y,layer= placeholder:get_position()
        local surface = sol.surface.create(320, 256)
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
        local entity = map:create_custom_entity{
                    x = x,
                    y = y,
                    layer = layer,
                    direction = 0,
                    width= 8,
                    height= 8
         }

        function destructible:on_lifting()

          shop_manager:remove_product(map, item)
          map.shop_manager_product  = item

        end

        function entity:on_pre_draw()

           map:draw_visual(price_text, x, y- 16)
        end

           map.shop_manager_products [item]= {
            destructible = destructible,
            placeholder = placeholder,
            entity = entity,
            price = price,
            item = item,
            product = product,
            variant = variant,
            price_text = price_text        
          }
        
end

function shop_manager:remove_product(map, item)

        local entity = map.shop_manager_products[item]['entity']
        entity:remove()
        
end

return shop_manager