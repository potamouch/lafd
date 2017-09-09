local game_manager = {}
local game_over_menu = {}
local map_metatable = sol.main.get_metatable("map")


local gravity = 5       -- How often to update gravity in milliseconds (move the hero down one pixel this often). Default is every 10 ms.
local jump_height = 40  -- How high to make the hero go when he jumps (in pixels). Default is 40.
local multi_jump = 2    -- How many times to allow the character to jump. Default is 1, or enter 0 to disable jumping entirely.
local state             -- "stopped", "walking", "jumping", "ladder", "dying", "action", "attack"
local last_anim

local side_view_manager = {}
 
function side_view_manager:manage_map(map)

    sol.timer.start(gravity, function()
        -- Gravity: move entities down one pixel on every update if there's no collision.
        --   (like with the ground or a platform) and hero not jumping or on a ladder.
        local hero = map:get_hero()
        local x, y, l = hero:get_position()
        if state ~= "jumping" and map:get_ground(hero:get_position()) ~= "ladder" then
          if not hero:test_obstacles(0, 1) then hero:set_position(x, (y + 1), l) end
        elseif state == "jumping" then
          for i = 1, jump_height do
            if not hero:test_obstacles(0, -1) then hero:set_position(x, (y - 1), l) end
          end
          sol.timer.start(gravity * jump_height, function()
            if self:is_command_pressed("right") or self:is_command_pressed("left") then
              state = "walking"
            else
              state = "stopped"
            end
          end)
          hero:set_animation(state)
        end
        
        for entity in map:get_entities("g_") do
          local gx, gy, gl = entity:get_position()
          if not entity:test_obstacles(0, 1) then
            entity:set_position(gx, (gy + 1), gl)
          end
        end
      return true
    end)
  return true

end

return side_view_manager

  