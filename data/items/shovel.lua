-- Shovel
local item = ...
local map_meta = sol.main.get_metatable("map")

function item:on_created()

  self:set_savegame_variable("possession_shovel")
  self:set_assignable(true)

end


function item:on_using()

  local game = item:get_game()
  local map = game:get_map()
  local hero = map:get_hero()
  local is_diggable = map:is_digging_allowed()
  local index = map:get_entity_position_index(hero)
  map.grounds_dug = map.grounds_dug or {}
  hero:freeze()
  if item:can_dig() then
    hero:set_animation("shovel", function()
      hero:unfreeze()
    end)
    local x,y,layer = map:get_position_dig()
    map:set_square_diggable(index, false)
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
  map:create_pickable{
        layer = layer,
        x = x,
        y = y,
        treasure_name = "random",
        treasure_variant = 1,
      }
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
  local index = map:get_entity_position_index(hero)
  local is_diggable = map:is_digging_allowed()
  if is_diggable and ground == "traversable" and not map.grounds_dug[index] then
    active = true
  end

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
   y = y + 16
 end
  x = math.floor(x / 16) * 16
  y = math.floor(y / 16) * 16

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

  if map.grounds_dug[square_index] then
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

function map_meta:get_entity_position_index(entity)

  local x,y,layer = entity:get_position()
  if entity:get_type() == "hero" then
        x,y = self:get_position_dig()
  else
    x = math.floor(x / 16) * 16
    y = math.floor(y / 16) * 16
  end
 local i = math.floor(y / 16)
 local j = math.floor(x / 16)
 local width,height = self:get_size()
 local cols = width / 16
 local index = i * cols + j
  
return index 

end


