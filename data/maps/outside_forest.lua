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
  overlay_m = sol.movement.create("straight") 
  overlay_m:set_speed(16) 
  overlay_m:set_angle(math.pi / 4)
  overlay_m:set_max_distance(100)
  map:overlay_movement_start()

end

function map:overlay_movement_start()

  overlay_m:start(overlay, function()
    overlay_m:set_speed(16)
    overlay_m:set_angle(2 * math.pi - overlay_m:get_angle()) 
    map:overlay_movement_start()
  end)

end
