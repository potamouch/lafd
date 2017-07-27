local treasure_manager = {}

function treasure_manager:appear_chest_when_enemies_dead(map, enemy_prefix, treasure, placeholder)
    
  local function enemy_on_dead()
    if not map:has_entities(enemy_prefix) then
         self:appear_chest(map, treasure, placeholder)
    end
  end

  for enemy in map:get_entities(enemy_prefix) do
    enemy.on_dead = enemy_on_dead
  end

end

function treasure_manager:appear_pickable_when_enemies_dead(map, enemy_prefix, treasure, placeholder)
    
  local function enemy_on_dead()
    if not map:has_entities(enemy_prefix) then
         self:appear_pickable(map, treasure, placeholder)
    end
  end

  for enemy in map:get_entities(enemy_prefix) do
    enemy.on_dead = enemy_on_dead
  end

end

function treasure_manager:appear_chest(map, treasure, placeholder)

        local item, variant, savegame_variable = unpack(treasure)
        local placeholder = map:get_entity(placeholder)
        local x,y,layer= placeholder:get_position()
        placeholder:set_enabled(false)
        sol.audio.play_sound("secret_1")
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

function treasure_manager:appear_pickable(map, treasure, placeholder)

       local item, variant, savegame_variable = unpack(treasure)
       local placeholder = map:get_entity(placeholder)
       local x,y,layer= placeholder:get_position()
       placeholder:set_enabled(false)
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