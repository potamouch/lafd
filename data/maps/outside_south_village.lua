-- South village
local map = ...

local function set_music()

  if map:get_game():get_value("step_1_link_search_sword") == true then
    sol.audio.play_music("sword_search")
  else
    sol.audio.play_music("links_awake")
  end

end

local function set_owl_disabled()

  owl:set_visible(false)

end

function map:on_started(destination)

  set_music()
  set_owl_disabled()

end

function owl_1_sensor:on_activated()

  if map:get_game():get_value("owl_1") == true then
    set_music()
  else
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
    map:get_game():set_value("owl_1", true)
    hero:set_direction(1)
    hero:freeze()
    function m:on_finished() 
      map:start_dialog("owl_1", function()
        local m2 = sol.movement.create("target")
        m2:set_target(owl_position_1)
        m2:set_speed(60)
        m2:set_ignore_obstacles(true)
        m2:start(owl, function()
          set_music()
         hero:unfreeze()
        end)
      end)      
    end
  end

end


