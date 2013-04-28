--Sea urchin
local enemy = ...
local sprite = enemy:create_sprite("enemies/sea_urchin")

function enemy:on_created()

  enemy:set_life(1)
  enemy:set_damage(1)
  enemy:set_hurt_style("normal")
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)
  local sprite = enemy:create_sprite("enemies/sea_urchin")

end

function sprite:on_animation_finished(animation)

  if animation == "bite" then
    self:set_animation("walking")
  end

end
