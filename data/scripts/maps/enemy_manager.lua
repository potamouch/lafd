local enemy_manager = {}


function enemy_manager:execute_when_vegas_dead(map, enemies_group)

  local function enemy_on_symbol_fixed(enemy)
    local direction = enemy:get_sprite():get_direction()
    local all_immobilized = true
    local all_same_direction = true
    for vegas in map:get_entities(enemies_group) do
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
        for vegas in map:get_entities(enemies_group) do
          vegas:set_symbol_fixed(false)
        end
        return
      end
      -- Kill them.
    for vegas in map:get_entities(enemies_group) do
        vegas:set_life(0)
      end
    end)
  end
  for enemy in map:get_entities(enemies_group) do
    local sprite = enemy:get_sprite()
    enemy.on_symbol_fixed = enemy_on_symbol_fixed
  end
end

-- Launch battle if small boss in the room are not dead
function enemy_manager:launch_small_boss_if_not_dead(map, save, doors_group)

    map:close_doors(doors_group)
    sol.audio.play_music("boss_small")
        
end

-- Launch battle if  boss in the room are not dead
function enemy_manager:launch_boss_if_not_dead(map, save, doors_group)

    map:close_doors(doors_group)
    sol.audio.play_music("boss")
        
end

return enemy_manager