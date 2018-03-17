local travel_manager = {}
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
  local transporter = map:get_entity('travel_transporter')
  transporter:set_enabled(false)
  local i = from_id + 1
  if i > 4 then
    i = 1
  end
  while game:get_value(positions_info[i]['savegame']) == nil do
    i = i + 1
    if i > 4 then
      i = 1
    end
  end
  to_id = i
  if from_id ~= to_id then
    travel_manager:launch_step_1(map, from_id, to_id)
  end

end


function travel_manager:launch_step_1(map, from_id, to_id)

  local game = map:get_game()
  local hero = map:get_hero()
  local x_hero,y_hero = hero:get_position()
  local transporter = map:get_entity('travel_transporter')
  y_hero = y_hero - 16
  local x_transporter,y_transporter = transporter:get_position()
  transporter.xy = { x = x_transporter, y = y_transporter }
  local direction4 = transporter:get_direction4_to(hero)
  local transporter_sprite = transporter:get_sprite()
  transporter:set_enabled(true)
  game:set_pause_allowed(false)
  game:set_suspended(true)
  hero:get_sprite():set_direction(3)
  hero:freeze()
  transporter_sprite:set_animation("walking")
  transporter_sprite:set_direction(direction4)
  transporter_sprite:set_ignore_suspend(true)
  local movement = sol.movement.create("target")
  function movement:on_position_changed(coord_x, coord_y)
    transporter:set_position(coord_x, coord_y)
  end
  movement:set_speed(150)
  movement:set_ignore_obstacles(true)
  movement:set_target(x_hero, y_hero)
  movement:start(transporter.xy, function() 
        movement:stop()
        game:set_suspended(false)
        travel_manager:launch_step_2(map, from_id, to_id)
  end)

end

function travel_manager:launch_step_2(map, from_id, to_id)

  local game = map:get_game()
  local hero = map:get_hero()
  local x_hero,y_hero, layer_hero = hero:get_position()
  local transporter = map:get_entity('travel_transporter')
  y_hero = y_hero - 16
  local x_transporter,y_transporter, layer_transporter = transporter:get_position()
  local transporter_sprite = transporter:get_sprite()
  transporter_sprite:set_direction(3)
  hero:set_enabled(false)
  local hero_entity = map:create_custom_entity({
    name = "hero",
    sprite = "hero/tunic1",
    x = x_transporter,
    y = y_transporter + 16,
    width = 24,
    height = 24,
    layer = layer_transporter,
    direction = 0
  })
 hero_entity:get_sprite():set_animation("flying")
 hero_entity:get_sprite():set_direction(3)
 local movement = sol.movement.create("straight")
 movement:set_speed(30)
 movement:set_angle(math.pi / 2)
 movement:set_max_distance(128)
 movement:set_ignore_obstacles(true)
 movement:start(transporter, function()
    travel_manager:launch_step_3(map, from_id, to_id)
 end)
 function movement:on_position_changed()
    local x_transporter,y_transporter, layer_transporter = transporter:get_position()
    y_transporter = y_transporter + 16
    hero_entity:set_position(x_transporter, y_transporter, layer_transporter)
 end
  
end

function travel_manager:launch_step_3(map, from_id, to_id)

  local hero = map:get_hero()
  local map_id = positions_info[to_id]['map_id']
  local destination_name = positions_info[to_id]['destination_name']
  travel_manager:launch_step_4(map, from_id, to_id)

end

function travel_manager:launch_step_4(map, from_id, to_id)

  local game = map:get_game()
  local hero = map:get_hero()
  local map_id = positions_info[to_id]['map_id']
  local destination_name = positions_info[to_id]['destination_name']
  hero:teleport(map_id, destination_name)
  hero:set_enabled(true)

end


return travel_manager