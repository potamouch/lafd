local enemy = ...
local angle = math.pi

-- An animated fireball that circles around the enemy that created it.

function enemy:on_created()

  self:set_damage(1)
  self:create_sprite("enemies/fireball")
  self:set_invincible()
  enemy:go()

end

function enemy:go()
  local m = sol.movement.create("straight")
  angle = angle + math.pi / 2
  m:set_angle(angle)
  m:start(self)
  function m:on_obstacle_reached()
    enemy:go()
  end
end