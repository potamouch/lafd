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
  enemy:set_attack_consequence("sword", "protected")
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
    -- Sprite direction
    local direction = hero:get_direction()
    direction = direction + 2
    if direction >= 4 then
      direction = direction - 4
    end
    sprite:set_direction(direction)
    -- Enemy movement
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
    movement:set_target(x_enemy, y_enemy)
    movement:set_speed(200)
    movement:start(enemy)
    x_hero = x_new_hero
    y_hero  = y_new_hero
  return true
end)

end

function enemy:on_custom_attack_received(attack)

end