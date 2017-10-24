local enemy = ...

-- Stalfos: goes in a random direction.

enemy:set_life(1)
enemy:set_damage(1)

local sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())

-- The enemy was stopped for some reason and should restart.
function enemy:on_restarted()

  local m = sol.movement.create("straight")
  m:set_speed(0)
  m:start(self)
  local direction4 = math.random(4) - 1
  self:go(direction4)

end

function enemy:on_movement_finished(movement)

  local direction4 = math.random(4) - 1
  self:go(direction4)

end

function enemy:on_obstacle_reached(movement)

  local direction4 = math.random(4) - 1
  self:go(direction4)

end

-- Makes the enemy walk towards a direction.
function enemy:go(direction4)

  -- Set the sprite.
  sprite:set_animation("walking")
  sprite:set_direction(direction4)

  -- Set the movement.
  local m = self:get_movement()
  local max_distance = 40 + math.random(120)
  m:set_max_distance(max_distance)
  m:set_smooth(true)
  m:set_speed(40)
  m:set_angle(direction4 * math.pi / 2)
end

