-- Initialize hero behavior specific to this quest.

local hero_meta = sol.main.get_metatable("hero")

function hero_meta:on_position_changed(x, y, layer)

  local game = self:get_game()
  local map = game:get_map()
  local world = map:get_world()
  local square_x = 0
  local square_y = 0
  local square_mini_x = 0
  local square_mini_y = 0
  local square_total_x = 0
  local square_total_y = 0
  local map_max_x = 3840
  local map_max_y = 3072
  if world == "outside_world" then
    local map_x, map_y = map:get_location()
    local map_size_x, map_size_y = map:get_size()
    square_x = math.floor((map_x + 960) / (960) - 1)
    square_y = math.floor((map_y + 768) / (768) - 1)
    if x == 0 then
      square_min_x = 0
    else
      square_min_x = math.floor((x+240)/(240)-1)
    end
    if y == 0 then
      square_min_y = 0
    else
      square_min_y = math.floor((y+192)/(192)-1)
    end
    square_total_x = (4*square_x)+square_min_x
    square_total_y = (4*square_y)+square_min_y
    game:set_value("map_discovering_" .. square_total_x .. "_" .. square_total_y, true)
    game:set_value("map_hero_position_x", square_total_x)
    game:set_value("map_hero_position_y", square_total_y)
  end
end

return true
