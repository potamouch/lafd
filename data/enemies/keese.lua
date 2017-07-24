local enemy = ...

-- Keese: a bat that sleeps until the hero gets close.

function enemy:on_created()

  self:create_sprite("enemies/" .. enemy:get_breed())
  self:set_life(1)
  self:set_damage(1)
  local movement = sol.movement.create("random")
  movement:set_speed(32)
  movement:start(enemy)

end

enemy:set_layer_independent_collisions(true)
