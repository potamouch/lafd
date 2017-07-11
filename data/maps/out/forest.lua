local map = ...
local game = map:get_game()
-- Outside - Forest

-- Includes scripts

sol.main.load_file("scripts/npc/owl")(map)  -- TODO use require

-- Variables

map.overlay_angles = {
  3 * math.pi / 4,
  5 * math.pi / 4,
      math.pi / 4,
  7 * math.pi / 4
}
map.overlay_step = 1

map.num_destructibles_created = 0
map.raccoon_warning_done = false

-- Functions

function map:set_music()

  sol.audio.play_music("mysterious_forest")

end

function map:init_tarin()
 
  if game:get_value("forest_raccoon_solved") then
    tarin:remove()
    tarin_2:remove()
  else
    tarin:get_sprite():set_animation("waiting_raccoon")
    tarin_2:get_sprite():set_animation("waiting_raccoon")
    tarin_2:get_sprite():synchronize(tarin:get_sprite())
    tarin_2:set_visible(false)
  end

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

function map:on_started(destination)

  map:set_music()
  map:set_overlay()
  map:init_tarin()
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

function lost_sensor:on_activated()

  if game:get_value("forest_raccoon_solved") then
    return
  end

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

      map.num_destructibles_created = map.num_destructibles_created + 1
      map:create_destructible{
        layer = 0,
        x = x,
        y = y,
        name = "destructible_bis_" .. map.num_destructibles_created,
        subtype = subtype,
      }
      tarin_2:set_visible(true)
      tarin_2:get_sprite():fade_out()
    end
  end

  -- Put Tarkin above the grass.
  -- TODO entity:bring_to_front() instead of this workaround
  local x, y, layer = tarin:get_position()
  tarin:set_position(x, y, layer + 1)
  tarin:set_position(x, y, layer)
  x, y, layer = tarin_2:get_position()
  tarin_2:set_position(x, y, layer + 1)
  tarin_2:set_position(x, y, layer)
end

function raccoon_lost_warning_sensor:on_activated()

  if not game:get_value("forest_raccoon_solved")
      and not map.raccoon_warning_done then
    map.raccoon_warning_done = true
    game:start_dialog("forest.raccoon_lost_warning")
  end

end

function separator:on_activated()

  if tarin_2 ~= nil then
    tarin_2:set_visible(false)
    map.raccoon_warning_done = false
  end
end

function tarin:on_interaction()

  if not game:get_value("forest_raccoon_solved") then
    game:start_dialog("forest.raccoon")
  else
    game:start_dialog("forest.tarin")
    tarin_2:get_sprite():set_direction(tarin:get_sprite():get_direction())
  end
end

function tarin:on_interaction_item(item)

  if game:get_value("forest_raccoon_solved") then
    return
  end

  if item:get_name() == "magic_powder" and item:get_variant() == 2 then
    hero:freeze()
    local x, y, layer = tarin:get_position()
    sol.audio.play_sound("explosion")
    map:create_explosion{
      layer = layer,
      x = x,
      y = y,
    }
    -- TODO make a movement instead.
    tarin:get_sprite():set_animation("stopped")
    sol.timer.start(map, 1000, function()
      game:set_value("forest_raccoon_solved", true)
      hero:unfreeze()
      tarin_2:remove()
      game:start_dialog("forest.raccoon_to_tarin", function()
        sol.audio.play_sound("secret")
      end)
    end)
  end
end

