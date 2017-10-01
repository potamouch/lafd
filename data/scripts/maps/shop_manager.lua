local shop_manager = {}

shop_manager.products = {}


function shop_manager:init(map)


end

function shop_manager:get_surface()

  return shop_manager.prices.surface

end

function shop_manager:add_product(map, product, placeholder)

        local item, variant, price = unpack(product)
        local placeholder = map:get_entity(placeholder)
        local x,y,layer= placeholder:get_position()
        local surface = sol.surface.create(320, 256)
        local destructible = map:create_destructible{
                    sprite = item,
                    x = x,
                    y = y,
                    layer = layer
         }
        local entity = map:create_custom_entity{
                    x = x,
                    y = y,
                    layer = layer,
                    direction = 0,
                    width= 8,
                    height= 8
         }

        function destructible:on_lifting()

          print("ok")

        end

        function entity:on_pre_draw()

           local price_text = sol.text_surface.create({
              horizontal_alignment = "center",
              text = price
           })
           map:draw_visual(price_text, x, y- 16)
           shop_manager.products[item]= {
            destructible = destructible,
            entity = entity,
            price = price,
            item = item,
            variant = variant,
            price_text = price_text        
          }
        end
        
end

function shop_manager:remove_product(map, item)

        local entity = shop_manager.products[item]['entity']
        entity:remove()
        shop_manager.products[item] = nil
        
end

return shop_manager