-- Lua script of enemy moblin_chief.
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
local sprite
local distance = 64 --Distance between hero and enemy
local angle = 0
local direction = 4
local direction_arrow = 2
local max_attacks = 3
local attacks = 0
local x -- X Enemy
local y -- Y Enemy
local x_initial
local y_initial
local arrow
local launch_boss

function enemy:on_created()

  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_life(4)
  enemy:set_damage(1)
  enemy:set_attack_consequence("sword", "protected")
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_hurt_style("boss")
  x_initial, y_initial = enemy:get_position()
end

function enemy:on_restarted()
  if launch_boss then
     enemy:go_to_initial_position()
  end
end



-- Calculate distance, angle and new position enemy
function enemy:calculate_parameters()

  local x_hero, y_hero = hero:get_position()
  local x_enemy, y_enemy = enemy:get_position()
  if x_hero < x_enemy then
    angle = math.pi
    direction = 4
    direction_arrow = 2
    x = x_hero + distance 
  else
    angle = 0
    direction = 0
    direction_arrow = 0
    x = x_hero - distance 
  end
  y = y_hero

end

function enemy:go_to_initial_position()

    local movement_initial = sol.movement.create("target")
    movement_initial:set_speed(96)
    movement_initial:set_target(x_initial, y_initial)
    movement_initial:start(enemy)
    function movement_initial:on_finished()
      enemy:start_battle()
    end

end

function enemy:start_battle()

    launch_boss = true
    enemy:calculate_parameters()
    enemy:set_attack_consequence("sword", "protected")
    local movement_battle = sol.movement.create("target")
    movement_type = "battle"
    movement_battle:set_speed(96)
    movement_battle:set_target(x, y)
    movement_battle:start(enemy)
    function movement_battle:on_finished()
      enemy:choose_attack()
    end
    function movement_battle:on_obstacle_reached()
      movement_battle:stop()
      enemy:go_to_initial_position()
    end

end

function enemy:choose_attack()

  if attacks < max_attacks then
    enemy:throw_arrow()
    attacks = attacks + 1
  else 
    enemy:charge()
    attacks = 0
  end
end


function enemy:throw_arrow()

  local x_enemy, y_enemy, layer_enemy = enemy:get_position()
  arrow = map:create_enemy{
    breed =  'arrow',
    direction = direction_arrow,
    x = x_enemy,
    y = y_enemy,
    width = 16,
    height = 8,
    layer = layer_enemy
  } 
   movement_type = "arrow"
  local movement_arrow = sol.movement.create("straight")
  movement_arrow:set_speed(128)
  movement_arrow:set_smooth(false)
  movement_arrow:set_angle(angle)
  movement_arrow:start(arrow)
   function  movement_arrow:on_obstacle_reached()
      movement_arrow:stop()
      arrow:get_sprite():set_animation("reached_obstacle")
      sol.timer.start(enemy, 1000, function()
          arrow:remove()
          enemy:go_to_initial_position()
      end)
    end
end

function enemy:charge()

  enemy:calculate_parameters()
  sprite:set_animation("attacked")
  sol.timer.start(enemy, 1000, function()
    movement_type = "charge"
    sprite:set_animation("walking")
    local movement_charge = sol.movement.create("straight")
    movement_charge:set_speed(128)
    movement_charge:set_smooth(false)
    movement_charge:set_angle(angle)
   function  movement_charge:on_obstacle_reached()
      movement_charge:stop()
      enemy:set_shocked()
    end
    movement_charge:start(enemy)
  end)

end


function enemy:set_shocked()

    enemy:calculate_parameters()
    sol.audio.play_sound("enemy_bounce")
    sprite:set_animation("shocked")
    enemy:set_attack_consequence("sword", 1)
    local movement_jump = sol.movement.create("jump")
    movement_jump:set_direction8(direction)
    movement_jump:set_distance(32)
    movement_jump:set_speed(128)
    sol.timer.start(enemy, 4000, function()
        enemy:go_to_initial_position()
    end)
    movement_jump:start(enemy)

end

function enemy:on_obstacle_reached()

    enemy:on_restarted()

end


