-- An entity the hookshot can attach to.
-- To be used with the scripted hookshot item.
local entity = ...
local game = entity:get_game()
local map = game:get_map()

entity:set_traversable_by(false)

function entity:on_created()

  self:add_collision_test("overlapping", function(pig, explosion)

    if explosion:get_type() == "explosion" then
      local x,y,layer = self:get_position()
      local stones = map:create_custom_entity({
        name = "statue_pig_destroyed",
        sprite = "entities/statue_pig_destroyed",
        x = x - 16,
        y = y - 16,
        width = 80,
        height = 80,
        layer = layer,
        direction = 0
      })
      local sprite_stones = stones:get_sprite()
      sprite_stones:set_animation("destroyed")
      entity:remove()
      function sprite_stones:on_animation_finished(animation)
        if animation == "destroyed" then
          stones:remove()
          game:set_value("statue_pig_exploded", true)
        end
      end
    end

  end)

end