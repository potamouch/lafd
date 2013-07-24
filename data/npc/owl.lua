-- Owl
local game = ...
local map = game:get_map()
local hero = map:get_entity("hero")
local owl = map:get_entity("owl")

function map:owl_appear(step)
  
  game:set_pause_allowed(false)
  owl:set_visible(true)
  owl:get_sprite():set_animation("walking")
  local m = sol.movement.create("target")
  local x,y = hero:get_position()
  y = y - 32
  m:set_target(x, y)
  m:set_speed(60)
  m:set_ignore_obstacles(true)
  m:start(owl)
  sol.audio.play_music("the_wise_owl")
  game:set_value("owl_"..step, true)
  hero:set_direction(1)
  hero:freeze()
  function m:on_finished() 
    map:start_dialog("owl_"..step, function()
      local m2 = sol.movement.create("target")
      local position = map:get_entity("owl_"..step.."_position")
      m2:set_target(position)
      m2:set_speed(100)
      m2:set_ignore_obstacles(true)
      m2:start(owl, function()
  	owl:set_visible(false)
        hero:unfreeze()
        game:set_pause_allowed(true)
	map:set_music()
      end)
    end)      
  end

end
