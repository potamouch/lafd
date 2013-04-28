-- Bow wow
local enemy = ...
local sprite = enemy:create_sprite("enemies/bowwow")

function enemy:on_created()

  enemy:set_invincible(true)
  enemy:set_can_attack(false)
  enemy:set_damage(0)
  enemy:set_hurt_style("normal")
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)

end

function enemy:on_restarted()

  self:go_random()

end

function enemy:on_movement_finished(movement)

  self:go_random()

end

function enemy:on_obstacle_reached(movement)

  self:go_random()

end


function enemy:go_random()

  sol.timer.stop_all(self)
  sol.timer.start(self, 300 + math.random(1500), function()
  end)

end

function sprite:on_animation_finished(animation)

  if animation == "bite" then
    self:set_animation("walking")
  end

end
