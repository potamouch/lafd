-- Outside - Forest
local map = ...

function map:set_music()

    sol.audio.play_music("mysterious_forest")

end

function map:on_started(destination)

  map:set_music()
  map:set_overlay()

end

function map:on_draw(destination_surface)

    overlay:draw(destination_surface, -200, 0)

end

function map:set_overlay()

  overlay = sol.surface.create("entities/overlay_forest.png")
  overlay:set_opacity(150)
  map:overlay_movement_1()

end

function map:overlay_movement_1()

  overlay_m = sol.movement.create("straight") 
  overlay_m:set_speed(16) 
  overlay_m:set_angle(math.pi/4) 
  overlay_m:set_max_distance(100)
  overlay_m:start(overlay, function()
    map:overlay_movement_2()
  end)

end

function map:overlay_movement_2()

  overlay_m = sol.movement.create("straight") 
  overlay_m:set_speed(16) 
  overlay_m:set_angle(2 * math.pi/3) 
  overlay_m:set_max_distance(100)
  overlay_m:start(overlay, function()
    map:overlay_movement_3()
  end)

end

function map:overlay_movement_3()

  overlay_m = sol.movement.create("straight") 
  overlay_m:set_speed(16) 
  overlay_m:set_angle(- 2*math.pi/3) 
  overlay_m:set_max_distance(100)
  overlay_m:start(overlay, function()
    map:overlay_movement_4()
  end)

end

function map:overlay_movement_4()

  overlay_m = sol.movement.create("straight") 
  overlay_m:set_speed(16) 
  overlay_m:set_angle(-math.pi/4) 
  overlay_m:set_max_distance(100)
  overlay_m:start(overlay, function()
    map:overlay_movement_1()
  end)

end
