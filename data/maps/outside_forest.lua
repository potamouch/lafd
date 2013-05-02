-- Outside - Forest
local map = ...
map.overlay_angles = {3*math.pi / 4, 5*math.pi / 4, math.pi / 4, 7*math.pi / 4}
map.overlay_step = 1

function map:set_music()

    sol.audio.play_music("mysterious_forest")

end

function map:on_started(destination)

  map:set_music()
  map:set_overlay()

end

function map:on_draw(destination_surface)

    map.overlay:draw(destination_surface, 0, 0)

end

function map:set_overlay()

  map.overlay = sol.surface.create("entities/overlay_forest.png")
  map.overlay:set_opacity(150)
  map.restart_overlay_movement()

end

function map:restart_overlay_movement()

  map.overlay_m = sol.movement.create("straight") 
  map.overlay_m:set_speed(16) 
  map.overlay_m:set_max_distance(100)
  map.overlay_m:set_angle(map.overlay_angles[map.overlay_step])
  map.overlay_step = map.overlay_step + 1
  if map.overlay_step > #map.overlay_angles then
    map.overlay_step = 1
  end
  map.overlay_m:start(map.overlay, function()
    map:restart_overlay_movement()
  end)

end
