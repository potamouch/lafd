local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local movement
enemy:create_sprite("enemies/" .. enemy:get_breed() .. '_head')

function enemy:on_restarted()

  local x, y = enemy:get_position()
  enemy:go(true, 0, x - 32, y)

  sol.timer.start(enemy, 1000, function()
    enemy:repeat_switch_side()
  end)

end

function enemy:repeat_switch_side()

  local x, y = enemy:get_position()
  local clockwise = not movement:is_clockwise()
  local center_x, center_y = x - (movement.center_x - x), y - (movement.center_y - y)
  local angle = sol.main.get_angle(center_x, center_y, x, y)
  enemy:go(clockwise, angle, center_x, center_y)
  sol.timer.start(enemy, math.random(1000, 3000), function()
    enemy:repeat_switch_side()
  end)
end

function enemy:go(clockwise, angle, center_x, center_y)

  movement = sol.movement.create("circle")
  movement:set_radius(32)
  movement:set_angle_speed(180)
  local angle_degrees = angle * 360 / (2 * math.pi)
  movement:set_initial_angle(angle_degrees)
  movement:set_ignore_obstacles(false)
  movement:set_clockwise(clockwise)
  movement:set_center(center_x, center_y)
  movement.center_x, movement.center_y = center_x, center_y
  function movement:on_obstacle_reached()
    movement:set_clockwise(not movement:is_clockwise())
  end
  movement:start(enemy)
end
