local enemy_manager = {}

enemy_manager.is_transported = false

function enemy_manager:execute_when_vegas_dead(map, enemy_prefix)

  local function enemy_on_symbol_fixed(enemy)
    local direction = enemy:get_sprite():get_direction()
    local all_immobilized = true
    local all_same_direction = true
    for vegas in map:get_entities(enemy_prefix) do
      local sprite = vegas:get_sprite()
      if not vegas:is_symbol_fixed() then
        all_immobilized = false
      end
      if vegas:get_sprite():get_direction() ~= direction then
        all_same_direction = false
      end
    end

    if not all_immobilized then
      return
    end

    sol.timer.start(map, 500, function()
      if not all_same_direction then
        sol.audio.play_sound("wrong")
        for vegas in map:get_entities(enemy_prefix) do
          vegas:set_symbol_fixed(false)
        end
        return
      end
      -- Kill them.
    for vegas in map:get_entities(enemy_prefix) do
        vegas:set_life(0)
      end
    end)
  end
  for enemy in map:get_entities(enemy_prefix) do
    local sprite = enemy:get_sprite()
    enemy.on_symbol_fixed = enemy_on_symbol_fixed
  end
end

function enemy_manager:create_teletransporter_if_small_boss_dead(map, sound)

    local game = map:get_game()
    local dungeon = game:get_dungeon_index()
    local savegame = "dungeon_" .. dungeon .. "_small_boss"
    if game:get_value(savegame) then
      local placeholder_teletransporter_A = map:get_entity("teletransporter_A")
      local placeholder_teletransporter_B = map:get_entity("teletransporter_B")
      local teletransporter_A_x,  teletransporter_A_y,  teletransporter_A_layer = placeholder_teletransporter_A:get_position()
      local teletransporter_B_x,  teletransporter_B_y,  teletransporter_B_layer = placeholder_teletransporter_B:get_position()
      local teletransporter_A = map:create_custom_entity{
        x = teletransporter_A_x - 8,
        y = teletransporter_A_y - 16,
        width = 24,
        height = 24,
        direction = 0,
        sprite = "entities/teletransporter_dungeon",
        layer = teletransporter_A_layer,
      }
      local teletransporter_B = map:create_custom_entity{
        x = teletransporter_B_x - 8 ,
        y = teletransporter_B_y - 16,
        width = 24,
        height = 24,
        direction = 0,
        sprite = "entities/teletransporter_dungeon",
        layer = teletransporter_B_layer,
        sound = "teletransporter"
      }
      teletransporter_A:add_collision_test("overlapping", function(teletransporter, hero)
        local hero_sprite = hero:get_sprite()
        if enemy_manager.is_transported  == false and hero:get_type() == "hero" then
          enemy_manager.is_transported  = true
          game:set_suspended(true)
          game:set_pause_allowed(false)
          teletransporter_A:get_sprite():set_ignore_suspend(true)
          hero_sprite:set_ignore_suspend(true)
          hero_sprite:set_animation("teleporting")
          sol.audio.play_sound("teletransporter")
          function hero_sprite:on_animation_finished(animation)
            if animation == "teleporting" then
              game:set_suspended(false)
              game:set_pause_allowed(true)
              teletransporter_B:get_sprite():set_ignore_suspend(false)
              hero_sprite:set_ignore_suspend(false)
              hero:teleport(map:get_id(), "teletransporter_destination_B")
              enemy_manager.is_transported  = false
            end
          end
        end
      end)
      teletransporter_B:add_collision_test("overlapping", function(teletransporter, hero)
        local hero_sprite = hero:get_sprite()
        if enemy_manager.is_transported  == false and hero:get_type() == "hero" then
          enemy_manager.is_transported  = true
          game:set_suspended(true)
          game:set_pause_allowed(false)
          teletransporter_B:get_sprite():set_ignore_suspend(true)
          hero_sprite:set_ignore_suspend(true)
          hero_sprite:set_animation("teleporting")
          sol.audio.play_sound("teletransporter")
          function hero_sprite:on_animation_finished(animation)
            if animation == "teleporting" then
              game:set_suspended(false)
              game:set_pause_allowed(true)
              teletransporter_B:get_sprite():set_ignore_suspend(false)
              hero_sprite:set_ignore_suspend(false)
              hero:teleport(map:get_id(), "teletransporter_destination_A")
              enemy_manager.is_transported  = false
            end
          end
        end
      end)
      if sound ~= nil and sound ~= false then
        sol.audio.play_sound("teletransporter_appear")
      end
  end

end

-- Launch battle if small boss in the room are not dead
function enemy_manager:launch_small_boss_if_not_dead(map)

    local game = map:get_game()
    local door_prefix = "door_group_small_boss"
    local dungeon = game:get_dungeon_index()
    local dungeon_infos = game:get_dungeon()
    local savegame = "dungeon_" .. dungeon .. "_small_boss"
    local placeholder = "placeholder_small_boss"
    if game:get_value(savegame) then
      return false
    end
    local placeholder = map:get_entity(placeholder)
    local x,y,layer = placeholder:get_position()
    local game = map:get_game()
    local music = sol.audio.get_music()
    placeholder:set_enabled(false)
    local enemy = map:create_enemy{
       breed = dungeon_infos["small_boss"]["breed"],
       direction = 2,
        x = x,
        y = y,
        layer = layer
      }
   enemy:register_event("on_dead", function()
      enemy:launch_small_boss_dead(music)
   end)
    map:close_doors(door_prefix)
    sol.audio.play_music("maps/dungeons/small_boss")
        
end

-- Launch battle if  boss in the room are not dead
function enemy_manager:launch_boss_if_not_dead(map)

    local game = map:get_game()
    local door_prefix = "door_group_boss"
    local dungeon = game:get_dungeon_index()
    local dungeon_infos = game:get_dungeon()
    local savegame = "dungeon_" .. dungeon .. "_boss"
    local placeholder = "placeholder_boss"
    if game:get_value(savegame) then
      return false
    end
    local placeholder = map:get_entity(placeholder)
    local x,y,layer = placeholder:get_position()
    placeholder:set_enabled(false)
    local enemy = map:create_enemy{
      breed = dungeon_infos["boss"]["breed"],
      direction = 2,
      x = x,
      y = y,
      layer = layer
    }
     enemy:register_event("on_dead", function()
        enemy:launch_boss_dead(door_prefix, savegame)
     end)
    map:close_doors(door_prefix)
    sol.audio.play_music("maps/dungeons/boss")
    game:start_dialog("maps.dungeons." .. dungeon .. ".boss_welcome")
        
end

return enemy_manager