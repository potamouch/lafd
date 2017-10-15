local enemy = ...

local map = enemy:get_map()
local hero = map:get_hero()
local wait = true
local movement
-- Keese: a bat that sleeps until the hero gets close.

function enemy:on_created()

  self:create_sprite("enemies/" .. enemy:get_breed())
  self:set_life(1)
  self:set_damage(2)
  self:set_obstacle_behavior("flying")

end


function enemy:on_restarted()

  self:get_sprite():set_animation("stopped")
  sol.timer.start(enemy, 50, function()
    if wait == true and hero:get_distance(enemy) < 64  then
      local x, y , layer = hero:get_position()
      self:get_sprite():set_animation("walking")
      wait = false
      movement = sol.movement.create("path_finding")
      movement:set_speed(32)
      movement:set_target(hero)
      movement:start(enemy)
      sol.timer.start(enemy, 1500, function()
        self:get_sprite():set_animation("stopped")
        movement:stop()
        wait = true
      end)
    else
     
        

    end
    return true
  end)

end


enemy:set_layer_independent_collisions(true)
