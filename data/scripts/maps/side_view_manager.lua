require("scripts/multi_events")
local game_manager = {}
local game_over_menu = {}
local map_metatable = sol.main.get_metatable("map")
local gravity = 5       -- How often to update gravity in milliseconds (move the hero down one pixel this often). Default is every 10 ms.
local jump_height = 40  -- How high to make the hero go when he jumps (in pixels). Default is 40.
local state             -- "stopped", "walking", "jumping", "ladder", "dying", "action", "attack"
local last_anim
local is_side_view = false

local side_view_manager = {}

function map:get_side_view()

  return is_side_view

end

function map:is_side_view()

  if map:get_side_view()
    return true
  end

  return false

end
 
function side_view_manager:manage_map(map)

    local game = map:get_game()
    local item_feather = game:get_item("feather")
    item_feather:set_max_height(32)
    sol.timer.start(gravity, function()
        -- Gravity: move entities down one pixel on every update if there's no collision.
        --   (like with the ground or a platform) and hero not jumping or on a ladder.
        local hero = map:get_hero()
        local state = hero:get_state()
        if item_feather:is_jumping() then
          state = "jumping"
        end
        if state == "jumping" then
          hero:set_walking_speed(120)
        else
          hero:set_walking_speed(88)
        end
        local x, y, l = hero:get_position()
        if state ~= "jumping" then
          if map:get_ground(x, y, l) ~= "ladder"  and map:get_ground(x, y + 8, l) == "ladder" then 
            -- Nothing
          elseif map:get_ground(hero:get_position()) ~= "ladder" then
            if not hero:test_obstacles(0, 1) then 
              hero:set_position(x, (y + 1), l) 
            end
            end
        else 
          for i = 1, jump_height do
           -- if not hero:test_obstacles(0, -1) then hero:set_position(x, (y - 1), l) end
          end
          sol.timer.start(gravity * jump_height, function()
            if game:is_command_pressed("right") or game:is_command_pressed("left") then
              state = "walking"
            else
              state = "stopped"
            end
          end)
          hero:set_animation(state)
        end
        if state ~= "jumping" then 
          for entity in map:get_entities("g_") do
            local gx, gy, gl = entity:get_position()
            if not entity:test_obstacles(0, 1) then
              entity:set_position(gx, (gy + 1), gl)
            end
          end
        end
      return true
    end)
   map:register_event("on_finished", function()
    item_feather:set_max_height(16)
    item_feather:set_max_distance(31)
  end)
  return true
end

return side_view_manager

  