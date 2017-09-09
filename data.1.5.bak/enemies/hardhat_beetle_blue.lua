local enemy = ...

-- Blue Hardhat Beetle.

local properties = {

}

function enemy:on_created()

  self:create_sprite("enemies/" .. enemy:get_breed())
  self:set_life(1)
  self:set_damage(1)
  --self:set_invincible()
  --self:set_attack_consequence("sword", "custom")
  local movement = sol.movement.create("random")
  movement:set_speed(32)
  movement:start(enemy)

end

function enemy:on_custom_attack_received(attack)


 sol.timer.stop_all(enemy) 
  sol.audio.play_sound("enemy_hurt")
  local hero = enemy:get_map():get_hero()
  local angle = hero:get_angle(enemy)
  local movement = sol.movement.create("path")
  --movement:set_ignore_obstacles(properties.ignore_obstacles)
  local direction = 0
  if hero:get_direction() == 1 then
    direction = 2
  end
  if hero:get_direction() == 2 then
    direction = 4
  end
  if hero:get_direction() == 3 then
    direction = 6
  end
  movement:set_path{direction, direction, direction, direction}
  movement:set_speed(128)
  movement:start(enemy, function()
    local movement = sol.movement.create("random")
    movement:set_speed(32)
    movement:start(enemy)
  end)
  sol.timer.start(enemy, 150, function()
       enemy:restart()
  end)
end
