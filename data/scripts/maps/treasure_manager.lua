local treasure_manager = {}

function treasure_manager:appear_when_enemies_dead(map, enemies_group, type, treasure, variant, x, y, layer, save)
    
  local function enemy_on_dead()
    if not map:has_entities(enemies_group) then
         self:appear(map, type, treasure, variant, x, y, layer, save)
    end
  end

  for enemy in map:get_entities(enemies_group) do
    enemy.on_dead = enemy_on_dead
  end

end

function treasure_manager:appear(map, type, treasure, variant, x, y, layer, save)

  if type == "chest" then
          sol.audio.play_sound("secret_1")
          map:create_chest{
                sprite = "entities/chest",
                treasure_name = treasure,
                treasure_variant = variant,
                treasure_savegame_variable = save,
                x = x,
                y = y,
                layer = layer
              }
      else
           map:create_pickable{
                treasure_name = treasure,
                treasure_variant = variant,
                treasure_savegame_variable = save,
                x = x,
                y = y,
                layer = layer
              }
    end
        
end

function treasure_manager:get_instrument(map, dungeon)

    --TODO
  sol.audio.play_music("dungeons_instrument")
     --sol.audio.play_music("dungeon_"..dungeon.."instrument")
     --return false
    --end

end


return treasure_manager