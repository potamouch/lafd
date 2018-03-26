--Sea urchin
local enemy = ...
local sprite = enemy:create_sprite("enemies/sea_urchin")
local game = enemy:get_game()
local map = game:get_map()

function enemy:on_created()

  self:set_traversable(false)
  self:set_life(1)
  self:set_damage(1)
  self:set_hurt_style("normal")
  self:set_attacking_collision_mode("touching")
  self:set_default_behavior_on_hero_shield("block_push")
  self:set_pushed_by_shield_property("sound_id", "urchin2")
end

function sprite:on_animation_finished(animation)

  if animation == "bite" then
    self:set_animation("walking")
  end

end