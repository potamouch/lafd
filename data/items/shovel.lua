-- Shovel
local item = ...
local game = item:get_game()

require("scripts/multi_events")

local map_meta = sol.main.get_metatable("map")

function item:on_created()

  item:set_savegame_variable("possession_shovel")
  item:set_assignable(true)

end

function item:on_using()

  local game = item:get_game()
  local map = game:get_map()
  local hero = map:get_hero()

  hero:freeze()
  local dig_indexes = item:test_dig()
  if dig_indexes == nil then
    -- No digging possible here.
    sol.audio.play_sound("sword_tapping")
    hero:set_animation("shovel_fail", function()
      hero:unfreeze()
    end)

  else
    -- Digging here is allowed.
    sol.audio.play_sound("dig")
    hero:set_animation("shovel", function()
      hero:unfreeze()
    end)

    map:set_digging_allowed_square(dig_indexes[1], false)
    map:set_digging_allowed_square(dig_indexes[2], false)
    map:set_digging_allowed_square(dig_indexes[3], false)
    map:set_digging_allowed_square(dig_indexes[4], false)

    local x, y = item:get_position_from_index(dig_indexes[1])
    local layer = hero:get_layer()

    sol.timer.start(map, 150, function()
      map:create_dynamic_tile{
        x = x,
        y = y,
        layer = layer,
        width = 16,
        height = 16,
        pattern = "728",
        enabled_at_start = true
      }

--[[ TODO
      if map.shovel_treasures[index] ~= nil then
        map.shovel_treasures[index]:bring_to_front()
        map.shovel_treasures[index]:set_enabled(true)
      else
        map:create_pickable{
          layer = layer,
          x = x,
          y = y,
          treasure_name = "random",
          treasure_variant = 1,
        }
      end
--]]
    end)
  end

  item:set_finished()

end


-- Check if hero can current dig from his current position.
-- If sucessful, returns the index of the 4 squares where to dig.
-- Otherwise, returns nil.
function item:test_dig()

  local map = game:get_map()
  local hero = map:get_hero()

  -- 1. The map must allow digging.
  if not map:is_digging_allowed() then
    return nil
  end

  local top_left_index = item:get_hero_digging_index()
  local indexes = {
    item:get_four_indexes(top_left_index)
  }

  for _, index in ipairs(indexes) do

    -- 2. The square must not be marked as non diggable.
    if not map:is_digging_allowed_square(index) then
      return nil
    end

    -- 3. The ground must be traversable.
    local x, y = item:get_position_from_index(index)
    local layer = hero:get_layer()
    if map:get_ground(x, y, layer) ~= "traversable" then
      return nil
    end
  end

  return indexes

end

-- Returns the index of the upper-left square from the 4 squares where
-- the hero can try to dig.
function item:get_hero_digging_index()

  local hero = game:get_hero()
  local x, y, layer = hero:get_position()
  local origin_x, origin_y = hero:get_origin()
  x, y = x - origin_x + 4, y - origin_y + 4  -- Center of the top-left 8x8 square of the hero.
  local direction = hero:get_direction()
  if direction == 0 then
    x = x + 12
    y = y + 2
  elseif direction == 1 then
    y = y - 12
  elseif direction == 2 then
    x = x - 12
    y = y + 2
  elseif direction == 3 then
    y = y + 12
  end

  return item:get_index_from_position(x, y, layer)
end

-- Returns the four 8x8 squares from the top-left one.
function item:get_four_indexes(top_left_index)

  local map = item:get_map()
  local columns, rows = map:get_size_8()
  return top_left_index, top_left_index + 1, top_left_index + columns, top_left_index + columns + 1

end

-- Returns the 8x8 square that contains the given coordinates.
function item:get_index_from_position(x, y, layer)

  -- TODO take layer into account
  local map = game:get_map()
  local i = math.floor(y / 8)
  local j = math.floor(x / 8)
  local columns, rows = map:get_size_8()
  local index = i * columns + j
  
  return index 

end

-- Returns the coordinates of the upper-left corner of an 8x8 square.
function item:get_position_from_index(index)

  local map = game:get_map()
  local columns, rows = map:get_size_8()
  local i = math.floor(index / columns)
  local j = index % columns
  return j * 8, i * 8
end

function map_meta:get_size_8()

  local width, height = self:get_size()

  return width / 8, height / 8

end

-- Returns whether digging is allowed on a map.
function map_meta:is_digging_allowed()

  if self.is_diggable == nil then
    return false
  end

  return self.is_diggable

end

-- Disable / Enable digging on map.
function map_meta:set_digging_allowed(is_diggable)
  
  self.is_diggable = is_diggable

end

-- Returns whether digging is allowed on an 8x8 square.
-- This only checks whether the square was marked as non diggable.
-- The ground is not checked here.
function map_meta:is_digging_allowed_square(square_index)

  if self.non_diggable_squares == nil then
    return true
  end

  return not self.non_diggable_squares[square_index]

end

function map_meta:set_digging_allowed_square(square_index, diggable)

  self.non_diggable_squares = self.non_diggable_squares or {}
  if diggable then
    self.non_diggable_squares[square_index] = nil
  else
    self.non_diggable_squares[square_index] = true
  end

end

game:register_event("on_map_changed", function(game, map)

  for pickable in map:get_entities("auto_shovel") do
    local index = map:get_entity_position_index(pickable)
    map.shovel_treasures[index] = pickable
    pickable:set_enabled(false)
  end

end)
