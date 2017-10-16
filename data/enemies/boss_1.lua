local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local movement
local body_1
local body_2
local body_3
local head
local movement_body_1
local movement_body_2
local movement_body_3
local movement_tail
local is_dead = false

enemy:create_sprite("enemies/" .. enemy:get_breed() .. '_tail')

function enemy:on_created()

  enemy:set_life(2)
  enemy:set_damage(1)
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(false)
  local x, y, layer = enemy:get_position()
  head = map:create_enemy{
        breed = enemy:get_breed() .. '_head',
        direction = 3,
        x = x,
        y = y,
        width = 32,
        height = 32,
        layer = layer
      }
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
end

function enemy:on_hurt()

  movement:set_angle_speed(180)

end

function enemy:on_restarted()

  if is_dead then
    return false
  end
  local x, y = enemy:get_position()
  enemy:go(true, 0, x - 32, y)
  enemy:go_body()
  sol.timer.start(enemy, 1000, function()
    enemy:repeat_switch_side()
  end)

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

function enemy:repeat_switch_side()

  if is_dead then
    return false
  end
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
  movement:start(head)
end

function enemy:on_hurt()
  if enemy:get_life() == 1 then
    is_dead = true
   hero:freeze()
    movement_tail:stop()
    movement_body_1:stop()
    movement_body_2:stop()
    movement_body_3:stop()
    movement:stop()
    sol.audio.play_sound("boss_killed")
    sol.timer.start(head, 1000, function()
      enemy:remove()
      sol.audio.play_sound("boss_1_explode_part")
       sol.timer.start(head, 500, function()
          body_3:remove()
          sol.audio.play_sound("boss_1_explode_part")
          sol.timer.start(head, 500, function()
            body_2:remove()
            sol.audio.play_sound("boss_1_explode_part")
            sol.timer.start(head, 500, function()
              body_1:remove()
              sol.audio.play_sound("boss_1_explode_part")
              sol.timer.start(head, 500, function()
                head:remove()
                 sol.audio.play_sound("boss_1_explode_part")
                 enemy:launch_boss_dead()
                 hero:unfreeze()
               end)
            end)
        end)
      end)
    end)
  end
end

