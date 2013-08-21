local map = ...
local game = map:get_game()
-- Outside - Forest

-- Includes scripts

sol.main.load_file("npc/owl")(map)

-- Variables

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

function map:init_tarkin()
 
  if game:get_value("step_2_link_found_sword") == false  then
    tarkin:set_visible(false)
  else
    tarkin:get_sprite():set_animation("waiting_raccoon")
  end

end

function  map:talk_to_tarkin() 

  game:start_dialog("forest_.tarkin_1")

end

function map:set_overlay()

  map.overlay = sol.surface.create("entities/overlay_forest.png")
  map.overlay:set_opacity(96)
  map.overlay_offset_x = 0  -- Used to keep continuity when getting lost.
  map.overlay_offset_y = 0
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

-- Events

function tarkin:on_interaction()

  map:talk_to_tarkin()

end

function map:on_started(destination)

  map:set_music()
  map:set_overlay()
  map:init_tarkin()
  owl:set_visible(false)

end

function map:on_draw(destination_surface)

  -- Make the overlay scroll with the camera, but slightly faster to make
  -- a depth effect.
  local camera_x, camera_y = self:get_camera_position()
  local overlay_width, overlay_height = map.overlay:get_size()
  local screen_width, screen_height = destination_surface:get_size()
  local x, y = camera_x + map.overlay_offset_x, camera_y + map.overlay_offset_y
  x, y = -math.floor(x * 1.5), -math.floor(y * 1.5)

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

function owl_1_sensor:on_activated()

  if map:get_game():get_value("owl_2") == true then
    map:set_music()
  else
    map:owl_appear(2)
  end

end

local num_destructibles_created = 0
function lost_sensor:on_activated()

  local x, y = hero:get_position()
  local sensor_x, sensor_y = self:get_position()
  local marker_x, marker_y = lost_destination:get_position()
  local diff_x, diff_y = marker_x - sensor_x, marker_y - sensor_y
  hero:set_position(x + diff_x, y + diff_y)
  map.overlay_offset_x = map.overlay_offset_x - diff_x  -- Keep continuity of the overlay effect.
  map.overlay_offset_y = map.overlay_offset_y - diff_y

  -- Keep the exact same destructible entities so that the player cannot see a difference.

  for destructible in map:get_entities("destructible_") do

    -- Destroy all bushes and grass entities in the east screen.
    local x, y = destructible:get_position()
    if destructible:get_position() > 480 then
      destructible:remove()
    else
      -- Move to the east the ones from the west.
      -- Some of them might be currently playing an animation, that's why
      -- we move them.
      destructible:set_position(x + diff_x, y + diff_y)

      -- And re-create the west ones.
      local subtype
      if x > 408 or y > 344 then
        -- TODO destructible:get_subtype() instead.
        subtype = "grass"
      else
        subtype = "bush"
      end

      num_destructibles_created = num_destructibles_created + 1
      map:create_destructible{
        layer = 0,
        x = x,
        y = y,
        name = "destructible_bis_" .. num_destructibles_created,
        subtype = subtype,
      }
    end
  end

  -- Put Tarkin above the grass.
  -- TODO entity:bring_to_front() instead of this workaround
  local x, y, layer = tarkin:get_position()
  tarkin:set_position(x, y, layer + 1)
  tarkin:set_position(x, y, layer)
  x, y, layer = tarkin_2:get_position()
  tarkin_2:set_position(x, y, layer + 1)
  tarkin_2:set_position(x, y, layer)
end


