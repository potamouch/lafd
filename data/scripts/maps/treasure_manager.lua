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

  sol.audio.play_music("dungeons_instrument")

end


return treasure_manager