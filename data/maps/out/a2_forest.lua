local map = ...
local game = map:get_game()
-- Outside - Forest

-- Includes scripts
local fairy_manager = require("scripts/maps/fairy_manager")
local owl_manager = require("scripts/maps/owl_manager")

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
fairy_manager:init_fairy(map, "fairy")

-- Functions

function map:set_music()

  sol.audio.play_music("maps/out/mysterious_forest")

end

function map:init_tarin()
 
  if game:get_value("main_quest_step") > 4 then
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

  map:set_overlay()
  map:init_tarin()
  owl_2:set_visible(false)
  owl_3:set_visible(false)
  if game:has_item("mushroom") or game:has_item("magic_powders_counter") then 
    mushroom:set_visible(false)
  end
  if map:get_game():get_value("owl_2") == true then
        map:set_music()
    end

end

function map:on_draw(destination_surface)

  -- Make the overlay scroll with the camera, but slightly faster to make
  -- a depth effect.
  local camera_x, camera_y = self:get_camera():get_position()
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

function forest_chest_1:on_opened()

  hero:start_treasure("tail_key", 1, "forest_chest_1", function()
    if map:get_game():get_value("owl_3") ~= true and game:get_value("main_quest_step") == 6 then
      owl_manager:appear(map, 3, function()
      map:set_music()
      end)
    end
  end)

end

function lost_sensor:on_activated()

  if game:get_value("main_quest_step") > 4 then
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
      local sprite = destructible:get_sprite():get_animation_set()
      local destruction_sound = destructible:get_destruction_sound()
      local weight = destructible:get_weight()
      local can_be_cut = destructible:get_can_be_cut()
      local damage_on_enemies = destructible:get_damage_on_enemies()
      local modified_ground = destructible:get_modified_ground()

      map.num_destructibles_created = map.num_destructibles_created + 1
      map:create_destructible{
        layer = 0,
        x = x,
        y = y,
        name = "destructible_bis_" .. map.num_destructibles_created,
        sprite = sprite,
        destruction_sound = destruction_sound,
        weight = weight,
        can_be_cut = can_be_cut,
        damage_on_enemies = damage_on_enemies,
        modified_ground = modified_ground,
      }
      tarin_2:set_visible(true)
      tarin_2:get_sprite():fade_out()
    end
  end

  -- Put Tarin above the grass.
  tarin:bring_to_front()
  tarin_2:bring_to_front()
end

function raccoon_lost_warning_sensor:on_activated()

  if game:get_value("main_quest_step") < 5
      and not map.raccoon_warning_done then
    map.raccoon_warning_done = true
    game:start_dialog("maps.out.forest.raccoon_lost_warning")
  end

end

function separator:on_activated()

  if tarin_2 ~= nil then
    tarin_2:set_visible(false)
    map.raccoon_warning_done = false
  end
end

function tarin:on_interaction()

  if game:get_value("main_quest_step") < 5 then
    game:start_dialog("maps.out.forest.raccoon")
  else
    game:start_dialog("maps.out.forest.tarin")
    tarin_2:get_sprite():set_direction(tarin:get_sprite():get_direction())
  end
end

function tarin:on_interaction_item(item)

  if game:get_value("main_quest_step") > 4 then
    return
  end

  if item:get_name() == "magic_powders_counter"  then
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
      game:set_value("main_quest_step", 5)
      hero:unfreeze()
      tarin_2:remove()
      game:start_dialog("maps.out.forest.raccoon_to_tarin", function()
        sol.audio.play_sound("secret_1")
      end)
    end)
  end
end


function fairy_fountain:on_activated()

  local music_name = sol.audio.get_music()
  fairy_manager:launch_fairy_if_hero_not_max_life(map, "fairy", music_name)

end

function owl_2_sensor:on_activated()

  if map:get_game():get_value("owl_2") ~= true then
        print("go")
      owl_manager:appear(map, 2, function()
        map:set_music()
      end)
    end


end


