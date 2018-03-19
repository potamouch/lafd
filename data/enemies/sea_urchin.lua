--Sea urchin
local enemy = ...
local sprite = enemy:create_sprite("enemies/sea_urchin")

function enemy:on_created()

  self:set_traversable(false)
  self:set_life(1)
  self:set_damage(1)
  self:set_hurt_style("normal")
  self:set_can_be_pushed_by_shield(true)
  self:set_attacking_collision_mode("touching")

end

function sprite:on_animation_finished(animation)

  if animation == "bite" then
    self:set_animation("walking")
  end

end