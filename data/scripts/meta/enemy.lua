-- Initialize enemy behavior specific to this quest.

local enemy_meta = sol.main.get_metatable("enemy")
local enemy_manager = require("scripts/maps/enemy_manager")

-- Helper function to inflict an explicit reaction from a scripted weapon.
-- TODO this should be in the Solarus API one day
function enemy_meta:receive_attack_consequence(attack, reaction)

  if type(reaction) == "number" then
    self:hurt(reaction)
  elseif reaction == "immobilized" then
    self:immobilize()
  elseif reaction == "scared" then
    sol.timer.stop_all(self)  -- Stop the towards_hero behavior.
      local hero = self:get_map():get_hero()
      local angle = hero:get_angle(self)
      local movement = sol.movement.create("straight")
      movement:set_speed(128)
      movement:set_angle(angle)
      movement:start(self)
      sol.timer.start(self, 400, function()
        self:restart()
      end)
  elseif reaction == "protected" then
    sol.audio.play_sound("sword_tapping")
  elseif reaction == "custom" then
    if self.on_custom_attack_received ~= nil then
      self:on_custom_attack_received(attack)
    end
  end

end

function enemy_meta:launch_small_boss_dead(music)

  local game = self:get_game()
  local map = game:get_map()
  local dungeon = game:get_dungeon_index()
  local savegame = "dungeon_" .. dungeon .. "_small_boss"
  local door_prefix = "door_group_small_boss"
  sol.audio.play_music(music)
  game:set_value(savegame, true)
  map:open_doors(door_prefix)
  enemy_manager:create_teletransporter_if_small_boss_dead(map, true)
  local x,y,layer = self:get_position()
  map:create_pickable({
    x = x,
    y = y,
    layer = layer, 
    treasure_name = "fairy",
    treasure_variant = 1
  })

end

function enemy_meta:launch_boss_dead()

  local game = self:get_game()
  local map = game:get_map()
  local dungeon = game:get_dungeon_index()
  local savegame = "dungeon_" .. dungeon .. "_boss"
  local door_prefix = "door_group_boss"
  sol.audio.play_music("maps/dungeons/instruments")
  game:set_value(savegame, true)
  map:open_doors(door_prefix)
  local heart_container = map:get_entity("heart_container")
  heart_container:set_enabled(true)

end

-- Attach a custom damage to the sprites of the enemy.
function enemy_meta:get_sprite_damage(sprite)
return (sprite and sprite.custom_damage) or self:get_damage()
end

function enemy_meta:set_sprite_damage(sprite, damage)
  sprite.custom_damage = damage
end

-- Warning: do not override these functions if you use the "custom shield" script.
function enemy_meta:on_attacking_hero(hero, enemy_sprite)
  local enemy = self
  -- Do nothing if enemy sprite cannot hurt hero.
  if enemy:get_sprite_damage(enemy_sprite) == 0 then return end
  local collision_mode = enemy:get_attacking_collision_mode()
  if not hero:overlaps(enemy, collision_mode) then return end
  -- Do nothing when shield is protecting.
  if hero.is_shield_protecting_from_enemy
      and hero:is_shield_protecting_from_enemy(enemy, enemy_sprite) then
    return
  end
-- Otherwise, hero is not protected. Use built-in behavior.
  local damage = enemy:get_damage()
  if enemy_sprite then
    hero:start_hurt(enemy, enemy_sprite, damage)
  else
    hero:start_hurt(enemy, damage)
  end
end


return true
