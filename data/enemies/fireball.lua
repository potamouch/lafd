local enemy = ...
local map = enemy:get_map()
local hero = map:get_hero()
local sprite
local movement
local angle = 0
local clockwise = true

function enemy:on_created()

  self:set_damage(1)
  self:create_sprite("enemies/fireball")
  self:set_invincible()
  sprite = enemy:get_sprite()
  local direction = sprite:get_direction()
  angle = math.pi /2 * direction
  if direction == 0 or direction == 1 then
    clockwise = false
  else
    clockwise = true
  end
  enemy:go()

end

function enemy:go()
  movement = sol.movement.create("straight")
  movement:set_angle(angle)
  movement:set_speed(96)
  movement:start(self)
  sol.timer.start(hero, 50, function()
    enemy:calculate_new_angle()
    movement:set_angle(angle)
    return true
  end)
end

function enemy:calculate_new_angle()

  local x, y, layer = enemy:get_position()
  local obstacle_0 = enemy:test_obstacles(1, 0, layer)
  local obstacle_1 = enemy:test_obstacles(0, -1, layer)
  local obstacle_2 = enemy:test_obstacles(-1, 0, layer)
  local obstacle_3 = enemy:test_obstacles(0, 1, layer)
  if clockwise then
    if obstacle_0 == false and obstacle_1 == false and obstacle_2 == false and obstacle_3 == false then
        angle = angle + math.pi / 2
    end
    if obstacle_0 and obstacle_1 then
      angle = angle - math.pi / 2
      return angle
    end
  if obstacle_1 and obstacle_2 then
    angle = angle - math.pi / 2
    return angle
  end
  if obstacle_2 and obstacle_3 then
    angle = angle - math.pi / 2
    return angle
  end
  if obstacle_3 and obstacle_0 then
     angle = angle - math.pi / 2
    return angle
  end
  else
    if obstacle_0 == false and obstacle_1 == false and obstacle_2 == false and obstacle_3 == false then
        angle = angle - math.pi / 2
    end
    if obstacle_0 and obstacle_1 then
        angle = angle + math.pi / 2
        return angle
      end
    if obstacle_1 and obstacle_2 then
      angle = angle + math.pi / 2
      return angle
    end
    if obstacle_2 and obstacle_3 then
      angle = angle + math.pi / 2
      return angle
    end
    if obstacle_3 and obstacle_0 then
       angle = angle + math.pi / 2
      return angle
    end
  end
  if obstacle_0 then
    angle = math.pi / 2
    return angle
  end
  if obstacle_1 then
    angle = math.pi
    return angle
  end
  if obstacle_2 then
    angle = 3 * math.pi / 2
    return angle
  end
  if obstacle_3 then
    angle = 0
    return angle
  end
    
end