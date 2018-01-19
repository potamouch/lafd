require("scripts/multi_events")
local flying_tile_manager = {}
flying_tile_manager.is_init = false
flying_tile_manager.is_launch = false
flying_tile_manager.timer = nil

function flying_tile_manager:init(map, enemy_prefix)
  
    if flying_tile_manager.is_init == false then
      flying_tile_manager.is_init = true
      map:set_entities_enabled(enemy_prefix .. "_enemy", false)
      map:set_entities_enabled(enemy_prefix .. "_after", false)
      map:set_entities_enabled(enemy_prefix .. "_before", true)
    end

end

function flying_tile_manager:reset(map, enemy_prefix)
  
    if flying_tile_manager.timer ~= nil then
      flying_tile_manager.timer:stop()
    end
    flying_tile_manager.is_launch = false
    flying_tile_manager.is_init = false
    map:set_entities_enabled(enemy_prefix .. "_enemy", false)
    map:set_entities_enabled(enemy_prefix .. "_after", false)
      map:set_entities_enabled(enemy_prefix .. "_before", true)
     for enemy in map:get_entities(enemy_prefix) do
        sol.timer.stop_all(enemy)
     end

end

  -- Start the attack of flying tiles
function flying_tile_manager:launch(map, enemy_prefix)
  
  if flying_tile_manager.is_launch == false then
    flying_tile_manager.is_launch = true
    local next_index = 1
    local function spawn_next()
      if map:get_entity(enemy_prefix .. "_enemy_" .. next_index) ~= nil then
        map:get_entity(enemy_prefix .. "_enemy_" .. next_index):set_enabled(true)
      end
      if map:get_entity(enemy_prefix .. "_after_" .. next_index) ~= nil then
        map:get_entity(enemy_prefix .. "_after_" .. next_index):set_enabled(true)
      end
      if map:get_entity(enemy_prefix .. "_before_" .. next_index .. "_1") ~= nil then
        map:get_entity(enemy_prefix .. "_before_" .. next_index .. "_1"):set_enabled(false)
      end
      if map:get_entity(enemy_prefix .. "_before_" .. next_index .. "_2") ~= nil then
        map:get_entity(enemy_prefix .. "_before_" .. next_index .. "_2"):set_enabled(false)
      end
      next_index = next_index + 1
    end
    local total = map:get_entities_count(enemy_prefix .. "_enemy")
    local spawn_delay = 1500  -- Delay between two flying tiles.
    map:set_entities_enabled(enemy_prefix .. "_enemy", false)
    map:set_entities_enabled(enemy_prefix .. "_after", false)
    map:set_entities_enabled(enemy_prefix .. "_before", true)
      -- Spawn a tile and schedule the next one.
      spawn_next()
      flying_tile_manager.timer = sol.timer.start(map, spawn_delay, function()
        spawn_next()
        return next_index <= total
      end)

      -- Play a sound repeatedly as long as at least one tile is moving.
      sol.timer.start(map, 150, function()
        sol.audio.play_sound("walk_on_grass")
        -- Repeat the sound until the last tile starts animation "destroy".
        local again = false
        local remaining = map:get_entities_count(enemy_prefix .. "_enemy")
        if remaining > 1 then
          again = true
        elseif remaining == 1 then
          for enemy in map:get_entities(enemy_prefix .. "_enemy_") do
            local sprite = enemy:get_sprite()
            if sprite and sprite:get_animation() ~= "destroy" then
              again = true
              break
            end
          end
        end
        return again
      end)
  end

end


return flying_tile_manager