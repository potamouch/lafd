local travel_manager = {}

travel_manager.from_id = 1
travel_manager.to_id = 1
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
  
  print("init")
  from_id = id
  for room = 1, sprite:get_num_directions(animation) - 1 do
  end

end

function travel_manager:launch_step_1(map)

  print("step 1")
  travel_manager:launch_step_2(map)

end

function travel_manager:launch_step_2(map)

  print("step 2")
  local map_id = positions_info[to_id]['map_id']
  local destination_name = positions_info[to_id]['destination_name']
  hero:teleport(map_id, destination_name)

end

function travel_manager:launch_step_3(map)

end


return travel_manager