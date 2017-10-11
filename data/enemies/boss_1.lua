local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local movement
local body_1
local body_2
local body_3
local tail
local movement_body_1
local movement_body_2
local movement_body_3
local tail
enemy:create_sprite("enemies/" .. enemy:get_breed() .. '_head')

function enemy:on_created()

  enemy:set_invincible(true)
  local x, y, layer = enemy:get_position()
  body_1 = map:create_enemy{
      breed = enemy:get_breed() .. '_body_1',
      direction = 3,
      x = x,
      y = y,
      width = 32,
      height = 32,
      layer = layer
    }
  body_2 = map:create_enemy{
        breed = enemy:get_breed() .. '_body_2',
        direction = 3,
        x = x,
        y = y,
        width = 32,
        height = 32,
        layer = layer
      }
  body_3 = map:create_enemy{
        breed = enemy:get_breed() .. '_body_3',
        direction = 3,
        x = x,
        y = y,
        width = 32,
        height = 32,
        layer = layer
      }
  tail = map:create_enemy{
        breed = enemy:get_breed() .. '_tail',
        direction = 3,
        x = x,
        y = y,
        width = 32,
        height = 32,
        layer = layer
      }
  tail:register_event("on_hurt", function()
      movement:set_angle_speed(180)
  end)
end

function enemy:on_restarted()

  local x, y = enemy:get_position()
  enemy:go(true, 0, x - 32, y)
  enemy:go_body()
  sol.timer.start(enemy, 1000, function()
    enemy:repeat_switch_side()
  end)

end

function enemy:go_body()
   movement_body_1 = sol.movement.create("target")
   movement_body_1:set_target(enemy)
   movement_body_1:set_speed(128)
   movement_body_1:start(body_1)
   movement_body_2 = sol.movement.create("target")
   movement_body_2:set_target(body_1)
   movement_body_2:set_speed(128)
   movement_body_2:start(body_2)
   movement_body_3 = sol.movement.create("target")
   movement_body_3:set_target(body_2)
   movement_body_3:set_speed(128)
   movement_body_3:start(body_3)
   movement_tail = sol.movement.create("target")
   movement_tail:set_target(body_3)
   movement_tail:set_speed(128)
   movement_tail:start(tail)
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
  movement:set_angle_speed(140)
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
