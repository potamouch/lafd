local owl_manager = {}

function owl_manager:appear(map, step)

    local game = map:get_game()
    local hero = map:get_entity("hero")
    local owl = map:get_entity("owl_"..step)
    local x_hero,y_hero = hero:get_position()
    local x_owl,y_owl = owl:get_position()
    game:set_pause_allowed(false)
   --game:set_suspended(true)
    owl:set_visible(true)
    owl:get_sprite():set_animation("walking")
    local m = sol.movement.create("target")
    local xy = { x = x_owl, y = y_owl }
    function m:on_position_changed(coord_x, coord_y)
      owl:set_position(coord_x, coord_y)
    end
    y_hero= y_hero - 32
    m:set_target(x_hero, y_hero)
    m:set_speed(60)
    m:set_ignore_obstacles(true)
    m:start(xy)
    sol.audio.play_music("scripts/meta/map/the_wise_owl")
    game:set_value("owl_"..step, true)
    hero:set_direction(1)
    hero:freeze()
    m:start(owl, function() 
      owl:get_sprite():set_animation("talking")
      game:start_dialog("scripts.meta.map.owl_"..step, function()
        owl:get_sprite():set_animation("walking")
        local m2 = sol.movement.create("target")
        local x_owl,y_owl = owl:get_position()
        local xy = { x = x_owl, y = y_owl }
        function m2:on_position_changed(coord_x, coord_y)
          owl:set_position(coord_x, coord_y)
        end
        local position = map:get_entity("owl_"..step.."_position")
        m2:set_target(position)
        m2:set_speed(100)
        m2:set_ignore_obstacles(true)
        m2:start(xy, function()
          owl:set_visible(false)
          if callback ~= nil then
            callback()
          else
            hero:unfreeze()
            --game:set_suspended(false)
          end
        end)
      end)      
    end)

end

return owl_manager