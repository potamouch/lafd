-- Lua script of custom entity bowwow.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local map = entity:get_map()
local chains_entities = {}


-- Event called when the custom entity is initialized.
function entity:on_created()

  entity:set_traversable_by(false)
  entity:set_can_traverse("hero", false)
  local movement = sol.movement.create("random")
  movement:set_speed(20)
  movement:set_smooth(false)
  movement:set_max_distance(16)
  movement:start(entity)

  -- Chains
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
    local source = map:get_entity("chain_source")
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

