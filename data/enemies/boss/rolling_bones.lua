-- Lua script of enemy blob_green.
-- This script is executed every time an enemy with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local enemy = ...
local spike
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite
local sprite_spike
local movement
local movement_spike
local spike_offset = 73
local spike_direction = math.pi
local enemy_step = 1
local angle_to_spike

-- Event called when the enemy is initialized.

function enemy:on_created()

  local x_enemy,y_enemy,layer_enemy = enemy:get_position()
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  sprite:set_direction(2)
  enemy:set_life(5)
  enemy:set_damage(1)
  enemy:set_hurt_style("boss")
  -- Spike
  spike = map:create_enemy{
    breed = enemy:get_breed() .. "/rolling_bones_spike",
    direction = 2,
    x = x_enemy - 64,
    y = y_enemy - spike_offset,
    layer = layer_enemy
  }
  sprite_spike = spike:get_sprite()
  sprite_spike:set_animation("stopped")
  function sprite:on_animation_finished(animation)
    if animation == "punching" then
      sol.audio.play_sound("boss_1_explode_part")
      sprite:set_animation("walking")
      enemy:go_spike()
      enemy:go_on_the_other_side()
    end
  end
  -- Sound
  sol.timer.start(spike, 150, function()
    if spike_move then
      sol.audio.play_sound("rolling_spike")
    end
    return true
  end)
 enemy:change_angle()
 enemy:go_to_spike()

end

-- Step 1
function enemy:go_to_spike()
  enemy_step = 1
  local spike_x, spike_y = spike:get_position()
  local direction = sprite:get_direction()
  if direction == 0 then
    spike_x = spike_x - 24
  else
    spike_x = spike_x + 24
  end
  movement = sol.movement.create("target")
  movement:set_target(spike_x, spike_y + 73)
  movement:set_speed(64)
  movement:start(enemy)
  function movement:on_finished()
    movement:stop()
    enemy:change_angle()
    enemy:push_spike()
  end  
end

-- Step 2
function enemy:push_spike()

    enemy_step = 2
   sol.timer.start(enemy, 250, function()
      sol.audio.play_sound("boss_1_explode_part")
   end)
   sprite:set_animation("punching")

end

-- Step 3
function enemy:go_on_the_other_side()

  enemy_step = 3
  enemy_continue_move = true
  if angle_enemy ==  angle_to_spike - math.pi / 4 then
    angle_enemy = angle_to_spike + math.pi / 4
  else
    angle_enemy = angle_to_spike - math.pi / 4
  end
  movement_enemy = sol.movement.create("straight")
  movement_enemy:set_speed(96)
  movement_enemy:set_max_distance(64)
  movement_enemy:set_angle(angle_enemy)
  function movement_enemy:on_position_changed()
      local x_enemy, y_enemy, layer_enemy = enemy:get_position()
      local x_spike, y_spike, layer_spike = spike:get_position()
      local direction = sprite:get_direction()
      if direction == 0 then
        if x_enemy >= x_spike + 48 then
           movement:stop()
          enemy_continue_move = false
          enemy:change_direction()
          movement_enemy:stop()
          enemy:go_to_spike()
        end
      else
        if x_enemy <= x_spike - 48 then
           movement:stop()
          enemy_continue_move = false
          enemy:change_direction()
          movement_enemy:stop()
          enemy:go_to_spike()
        end
      end
  end
  function movement_enemy:on_finished()
    if enemy_continue_move then
      sol.timer.start(spike, 200, function()
        enemy:go_on_the_other_side()
      end)
    end
  end
  movement_enemy:start(enemy)

end

function enemy:go_spike()

  movement_spike = sol.movement.create("straight")
  movement_spike:set_speed(96)
  movement_spike:set_angle(spike_direction)
  movement_spike:set_max_distance(200)
  sprite_spike:set_animation("walking")
  spike_move = true
  function movement_spike:on_obstacle_reached()
      spike_direction = math.pi - spike_direction
      movement_spike:set_angle(spike_direction)
      movement_spike:set_max_distance(64)
  end
  function movement_spike:on_finished()
    sprite_spike:set_animation("stopped")
    spike_move = false
  end
  movement_spike:start(spike)

end

function enemy:change_direction()

  local direction = sprite:get_direction()
  if direction == 0 then
    sprite:set_direction(2)
  else
    sprite:set_direction(0)
  end

end

function enemy:change_angle()

  local x_enemy,y_enemy,layer_enemy = enemy:get_position()
  local x_spike,y_spike,layer_spike = spike:get_position()
  angle_to_spike = sol.main.get_angle(x_enemy, y_enemy, x_spike, y_spike + 73)

end

function enemy:on_hurt(attack)

  if enemy:get_life() <= 0 then
    spike:remove()
  end

end


-- Event called when the enemy should start or restart its movements.
-- This is called for example after the enemy is created or after
-- it was hurt or immobilized.
function enemy:on_restarted() 

  if enemy_step == 3 then
    enemy:go_on_the_other_side()
  else
    enemy:go_to_spike()
  end

end
