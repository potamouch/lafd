-- Shovel
local item = ...
local map_meta = sol.main.get_metatable("map")
local game = item:get_game()
require("scripts/multi_events")

function item:on_created()

  self:set_savegame_variable("possession_shovel")
  self:set_assignable(true)

end


function item:on_using()

  local game = item:get_game()
  local map = game:get_map()
  local hero = map:get_hero()
  local is_diggable = map:is_digging_allowed()
  local index1,index2,index3,index4 = map:get_hero_digging_index(hero)
  map.shovel_treasures = map.shovel_treasures or {}
  hero:freeze()
  if item:can_dig() then
    hero:set_animation("shovel", function()
      hero:unfreeze()
    end)
    local x,y,layer = map:get_position_dig()
    map:set_square_diggable(index1, false)
    map:set_square_diggable(index2, false)
    map:set_square_diggable(index3, false)
    map:set_square_diggable(index4, false)
    sol.audio.play_sound("dig")
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
      end)
  else
      hero:set_animation("shovel_fail", function()
        hero:unfreeze()
      end)
     sol.audio.play_sound("sword_tapping")
  end
  self:set_finished()

end


-- Check if hero can dig
function item:can_dig()

  local game = item:get_game()
  local map = game:get_map()
  local hero = map:get_hero()
  local active = false
  local x,y, layer = map:get_position_dig()
  local ground = map:get_ground(x, y, layer)
  local index1,index2,index3,index4 = map:get_entity_position_indexes(hero)
  print(index1,index2,index3,index4)
  local is_diggable = map:is_digging_allowed()
  local is_squares_diggables = true
  if map:is_square_diggable(index1) and map:is_square_diggable(index2) and map:is_square_diggable(index3) and map:is_square_diggable(index4) then
    is_squares_diggables = false
  end
  if is_diggable and ground == "traversable" and not is_squares_diggable then
    active = true
  end
print(active)
  return active

end

function map_meta:get_position_dig()

  local hero = self:get_hero()
  local x,y,layer = hero:get_position()
  local direction = hero:get_direction()
  if direction == 0 then
   x = x + 16
  elseif direction == 1 then
   y = y - 16
 elseif direction == 2 then
   x = x - 16
 elseif direction == 3 then
   y = y + 8
 end
  x = math.floor(x / 8) * 8
  y = math.floor(y / 8) * 8

  return x,y, hero:get_layer()

end

-- Check if digging is allowed
function map_meta:is_digging_allowed()

  self.is_diggable = self.is_diggable or false

  return self.is_diggable

end

-- Disable / Enable digging on map
function map_meta:set_digging_allowed(is_diggable)
  
  self.is_diggable = is_diggable

end

function map_meta:is_square_diggable(square_index)

  self.grounds_dug = self.grounds_dug or {}
  if self.grounds_dug[square_index] then
    return false
  end

  return true

end

function map_meta:set_square_diggable(square_index, diggable)

  self.grounds_dug = self.grounds_dug or {}
  if diggable then
    self.grounds_dug[square_index] = false
  else
    self.grounds_dug[square_index] = true
  end
end

function map_meta:get_entity_position_indexes(entity)

  local x,y,layer = entity:get_position()
  --x = math.floor(x / 16) * 16
  --y = math.floor(y / 16) * 16
  local cols, rows = self:get_size8()
  local index1 = self:get_index_from_position(x, y)
  
return index1, index1 + 1, index1 + cols, index1 + cols + 1

end

function map_meta:get_hero_digging_index()

local x,y = self:get_position_dig()
local cols, rows = self:get_size8()
local index1 = self:get_index_from_position(x, y)
  
return index1, index1 + 1, index1 + cols, index1 + cols + 1

end

function map_meta:get_index_from_position(x, y)

 local i = math.floor(y / 8)
 local j = math.floor(x / 8)
 local cols, rows = self:get_size8()
 local index = i * cols + j
  
return index 

end

function map_meta:get_size8()

  local width,height = self:get_size()

  return width / 16, height / 16

end

game:register_event("on_map_changed", function(game, map)

  map.shovel_treasures = map.shovel_treasures or {}
  for pickable in map:get_entities("auto_shovel") do
    local index = map:get_entity_position_index(pickable)
    map.shovel_treasures[index] = pickable
    pickable:set_enabled(false)
  end

end)


