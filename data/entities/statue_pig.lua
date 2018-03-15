-- An entity the hookshot can attach to.
-- To be used with the scripted hookshot item.
local entity = ...
local game = entity:get_game()

entity:set_traversable_by(false)

function entity:on_created()

  self:add_collision_test("overlapping", function(pig, explosion)

    if explosion:get_type() == "explosion" then
      -- todo add destroy animation
      self:remove()
      game:set_value("statue_pig_exploded", true)
    end

  end)

end