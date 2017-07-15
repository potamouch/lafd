local door_manager = {}



-- Open doors when all ennemis in the room are dead
function door_manager:open_when_enemies_dead(map, enemies_group, doors_group)


  local function enemy_on_dead()

    if not map:has_entities(enemies_group) then
        map:open_doors(doors_group)
        sol.audio.play_sound("secret_1")
   end
  end

    for enemy in map:get_entities(enemies_group) do
      enemy.on_dead = enemy_on_dead
    end

end


-- Close doors if ennemis in the room are not dead
function door_manager:close_if_enemies_not_dead(map, enemies_group, doors_group)

   if map:has_entities(enemies_group) then
        map:close_doors(doors_group)
  end
        
end


return door_manager