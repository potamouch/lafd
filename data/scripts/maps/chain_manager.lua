local chain_manager = {}

function chain_manager:init_map(map, entity, source)

  local direction = 1
  local x,y,layer = entity:get_position()
  chain = map:create_custom_entity({
    direction = direction,
    layer = layer,
    x = x,
    y = y,
    width = 16,
    height = 16,
  })
  chain:set_origin(8, 13)
  chain:set_drawn_in_y_order(true)
  link_sprite = sol.sprite.create("entities/chain")
  function chain:on_pre_draw()
      if entity:exists() and entity:is_enabled() then
        -- Draw the links.
        local num_links = 5
        local dxy = {
          {0, 0},
          {0, 0},
          {0, 0},
          {0, 0}
        }
        local x,y,layer = entity:get_position()
        chain:set_position(x,y,layer)
        local source_x, source_y = source:get_position()
        local x1 = source_x + dxy[direction + 1][1]
        local y1 = source_y + dxy[direction + 1][2]
        local x2, y2 = chain:get_position()
        y2 = y2 - 5
        for i = 0, num_links - 1 do
          local link_x = x1 + (x2 - x1) * i / num_links
          local link_y = y1 + (y2 - y1) * i / num_links
          -- Skip the first one when going to the North because it overlaps
          -- the hero sprite and can be drawn above it sometimes.
          local skip = direction == 1 and link_x == source_x and i == 0
          if not skip then
            map:draw_visual(link_sprite, link_x, link_y)
          end
        end
    end
  end
 
end


return chain_manager