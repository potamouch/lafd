-- Lua script of enemy blob_green.
-- This script is executed every time an enemy with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local body_1
local body_2
local body_3
local head
local movement_head
local movement_body_1
local movement_body_2
local movement_body_3
local movement_tail

-- Event called when the enemy is initialized.
function enemy:on_created()

  local x_enemy,y_enemy,layer_enemy = enemy:get_position()
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  sprite:set_direction(2)
  enemy:set_life(5)
  enemy:set_damage(1)
  enemy:set_hurt_style("boss")
  head = map:create_enemy{
        breed = enemy:get_breed() .. '/moldorm_head',
        direction = 3,
        x = x_enemy,
        y = y_enemy,
        width = 32,
        height = 32,
        layer = layer_enemy
      }
  body_1 = map:create_enemy{
      breed = enemy:get_breed() .. '/moldorm_body_1',
      direction = 3,
      x = x_enemy,
      y = y_enemy,
      width = 32,
      height = 32,
      layer = layer_enemy
    }
  body_2 = map:create_enemy{
        breed = enemy:get_breed() .. '/moldorm_body_2',
        direction = 3,
        x = x_enemy,
        y = y_enemy,
        width = 32,
        height = 32,
        layer = layer_enemy
      }
  body_3 = map:create_enemy{
        breed = enemy:get_breed() .. '/moldorm_body_3',
        direction = 3,
        x = x_enemy,
        y = y_enemy,
        width = 32,
        height = 32,
        layer = layer_enemy
      }

end

function enemy:on_hurt()

  movement_head:set_angle_speed(180)

end

function enemy:on_pre_draw()

  head:remove_sprite()
  body_1:remove_sprite()
  body_2:remove_sprite()
  body_3:remove_sprite()
  head:create_sprite("enemies/boss/moldorm/moldorm_head")

end

function enemy:go_body()

   movement_body_1 = sol.movement.create("target")
   movement_body_1:set_target(head)
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
   movement_tail:start(enemy)

end

function enemy:go(clockwise, angle, center_x, center_y)

  movement_head = sol.movement.create("circle")
  movement_head:set_radius(32)
  movement_head:set_angle_speed(140)
  local angle_degrees = angle * 360 / (2 * math.pi)
  movement_head:set_initial_angle(angle_degrees)
  movement_head:set_ignore_obstacles(false)
  movement_head:set_clockwise(clockwise)
  movement_head:set_center(center_x, center_y)
  movement_head.center_x, movement_head.center_y = center_x, center_y
  function movement_head:on_obstacle_reached()
    movement_head:set_clockwise(not movement_head:is_clockwise())
  end
  movement_head:start(head)

end

function enemy:repeat_switch_side()

  if is_dead then
    return false
  end
  local x, y = enemy:get_position()
  local clockwise = not movement_head:is_clockwise()
  local center_x, center_y = x - (movement_head.center_x - x), y - (movement_head.center_y - y)
  local angle = sol.main.get_angle(center_x, center_y, x, y)
  enemy:go(clockwise, angle, center_x, center_y)
  sol.timer.start(enemy, math.random(1000, 3000), function()
    enemy:repeat_switch_side()
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