-- Initialize hero behavior specific to this quest.

require("scripts/multi_events")
local hero_meta = sol.main.get_metatable("hero")

hero_meta:register_event("on_state_changed", function(hero)
  local current_state = hero:get_state()
  if hero.previous_state == "carrying" then
    hero:notify_object_thrown()
  end
  hero.previous_state = current_state
end)
hero_meta:register_event("notify_object_thrown", function() end)

hero_meta:register_event("on_position_changed", function(hero)

  local game = hero:get_game()
  local map = game:get_map()
  local dungeon = game:get_dungeon()
  local x, y = hero:get_center_position()
  if dungeon == nil then
    local world = map:get_world()
    local square_x = 0
    local square_y = 0
    local square_mini_x = 0
    local square_mini_y = 0
    local square_total_x = 0
    local square_total_y = 0
    local map_max_x = 3840
    local map_max_y = 3072
    if world == "outside_world" then
      local map_x, map_y = map:get_location()
      local map_size_x, map_size_y = map:get_size()
      square_x = math.floor((map_x + 960) / (960) - 1)
      square_y = math.floor((map_y + 768) / (768) - 1)
      if x == 0 then
        square_min_x = 0
      else
        square_min_x = math.floor((x+240)/(240)-1)
      end
      if y == 0 then
        square_min_y = 0
      else
        square_min_y = math.floor((y+192)/(192)-1)
      end
      square_total_x = (4*square_x)+square_min_x
      square_total_y = (4*square_y)+square_min_y
      game:set_value("map_discovering_" .. square_total_x .. "_" .. square_total_y, true)
      game:set_value("map_hero_position_x", square_total_x)
      game:set_value("map_hero_position_y", square_total_y)
    end
  else
    local map_width, map_height = map:get_size()
    local room_width, room_height = 320, 256  -- TODO don't hardcode these numbers
    local num_columns = math.floor(map_width / room_width)
    local column = math.floor(x / room_width)
    local row = math.floor(y / room_height)
    local room = row * num_columns + column + 1
    local room_old = game:get_value("room")
    if game:has_dungeon_compass() and room_old ~= room and game:is_secret_room(nil, nil, room)  and game:is_secret_signal_room(nil, nil, room) then
      local timer = sol.timer.start(map, 500, function()
        sol.audio.play_sound("compass_signal")
      end)
    end
    game:set_value("room", room)
    game:set_explored_dungeon_room(nil, nil, room)
    
  end
end)

hero_meta:register_event("on_state_changed", function(hero , state)

  local game = hero:get_game()

  -- Avoid to lose any life when drowning.
  if state == "back to solid ground" then
    local ground = hero:get_ground_below()
    if ground == "deep_water" then
      game:add_life(1)
    end
  end
end)

-- Return true if the hero is walking.
function hero_meta:is_walking()

  local m = self:get_movement()
  return m and m.get_speed and m:get_speed() > 0
end

-- Set fixed stopped/walking animations for the hero (or nil to disable them).
function hero_meta:set_fixed_animations(new_stopped_animation, new_walking_animation)

  fixed_stopped_animation = new_stopped_animation
  fixed_walking_animation = new_walking_animation
  -- Initialize fixed animations if necessary.
  local state = self:get_state()
  if state == "free" then
    if self:is_walking() then self:set_animation(fixed_walking_animation or "walking")
    else self:set_animation(fixed_stopped_animation or "stopped") end
  end
end

-- Initialize hero behavior specific to this quest.

local hero_meta = sol.main.get_metatable("hero")

function hero_meta:on_created()

  local hero = self
  --hero:set_tunic_sprite_id("hero/eldran")
  hero:initialize_fixing_functions() -- Used to fix direction and animations.
end

--------------------------------------------------
-- Functions to fix tunic animation and direction.
--------------------------------------------------
local fixed_direction, fixed_stopped_animation, fixed_walking_animation

-- Return true if the hero is walking.
function hero_meta:is_walking()

  local m = self:get_movement()
  return m and m.get_speed and m:get_speed() > 0
end

-- Get fixed direction for the hero.
function hero_meta:get_fixed_direction()

  return fixed_direction
end

-- Get fixed stopped/walking animations for the hero.
function hero_meta:get_fixed_animations()

  return fixed_stopped_animation, fixed_walking_animation
end

-- Set a fixed direction for the hero (or nil to disable it).
function hero_meta:set_fixed_direction(new_direction)

  fixed_direction = new_direction
  if fixed_direction then self:get_sprite("tunic"):set_direction(fixed_direction) end
end

-- Set fixed stopped/walking animations for the hero (or nil to disable them).
function hero_meta:set_fixed_animations(new_stopped_animation, new_walking_animation)

  fixed_stopped_animation = new_stopped_animation
  fixed_walking_animation = new_walking_animation
  -- Initialize fixed animations if necessary.
  local state = self:get_state()
  if state == "free" then
    if self:is_walking() then self:set_animation(fixed_walking_animation or "walking")
    else self:set_animation(fixed_stopped_animation or "stopped") end
  end
end

-- Initialize events to fix direction and animation for the tunic sprite of the hero.
-- For this purpose, we redefine on_created and set_tunic_sprite_id events for the hero metatable.
function hero_meta:initialize_fixing_functions()

  local hero = self
  local sprite = hero:get_sprite("tunic")

  -- Define events for the tunic sprite.
  function sprite:on_animation_changed(animation)
    local tunic_animation = sprite:get_animation()
    if tunic_animation == "stopped" and fixed_stopped_animation ~= nil then 
      if fixed_stopped_animation ~= tunic_animation then
        sprite:set_animation(fixed_stopped_animation)
      end
    elseif tunic_animation == "walking" and fixed_walking_animation ~= nil then 
      if fixed_walking_animation ~= tunic_animation then
        sprite:set_animation(fixed_walking_animation)
      end
    --elseif tunic_animation == "pushing" then
      --local pushing_animation = hero:get_pushing_animation()
      --if pushing_animation then hero:set_animation(pushing_animation) end
    --end
  end
  function sprite:on_direction_changed(animation, direction)
    local fixed_direction = fixed_direction
    local tunic_direction = sprite:get_direction()
    if fixed_direction ~= nil and fixed_direction ~= tunic_direction then
      sprite:set_direction(fixed_direction)
    end
  end
end

-- Initialize fixing functions for the new sprite when the tunic sprite is changed.
local old_set_tunic = hero_meta.set_tunic_sprite_id -- We redefine this function.
function hero_meta:set_tunic_sprite_id(sprite_id)
    old_set_tunic(self, sprite_id)
    self:initialize_fixing_functions()
  end
end


return true
