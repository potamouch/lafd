local mad_bat_manager = {}
local laser_manager = require("scripts/maps/laser_manager")
local is_awake = false
mad_bat_manager.items = {"magic_powder", "bombs", "arrows"}
mad_bat_manager.item_id = 0

-- Init Mad bat
function mad_bat_manager:init_map(map, mad_bat_name, savegame)

  local game = map:get_game()
  local mad_bat = map:get_entity(mad_bat_name)
  local hero = map:get_hero()
  mad_bat:add_collision_test("touching", function(mad_bat, other, mad_bat_sprite, other_sprite)
    if other:get_type() == "custom_entity" then
      local other_model = other:get_model()
      local savegame_value = game:get_value(savegame)
      if other_model == "fire" and is_awake == false and savegame_value == nil then
        is_awake = true
         hero:set_direction(1)
         mad_bat_manager:awakening(map, mad_bat_name, savegame)
      end
    end
  end)
        
end

function mad_bat_manager:awakening(map, mad_bat_name, savegame)

  local game = map:get_game()
  local mad_bat = map:get_entity(mad_bat_name)
  local mad_bat_sprite = mad_bat:get_sprite()
  local hero = map:get_hero()
  local bat_x,bat_y,bat_layer =  mad_bat:get_position()
  local hero_x,hero_y,hero_layer =  hero:get_position()
  hero:set_animation("stopped")
  game:set_pause_allowed(false)
  game:set_suspended(true)
  bat_y = bat_y - 24
  local npc = map:create_custom_entity({
    name = mad_bat_name .. "_npc",
    sprite = "npc/mad_bat",
    x = bat_x,
    y = bat_y,
    width = 16,
    height = 16,
    layer = bat_layer + 1,
    direction = 3
  })
  local npc_sprite = npc:get_sprite()
  npc_sprite:set_ignore_suspend(true)
  npc.xy = { x = bat_x, y = bat_y}
  sol.audio.play_sound(mad_bat_name .. "_appear")
  local movement = sol.movement.create("target")
  movement:set_target(bat_x, bat_y - 32)
  movement:set_speed(50)
  movement:set_ignore_obstacles(true)
  movement:start(npc.xy, function()
    npc_sprite:set_frame_delay(100)
    local timer1 = sol.timer.start(map, 1000, function()
      local npc_x, npc_y,npc_layer =  npc:get_position()
      map:create_explosion({
        x = npc_x,
        y = npc_y,
        layer = npc_layer
      })
      sol.audio.play_sound("explosion")
      npc_sprite:set_animation("walking")
      local timer2 = sol.timer.start(map, 1000, function()
        game:start_dialog("scripts.meta.map.mad_bat_1", function()
          local timer3 = sol.timer.start(map, 500, function()
            mad_bat_manager:launch_dialog_item(map, mad_bat_name, savegame)
          end)
          timer3:set_suspended_with_map(false)
        end)
      end)
      timer2:set_suspended_with_map(false)
    end)
    timer1:set_suspended_with_map(false)
  end)
  function movement:on_position_changed(coord_x, coord_y)
    npc:set_position(coord_x, coord_y)
  end
end

function mad_bat_manager:launch_dialog_item(map, mad_bat_name, savegame)

  local game = map:get_game()
  local item_id = mad_bat_manager.item_id
  local item_current = mad_bat_manager.item_id
  local item_found = nil
  -- Check nb items retrieved
  local nb= 0
  local nb_total= 0
  for key,value in pairs(mad_bat_manager.items) do
     nb_total = nb_total + 1
    if game:get_value('mad_bat_item_' .. key) then
      nb = nb + 1
    end
  end
  if nb_total - nb > 1 then
    while item_found == nil do
        item_id = item_id + 1
        if item_id > 3 then
          item_id = 1
        end
       if item_id ~= item_current and game:get_value('mad_bat_item_' .. item_id) == nil then
          item_found = item_id
       end
     end
     mad_bat_manager.item_id = item_found
  end
  local item_name = mad_bat_manager.items[mad_bat_manager.item_id]
  game:start_dialog("scripts.meta.map.mad_bat_2_" .. item_name, function(answer)
    if answer == 1 then
      mad_bat_manager:launch_laser(map, mad_bat_name, savegame)
    else
      mad_bat_manager:launch_dialog_item(map, mad_bat_name, savegame)
    end
  end)

end

function mad_bat_manager:launch_laser(map, mad_bat_name, savegame)

  local game = map:get_game()
  local npc = map:get_entity(mad_bat_name .. "_npc")
  local npc_sprite = npc:get_sprite()
  npc_sprite:set_animation("cursing")
  function npc_sprite:on_animation_finished(animation)
    if animation == "cursing" then
      npc_sprite:set_animation("walking")
    --npc_sprite:set_animation("walking")
      local hero = map:get_hero()
      laser_manager:init_map(map, hero, npc, function()
        game:start_dialog("scripts.meta.map.mad_bat_3", function()
          npc:remove()
          sol.audio.play_sound(mad_bat_name .. "_disappear")
          game:set_pause_allowed(true)
          game:set_suspended(false)
          is_awake = false
          game:set_value( 'mad_bat_item_' .. mad_bat_manager.item_id, true)
          game:set_value(savegame, true)
          local item_name = mad_bat_manager.items[mad_bat_manager.item_id]
          if item_name == "magic_powder" then
            local item = game:get_item("magic_powders_counter")
            item:set_max_amount(40)
            item:set_amount(40)
          end
          if item_name == "arrows" then
            local item = game:get_item("arrow")
            --item:set_max_amount(40)
            --item:set_amount(40)
            -- todo
          end
          if item_name == "bombs" then
            local item = game:get_item("bombs_counter")
            item:set_max_amount(40)
            item:set_amount(40)
          end
        end)
      end)
    end
  end

end

return mad_bat_manager