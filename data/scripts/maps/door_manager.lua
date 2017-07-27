local door_manager = {}



-- Open doors when all ennemis in the room are dead
function door_manager:open_when_enemies_dead(map, enemy_prefix, door_prefix)


  local function enemy_on_dead()

    if not map:has_entities(enemy_prefix) then
        map:open_doors(door_prefix)
        sol.audio.play_sound("secret_1")
   end
  end

    for enemy in map:get_entities(enemy_prefix) do
      enemy.on_dead = enemy_on_dead
    end

end


-- Close doors if ennemis in the room are not dead
function door_manager:close_if_enemies_not_dead(map, enemy_prefix, door_prefix)

   if map:has_entities(enemy_prefix) then
        map:close_doors(door_prefix)
  end
        
end


return door_manager