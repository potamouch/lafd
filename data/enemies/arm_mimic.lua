-- Lua script of enemy arm_mimic.
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
local movement

-- Event called when the enemy is initialized.
function enemy:on_created()

  -- Initialize the properties of your enemy here,
  -- like the sprite, the life and the damage.
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  self:set_life(1)
  self:set_damage(1)
  enemy:set_attack_consequence("arrow", "custom")
  enemy:set_attack_consequence("boomerang", "custom")
  enemy:set_attack_consequence("sword", "custom")
  enemy:set_attack_consequence("thrown_item", "custom")
  enemy:set_fire_reaction("custom")
  enemy:set_hammer_reaction("custom")
  enemy:set_hookshot_reaction("custom")

end

-- Event called when the enemy should start or restart its movements.
-- This is called for example after the enemy is created or after
-- it was hurt or immobilized.
function enemy:on_restarted()
  
  local sprite = enemy:get_sprite()
  sprite:set_animation("walking")
  sprite:set_paused(true)
  movement = sol.movement.create("target")
  local x_hero, y_hero = hero:get_position()
  sol.timer.start(enemy, 50, function()
    if hero:get_state() ~= "running" then
      self:set_attack_consequence("sword", "custom")
      local direction = 0
      local movement_hero = hero:get_movement()
      if not movement_hero then
        direction = hero:get_sprite():get_direction()
      else
        direction = movement_hero:get_direction4()
      end
      local direction_enemy = 0
      if direction == 0 then
        direction_enemy = 2
      elseif direction == 1 then
        direction_enemy = 3
      elseif direction == 3 then
        direction_enemy = 1
      end
      local x_new_hero, y_new_hero = hero:get_position()
      local x_enemy, y_enemy = enemy:get_position()
      local diff_x = x_new_hero - x_hero
      local diff_y = y_new_hero - y_hero
      if diff_x ~= 0 or diff_y  ~= 0 then
            sprite:set_paused(false)
      else
            sprite:set_paused(true)
      end
      x_enemy = x_enemy - diff_x
      y_enemy = y_enemy - diff_y
      enemy:get_sprite():set_direction(direction_enemy)
      movement:set_target(x_enemy, y_enemy)
      movement:set_speed(200)
      movement:start(enemy)
      x_hero = x_new_hero
      y_hero  = y_new_hero
  else
      self:set_attack_consequence("sword", 1)
      local x_new_hero, y_new_hero = hero:get_position()
      x_hero = x_new_hero
      y_hero  = y_new_hero
  end
  return true
end)

end

function enemy:on_custom_attack_received(attack)

  -- Custom reaction: don't get hurt but step back.
  sol.timer.stop_all(enemy)  -- Stop the towards_hero behavior.
  local hero = enemy:get_map():get_hero()
  local angle = hero:get_angle(enemy)
  local movement_straight = sol.movement.create("straight")
  movement_straight:set_speed(64)
  movement_straight:set_angle(angle)
  movement_straight:start(enemy)
  sol.timer.start(enemy, 400, function()
    enemy:restart()
  end)
end