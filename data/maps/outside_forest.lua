-- Outside - Forest

-- Includes scripts
sol.main.load_file("npc/owl")(game)
-- Variables
local map = ...
map.overlay_angles = {
  3 * math.pi / 4,
  5 * math.pi / 4,
      math.pi / 4,
  7 * math.pi / 4
}
map.overlay_step = 1

-- Functions
function map:set_music()

  sol.audio.play_music("mysterious_forest")

end

function map:on_started(destination)

  map:set_music()
  map:set_overlay()
  set_owl_disabled()

end

function map:on_draw(destination_surface)

  -- Make the overlay scroll with the camera, but slightly faster to make
  -- a depth effect.
  local camera_x, camera_y = self:get_camera_position()
  local overlay_width, overlay_height = map.overlay:get_size()
  local screen_width, screen_height = destination_surface:get_size()
  local x, y = -math.floor(camera_x * 1.5), -math.floor(camera_y * 1.5)

  -- The overlay's image may be shorter than the screen, so we repeat its
  -- pattern. Furthermore, it also has a movement so let's make sure it
  -- will always fill the whole screen.
  x = x % overlay_width - 2 * overlay_width
  y = y % overlay_height - 2 * overlay_height

  local dst_y = y
  while dst_y < screen_height + overlay_height do
    local dst_x = x
    while dst_x < screen_width + overlay_width do
      -- Repeat the overlay's pattern.
      map.overlay:draw(destination_surface, dst_x, dst_y)
      dst_x = dst_x + overlay_width
    end
    dst_y = dst_y + overlay_height
  end

end

function map:set_overlay()

  map.overlay = sol.surface.create("entities/overlay_forest.png")
  map.overlay:set_opacity(96)
  map.overlay_m = sol.movement.create("straight")
  map.restart_overlay_movement()

end

function map:restart_overlay_movement()

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

function owl_1_sensor:on_activated()

  if map:get_game():get_value("owl_2") == true then
    map:set_music()
  else
    owl_appear(2)
  end

end

local function set_owl_disabled()

  owl:set_visible(false)

end


