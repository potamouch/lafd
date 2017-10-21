local entity = ...
local game = entity:get_game()
local map = entity:get_map()
local hero = game:get_hero()

local hero_meta = sol.main.get_metatable("hero")
local wall = nil

function entity:on_created()
  self:set_traversable_by(false)
end

function entity:on_interaction()

  local lift = 1
  --if self:get_sprite():get_name() == "entities/statue_dungeon_6" then
--    lift = 2
 -- end
  if game:get_ability("lift") < lift then
    return
  end

  local x, y, layer = hero:get_position()
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

  hero:set_invincible(true)
  hero:freeze()
  
  hero:get_sprite():set_animation("lifting_heavy")
  local shieldid = hero:get_shield_sprite_id()
  hero:set_shield_sprite_id("")

  sol.timer.start(hero, 1200, function()
    local stone = map:create_destructible{
      x = x,
      y = y,
      layer = layer,
      sprite = entity:get_sprite():get_animation_set(),
      weight = 1,
      ground = "wall",
      destruction_sound = "stone",
      damage_on_enemies = 4
    }
    hero:set_shield_sprite_id(shieldid)
    entity:remove()
    hero:unfreeze()
    hero:set_invincible(false)
    game:simulate_command_pressed("action")

    

    x, y, layer = hero:get_position()
    wall = map:create_wall{
      x = x-8,
      y = y-8,
      layer = layer,
      width = 16,
      height = 16,
      stops_hero = true
    }
  end)
end

hero_meta:register_event("notify_object_thrown", function(hero)
  if wall ~= nil then
    wall:remove()
  end
end)