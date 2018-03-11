local travel_manager = {}

travel_manager.from_id = 1
travel_manager.to_id = 1
travel_manager.transporter = nil
travel_manager.movement = nil
local positions_info = {
  [1] = {
        map_id = "out/b3_prairie",
        destination_name = "travel_destination",
        savegame = "travel_1"
  },
  [2] = {
        map_id = "out/a1_west_mt_tamaranch",
        destination_name = "travel_destination",
        savegame = "travel_2"
  },
  [3] = {
       map_id = "out/d1_east_mt_tamaranch",
        destination_name = "travel_destination",
        savegame = "travel_3"
  },
  [4] = {
        map_id = "out/d4_yarna_desert",
        destination_name = "travel_destination",
        savegame = "travel_4"
  }
}

function travel_manager:init(map, from_id)
  
  local game = map:get_game()
  local savegame = positions_info[from_id]['savegame']
  game:set_value(savegame, 1)
  travel_manager.from_id = from_id
  travel_manager.transporter = map:get_entity('travel_transporter')
  travel_manager.transporter:set_enabled(false)
  local i = travel_manager.from_id + 1
  if i > 4 then
    i = 1
  end
  while game:get_value(positions_info[i]['savegame']) == nil do
    i = i + 1
    if i > 4 then
      i = 1
    end
  end
  travel_manager.to_id = i

end

function travel_manager:launch_step_1(map)

  local game = map:get_game()
  local hero = map:get_hero()
  local x_hero,y_hero = hero:get_position()
  y_hero = y_hero - 16
  local x_transporter,y_transporter = travel_manager.transporter:get_position()
  local xy = { x = x_transporter, y = y_transporter }
  local direction4 = travel_manager.transporter:get_direction4_to(hero)
  local transporter_sprite = travel_manager.transporter:get_sprite()
  travel_manager.transporter:set_enabled(true)
  game:set_pause_allowed(false)
  game:set_suspended(true)
  hero:freeze()
  transporter_sprite:set_animation("walking")
  transporter_sprite:set_direction(direction4)
  transporter_sprite:set_ignore_suspend(true)
  travel_manager.movement = sol.movement.create("target")
  function travel_manager.movement:on_position_changed(coord_x, coord_y)
    travel_manager.transporter:set_position(coord_x, coord_y)
  end
  travel_manager.movement:set_speed(60)
  travel_manager.movement:set_ignore_obstacles(true)
  travel_manager.movement:set_target(x_hero, y_hero)
  travel_manager.movement:start(xy, function() 
        travel_manager.movement:stop()
        travel_manager:launch_step_2(map)
  end)

end

function travel_manager:launch_step_2(map)


end

function travel_manager:launch_step_3(map)

  local hero = map:get_hero()
  local map_id = positions_info[travel_manager.to_id]['map_id']
  local destination_name = positions_info[travel_manager.to_id]['destination_name']
  hero:teleport(map_id, destination_name)

end

function travel_manager:launch_step_4(map)

end


return travel_manager