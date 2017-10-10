-- Lua script of enemy moldorm.
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
local sprite_head
local circle_x
local circle_y
local angle = 0
local clockwise = nil

-- Event called when the enemy is initialized.
function enemy:on_created()

  local x, y, layer = enemy:get_position()
  circle_x = x
  circle_y = y
  sprite_head = enemy:create_sprite("enemies/" .. enemy:get_breed() .. "_head")
  enemy:set_life(4)
  enemy:set_damage(1)
  enemy:set_traversable(true)

end

function enemy:on_restarted()

  enemy:start_move()

end

function enemy:start_move()

    sol.timer.start(hero, math.random(1000), function()
        enemy:update_movement()
        return true
    end)

end

function enemy:update_movement()

      local x, y, layer = enemy:get_position()
      local clockwise_new = math.random(2)
      if clockwise_new ~= clockwise then
        clockwise = clockwise_new
        local movement = sol.movement.create("circle")
        angle = angle + math.pi
        movement:set_radius(32)
        movement:set_angle_speed(90)
        movement:set_initial_angle(angle)
        circle_x, circle_y = x - (circle_x - x), y - (circle_y - y)
        if clockwise == 1 then
          movement:set_clockwise(true)
        else
          movement:set_clockwise(false)
        end
        movement:set_center(circle_x, circle_y)
        movement:start(enemy)
      end
     

end
