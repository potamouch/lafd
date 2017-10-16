local treasure_manager = {}

function treasure_manager:appear_chest_when_enemies_dead(map, enemy_prefix, treasure, placeholder, savegame)
    
  local function enemy_on_dead()
    local game = map:get_game()
    if not map:has_entities(enemy_prefix) then
      if not game:get_value(savegame) then
         self:appear_chest(map, treasure, placeholder, savegame, true)
      end
    end
  end

  for enemy in map:get_entities(enemy_prefix) do
    enemy.on_dead = enemy_on_dead
  end

end

function treasure_manager:appear_pickable_when_enemies_dead(map, enemy_prefix, treasure, placeholder, savegame)
    
  local function enemy_on_dead()
    local game = map:get_game()
    if not map:has_entities(enemy_prefix) then
      if not game:get_value(savegame) then
         self:appear_pickable(map, treasure, placeholder, savegame, true)
      end
    end
  end

  for enemy in map:get_entities(enemy_prefix) do
    enemy.on_dead = enemy_on_dead
  end

end

function treasure_manager:appear_chest_when_savegame_exist(map, savegame, treasure, placeholder)
    
  local game = map:get_game()
  if game:get_value(savegame) then
         self:appear_chest(map, treasure, placeholder, savegame, false)
  end

end


function treasure_manager:appear_chest(map, treasure, placeholder, savegame, sound)

        local item, variant, savegame_variable = unpack(treasure)
        local placeholder = map:get_entity(placeholder)
        local x,y,layer = placeholder:get_position()
        local game = map:get_game()
        placeholder:set_enabled(false)
        if sound ~= nil and sound ~= false then
          sol.audio.play_sound("secret_1")
        end
        if savegame ~= nil and savegame ~= false then
          game:set_value(savegame,  true)
        end
        map:create_chest{
              sprite = "entities/chest",
              treasure_name = item,
              treasure_variant = variant,
              treasure_savegame_variable = savegame_variable,
              x = x,
              y = y,
              layer = layer
            }
        
end

function treasure_manager:appear_pickable(map, treasure, placeholder, savegame, sound)

       local item, variant, savegame_variable = unpack(treasure)
       local placeholder = map:get_entity(placeholder)
       local x,y,layer= placeholder:get_position()
       local game = map:get_game()
       placeholder:set_enabled(false)
        if sound ~= nil and sound ~= false then
          sol.audio.play_sound("secret_1")
        end
        if savegame ~= nil and savegame ~= false then
          game:set_value(savegame,  true)
        end
       map:create_pickable{
            treasure_name = item,
            treasure_variant = variant,
            treasure_savegame_variable = savegame_variable,
            x = x,
            y = y,
            layer = layer
          }
        
end

function treasure_manager:get_instrument(map, dungeon)

  local game = map:get_game()
  local dungeon = game:get_dungeon_index()
  local hero = map:get_entity("hero")
  local x_hero,y_hero, layer_hero = hero:get_position()
  local timer
  hero:freeze()
  hero:set_animation("brandish")
  local instrument_entity = map:create_custom_entity({
      name = "brandish_sword",
      sprite = "entities/items",
      x = x_hero,
      y = y_hero - 24,
      width = 16,
      height = 16,
      layer = layer_hero,
      direction = 0
    })
  instrument_entity:get_sprite():set_animation("instrument_" .. dungeon)
  instrument_entity:get_sprite():set_direction(0)
   sol.audio.stop_music()
  sol.audio.play_sound("instruments/instrument")
  timer = sol.timer.start(map, 7000, function() 
  end)
  timer:set_suspended_with_map(false)
  sol.timer.start(2000, function()
      game:start_dialog("_treasure.instrument_" .. dungeon ..".1", function()
        local remaining_time = timer:get_remaining_time()
        timer:stop()
        sol.timer.start(map, remaining_time, function()
          treasure_manager:play_instrument(map)
        end)
      end)
  end)
end

function treasure_manager:play_instrument(map)

     local game = map:get_game()
     local hero = map:get_entity("hero")
     local dungeon = game:get_dungeon_index()
     local opacity = 0
     local dungeon_infos = game:get_dungeon()
     sol.audio.play_sound("instruments/instrument_" .. dungeon)
      sol.timer.start(8000, function()
        local white_surface =  sol.surface.create(320, 256)
        white_surface:fill_color({255, 255, 255})
        function map:on_draw(dst_surface)
          white_surface:set_opacity(opacity)
          white_surface:draw(dst_surface)
          opacity = opacity + 1
          if opacity > 255 then
            opacity = 255
          end
        end
        sol.timer.start(3000, function()
            game:start_dialog("maps.dungeons.".. dungeon ..".indication", function()
              local map_id = dungeon_infos["teletransporter_end_dungeon"]["map_id"]
              local destination_name = dungeon_infos["teletransporter_end_dungeon"]["destination_name"]
              hero:teleport(map_id, destination_name, "fade")
            end)
        end)
      end)
end

return treasure_manager